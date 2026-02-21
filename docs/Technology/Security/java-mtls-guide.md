---
title: Java mTLS (Mutual TLS) — Complete Guide
sidebar_position: 4
displayed_sidebar: technologySidebar
tags:
  - java
  - mtls
  - tls
  - security
  - ssl
  - authentication
  - https
  - keystores
description: Complete guide to implementing Mutual TLS in Java — keystores, truststores, certificates, and fully working code examples for servers, clients, Spring Boot, and OkHttp.
---

# Java mTLS (Mutual TLS) — Complete Guide 🔐☕

> **Goal:** Set up mTLS in Java from scratch — certificates, keystores, client, and server — with fully working code.

---

## What Is mTLS? (Quick Recap)

In standard TLS, only the **server** proves its identity with a certificate. The client (your browser or app) just trusts it anonymously.

In **Mutual TLS (mTLS)**, **both sides** present and verify certificates:

```
Java Client                          Java Server
     |--- "Here's my client cert" ──►  |
     |◄── "Here's my server cert" ───  |
     |    [Both verify each other]     |
     |═══ Encrypted + Authenticated ══ |
```

> 🪪 **Analogy:** Standard TLS is a hotel letting any guest in after checking the hotel's own credentials. mTLS is a secure military base — the guard checks *your* ID badge, and *you* verify the guard's credentials. Nobody gets through without mutual proof of identity.

This is used heavily in:
- Microservice-to-microservice communication
- Zero-trust network architectures
- API authentication at the transport layer (stronger than API keys)
- IoT device authentication

---

## Java's Certificate Infrastructure

Java manages certificates through two key abstractions:

### KeyStore — "Your Identity Wallet"

> 🗃️ **Analogy:** A KeyStore is like your physical wallet. It holds YOUR credentials — your private key and your certificate. When the other party says "prove who you are", you open your wallet and present your certificate.

A KeyStore holds:
- Your **private key**
- Your **certificate** (public key + identity, signed by a CA)
- Optionally, a chain of intermediate CA certificates

### TrustStore — "Your Approved Contacts List"

> 📋 **Analogy:** A TrustStore is like a guest list at a secure event. It contains the certificates (or CA certs) of parties you're willing to trust. If someone presents a certificate not signed by a CA in your TrustStore, you reject them — they're not on the list.

A TrustStore holds:
- **CA certificates** of authorities you trust
- When a remote party presents their certificate, Java checks if it was signed by one of these CAs

**In mTLS, both sides need both:**

| Component | Client Needs | Server Needs |
|---|---|---|
| **KeyStore** | Own cert + private key (to prove identity TO server) | Own cert + private key (to prove identity TO client) |
| **TrustStore** | Server's CA cert (to verify server is who it claims) | Client's CA cert (to verify client is who it claims) |

---

## Step 1: Generate Certificates with OpenSSL

Before writing any Java, you need the certificates. Here's a complete setup for local development.

### 1.1 Create a Certificate Authority (CA)

```bash
# Generate CA private key
openssl genrsa -out ca.key 4096

# Generate CA self-signed certificate (valid 10 years)
openssl req -new -x509 -days 3650 -key ca.key -out ca.crt \
  -subj "/C=US/ST=California/O=MyCompany/CN=MyCompany-CA"
```

### 1.2 Create the Server Certificate

```bash
# Generate server private key
openssl genrsa -out server.key 2048

# Generate server CSR (Certificate Signing Request)
openssl req -new -key server.key -out server.csr \
  -subj "/C=US/ST=California/O=MyCompany/CN=localhost"

# Sign the server certificate with our CA
openssl x509 -req -days 365 \
  -in server.csr \
  -CA ca.crt -CAkey ca.key -CAcreateserial \
  -out server.crt \
  -extensions v3_req \
  -extfile <(printf "[v3_req]\nsubjectAltName=DNS:localhost,IP:127.0.0.1")
```

### 1.3 Create the Client Certificate

```bash
# Generate client private key
openssl genrsa -out client.key 2048

# Generate client CSR
openssl req -new -key client.key -out client.csr \
  -subj "/C=US/ST=California/O=MyCompany/CN=java-client"

# Sign the client certificate with our CA
openssl x509 -req -days 365 \
  -in client.csr \
  -CA ca.crt -CAkey ca.key -CAcreateserial \
  -out client.crt
```

### 1.4 Convert to Java Keystores (PKCS12 / JKS)

Java uses `.p12` (PKCS12) or `.jks` (Java KeyStore) format. PKCS12 is preferred as it's the modern standard.

```bash
# Create server KeyStore (cert + private key)
openssl pkcs12 -export \
  -in server.crt -inkey server.key \
  -name "server" \
  -out server.p12 \
  -password pass:server-keystore-password

# Create client KeyStore (cert + private key)
openssl pkcs12 -export \
  -in client.crt -inkey client.key \
  -name "client" \
  -out client.p12 \
  -password pass:client-keystore-password

# Create TrustStore containing the CA certificate
# (both client and server use the same CA, so one TrustStore works for both)
keytool -import -trustcacerts \
  -alias "mycompany-ca" \
  -file ca.crt \
  -keystore truststore.p12 \
  -storetype PKCS12 \
  -storepass truststore-password \
  -noprompt
```

After this, you'll have:

```
ca.crt             ← The CA certificate (used to build trust stores)
ca.key             ← CA private key (keep secret!)
server.p12         ← Server's KeyStore (cert + private key)
client.p12         ← Client's KeyStore (cert + private key)
truststore.p12     ← TrustStore with the CA cert (used by both sides)
```

---

## Step 2: The Core SSLContext Builder

The heart of Java mTLS is building an `SSLContext` correctly. Here's a reusable utility class:

```java
import javax.net.ssl.*;
import java.io.FileInputStream;
import java.security.KeyStore;

/**
 * Utility to build an SSLContext for mTLS.
 *
 * Think of SSLContext as the complete "security configuration" object.
 * It combines your identity (KeyStore) with your trust decisions (TrustStore)
 * into a single object that can be handed to any Java HTTP library.
 */
public class MtlsContextBuilder {

    /**
     * Build an SSLContext configured for mTLS.
     *
     * @param keyStorePath     Path to your PKCS12 KeyStore (.p12) — your identity
     * @param keyStorePassword Password for your KeyStore
     * @param trustStorePath   Path to your TrustStore (.p12) — who you trust
     * @param trustStorePass   Password for your TrustStore
     */
    public static SSLContext build(
            String keyStorePath,
            String keyStorePassword,
            String trustStorePath,
            String trustStorePass
    ) throws Exception {

        // ── Step 1: Load YOUR KeyStore (your certificate + private key) ──────────
        // Analogy: Open your wallet and take out your ID card
        KeyStore keyStore = KeyStore.getInstance("PKCS12");
        try (FileInputStream fis = new FileInputStream(keyStorePath)) {
            keyStore.load(fis, keyStorePassword.toCharArray());
        }

        // ── Step 2: Create a KeyManagerFactory from your KeyStore ────────────────
        // This tells Java: "When asked to prove my identity, use this certificate"
        KeyManagerFactory kmf = KeyManagerFactory.getInstance(
            KeyManagerFactory.getDefaultAlgorithm() // usually "SunX509"
        );
        kmf.init(keyStore, keyStorePassword.toCharArray());

        // ── Step 3: Load the TrustStore (CAs you accept certificates from) ───────
        // Analogy: Load your approved guest list
        KeyStore trustStore = KeyStore.getInstance("PKCS12");
        try (FileInputStream fis = new FileInputStream(trustStorePath)) {
            trustStore.load(fis, trustStorePass.toCharArray());
        }

        // ── Step 4: Create a TrustManagerFactory from your TrustStore ────────────
        // This tells Java: "Only trust certificates signed by CAs in this store"
        TrustManagerFactory tmf = TrustManagerFactory.getInstance(
            TrustManagerFactory.getDefaultAlgorithm() // usually "PKIX"
        );
        tmf.init(trustStore);

        // ── Step 5: Combine into SSLContext ──────────────────────────────────────
        // SSLContext = your identity + your trust decisions, ready to go
        SSLContext sslContext = SSLContext.getInstance("TLS");
        sslContext.init(
            kmf.getKeyManagers(),    // "Here's who I am"
            tmf.getTrustManagers(),  // "Here's who I accept"
            null                     // SecureRandom — null uses the default
        );

        return sslContext;
    }
}
```

---

## Step 3: mTLS HTTP Server (Java HttpServer)

```java
import com.sun.net.httpserver.*;
import javax.net.ssl.*;
import java.net.InetSocketAddress;
import java.io.*;

/**
 * A simple HTTPS server that requires mTLS.
 *
 * The server will:
 * 1. Present its own certificate to the client
 * 2. REQUIRE the client to present a certificate
 * 3. Reject any connection from a client without a valid, trusted certificate
 */
public class MtlsServer {

    public static void main(String[] args) throws Exception {
        // Build SSLContext with server's identity and who it trusts (client CAs)
        SSLContext sslContext = MtlsContextBuilder.build(
            "server.p12",          // Server presents this certificate
            "server-keystore-password",
            "truststore.p12",      // Server trusts certs signed by CAs in here
            "truststore-password"
        );

        // Create HTTPS server on port 8443
        HttpsServer server = HttpsServer.create(new InetSocketAddress(8443), 0);

        server.setHttpsConfigurator(new HttpsConfigurator(sslContext) {
            @Override
            public void configure(HttpsParameters params) {
                SSLParameters sslParams = sslContext.getDefaultSSLParameters();

                // ✅ This is the key line that enables mTLS:
                // NEED_CLIENT_AUTH means client MUST present a certificate.
                // Without this, it's standard one-way TLS.
                sslParams.setNeedClientAuth(true);

                params.setSSLParameters(sslParams);
            }
        });

        // Define a simple endpoint
        server.createContext("/hello", exchange -> {
            // We can inspect the client's certificate here
            SSLSession session = ((HttpsExchange) exchange).getSSLSession();
            String clientCN = "unknown";
            try {
                java.security.cert.X509Certificate[] certs =
                    (java.security.cert.X509Certificate[]) session.getPeerCertificates();
                // Extract CN (Common Name) from the client's certificate subject
                String subject = certs[0].getSubjectX500Principal().getName();
                clientCN = subject; // e.g., "CN=java-client,O=MyCompany,..."
            } catch (SSLPeerUnverifiedException e) {
                // Should not happen since we set NEED_CLIENT_AUTH
            }

            String response = "Hello, authenticated client! Your cert subject: " + clientCN;
            exchange.sendResponseHeaders(200, response.length());
            try (OutputStream os = exchange.getResponseBody()) {
                os.write(response.getBytes());
            }
        });

        server.start();
        System.out.println("mTLS server running on https://localhost:8443");
        System.out.println("Client certificate required for all connections.");
    }
}
```

---

## Step 4: mTLS HTTP Client (HttpClient — Java 11+)

```java
import java.net.URI;
import java.net.http.*;
import javax.net.ssl.*;

/**
 * An HTTP client that uses mTLS to authenticate itself to the server.
 *
 * The client will:
 * 1. Present its own certificate when the server asks "who are you?"
 * 2. Verify the server's certificate against its TrustStore
 */
public class MtlsClient {

    public static void main(String[] args) throws Exception {
        // Build SSLContext with client's identity and who it trusts (server CAs)
        SSLContext sslContext = MtlsContextBuilder.build(
            "client.p12",          // Client presents this certificate to the server
            "client-keystore-password",
            "truststore.p12",      // Client trusts server certs signed by CAs in here
            "truststore-password"
        );

        // Build the HttpClient with the mTLS SSLContext
        HttpClient client = HttpClient.newBuilder()
            .sslContext(sslContext)
            .build();

        // Make a request — mTLS handshake happens automatically
        HttpRequest request = HttpRequest.newBuilder()
            .uri(URI.create("https://localhost:8443/hello"))
            .GET()
            .build();

        HttpResponse<String> response = client.send(
            request,
            HttpResponse.BodyHandlers.ofString()
        );

        System.out.println("Status:   " + response.statusCode());
        System.out.println("Response: " + response.body());
    }
}
```

---

## Step 5: mTLS with Spring Boot

Spring Boot makes mTLS configuration declarative — mostly through `application.properties`.

### application.properties (Server)

```properties
# Enable HTTPS
server.port=8443
server.ssl.enabled=true

# Server's identity (KeyStore — "here's who I am")
server.ssl.key-store=classpath:server.p12
server.ssl.key-store-type=PKCS12
server.ssl.key-store-password=server-keystore-password
server.ssl.key-alias=server

# Who the server trusts (TrustStore — "these are the clients I accept")
server.ssl.trust-store=classpath:truststore.p12
server.ssl.trust-store-type=PKCS12
server.ssl.trust-store-password=truststore-password

# This is what enables mTLS — require client certificate:
# "need"  = client MUST present a valid cert (strict mTLS)
# "want"  = client SHOULD present a cert but connection allowed if not
# "none"  = standard one-way TLS (no mTLS)
server.ssl.client-auth=need
```

### Spring Boot REST Controller

```java
import org.springframework.web.bind.annotation.*;
import java.security.cert.X509Certificate;
import javax.servlet.http.HttpServletRequest;

@RestController
public class SecureController {

    @GetMapping("/hello")
    public String hello(HttpServletRequest request) {
        // Extract the client's certificate from the request
        X509Certificate[] certs = (X509Certificate[])
            request.getAttribute("javax.servlet.request.X509Certificate");

        if (certs != null && certs.length > 0) {
            String subject = certs[0].getSubjectX500Principal().getName();
            return "Hello, verified client! Certificate subject: " + subject;
        }
        return "Hello! (No client certificate provided)";
    }
}
```

### Spring Boot mTLS Client (RestTemplate)

```java
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.ssl.SSLContextBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.client.HttpComponentsClientHttpRequestFactory;
import org.springframework.web.client.RestTemplate;
import org.springframework.core.io.ClassPathResource;

import javax.net.ssl.SSLContext;
import java.io.File;

@Configuration
public class MtlsClientConfig {

    @Bean
    public RestTemplate mtlsRestTemplate() throws Exception {
        // Use Apache HttpClient to build an SSLContext with mTLS support
        SSLContext sslContext = SSLContextBuilder.create()
            // Load the client KeyStore — "here's who I am"
            .loadKeyMaterial(
                new File("client.p12"),
                "client-keystore-password".toCharArray(),  // KeyStore password
                "client-keystore-password".toCharArray()   // Key password
            )
            // Load the TrustStore — "I trust certs signed by these CAs"
            .loadTrustMaterial(
                new File("truststore.p12"),
                "truststore-password".toCharArray()
            )
            .build();

        CloseableHttpClient httpClient = HttpClients.custom()
            .setSSLContext(sslContext)
            .build();

        HttpComponentsClientHttpRequestFactory factory =
            new HttpComponentsClientHttpRequestFactory(httpClient);

        return new RestTemplate(factory);
    }
}
```

```java
// Using the mTLS RestTemplate
@Service
public class SecureApiService {

    @Autowired
    private RestTemplate mtlsRestTemplate;

    public String callSecureEndpoint() {
        return mtlsRestTemplate.getForObject(
            "https://secure-service:8443/api/data",
            String.class
        );
    }
}
```

---

## Step 6: mTLS with OkHttp (Android / General Use)

OkHttp is popular for Android and general Java applications.

```java
import okhttp3.*;
import javax.net.ssl.*;
import java.io.FileInputStream;
import java.security.KeyStore;

public class OkHttpMtlsExample {

    public static OkHttpClient buildMtlsClient() throws Exception {
        // Load client KeyStore (our identity)
        KeyStore keyStore = KeyStore.getInstance("PKCS12");
        try (FileInputStream fis = new FileInputStream("client.p12")) {
            keyStore.load(fis, "client-keystore-password".toCharArray());
        }
        KeyManagerFactory kmf = KeyManagerFactory.getInstance("SunX509");
        kmf.init(keyStore, "client-keystore-password".toCharArray());

        // Load TrustStore (who we trust)
        KeyStore trustStore = KeyStore.getInstance("PKCS12");
        try (FileInputStream fis = new FileInputStream("truststore.p12")) {
            trustStore.load(fis, "truststore-password".toCharArray());
        }
        TrustManagerFactory tmf = TrustManagerFactory.getInstance("X509");
        tmf.init(trustStore);

        // Build SSLContext
        SSLContext sslContext = SSLContext.getInstance("TLS");
        sslContext.init(kmf.getKeyManagers(), tmf.getTrustManagers(), null);

        // Extract the X509TrustManager for OkHttp (it needs it explicitly)
        X509TrustManager trustManager = (X509TrustManager) tmf.getTrustManagers()[0];

        return new OkHttpClient.Builder()
            .sslSocketFactory(sslContext.getSocketFactory(), trustManager)
            .build();
    }

    public static void main(String[] args) throws Exception {
        OkHttpClient client = buildMtlsClient();

        Request request = new Request.Builder()
            .url("https://localhost:8443/hello")
            .get()
            .build();

        try (Response response = client.newCall(request).execute()) {
            System.out.println("Status: " + response.code());
            System.out.println("Body:   " + response.body().string());
        }
    }
}
```

---

## Step 7: Programmatic Certificate Loading (No Files)

In cloud/container environments, certificates often come from secrets managers (AWS Secrets Manager, HashiCorp Vault, Kubernetes Secrets) as strings or byte arrays — not files. Here's how to load them programmatically:

```java
import java.security.*;
import java.security.cert.*;
import java.security.spec.PKCS8EncodedKeySpec;
import java.util.Base64;
import javax.net.ssl.*;

public class ProgrammaticCertLoader {

    /**
     * Build a KeyStore from PEM strings (e.g., fetched from a secrets manager).
     * No files needed — certs are loaded purely from memory.
     */
    public static KeyStore buildKeyStoreFromPem(
        String certificatePem,  // The certificate content (PEM string)
        String privateKeyPem    // The private key content (PEM string)
    ) throws Exception {

        // Parse the certificate from PEM
        byte[] certBytes = Base64.getDecoder().decode(
            certificatePem
                .replace("-----BEGIN CERTIFICATE-----", "")
                .replace("-----END CERTIFICATE-----", "")
                .replaceAll("\\s", "")
        );
        CertificateFactory cf = CertificateFactory.getInstance("X.509");
        X509Certificate certificate = (X509Certificate)
            cf.generateCertificate(new java.io.ByteArrayInputStream(certBytes));

        // Parse the private key from PEM (PKCS#8 format)
        byte[] keyBytes = Base64.getDecoder().decode(
            privateKeyPem
                .replace("-----BEGIN PRIVATE KEY-----", "")
                .replace("-----END PRIVATE KEY-----", "")
                .replaceAll("\\s", "")
        );
        KeyFactory keyFactory = KeyFactory.getInstance("RSA");
        PrivateKey privateKey = keyFactory.generatePrivate(new PKCS8EncodedKeySpec(keyBytes));

        // Create a PKCS12 KeyStore and load the cert + key
        KeyStore keyStore = KeyStore.getInstance("PKCS12");
        keyStore.load(null, null); // Initialize empty
        keyStore.setKeyEntry(
            "my-key",
            privateKey,
            "temp-password".toCharArray(),
            new Certificate[]{ certificate }
        );

        return keyStore;
    }
}
```

---

## Step 8: Debugging mTLS Issues

mTLS failures can be cryptic. These techniques help diagnose them.

### Enable Java SSL Debug Logging

```bash
# Run your Java app with this JVM flag to get detailed SSL handshake logs
java -Djavax.net.debug=ssl:handshake -jar your-app.jar
```

This logs every step of the TLS handshake, including which certificates are presented and why handshakes fail.

### Common Errors and Their Meaning

| Exception | Meaning | Fix |
|---|---|---|
| `SSLHandshakeException: PKIX path building failed` | Server cert not trusted | Add server's CA to client's TrustStore |
| `SSLHandshakeException: Received fatal alert: certificate_required` | Server requires client cert but none presented | Ensure client's KeyStore is loaded |
| `SSLHandshakeException: Received fatal alert: bad_certificate` | Client cert presented but not trusted by server | Add client's CA to server's TrustStore |
| `UnrecoverableKeyException` | Wrong KeyStore or key password | Check passwords match exactly |
| `SSLPeerUnverifiedException` | Peer didn't present a certificate | Set `NEED_CLIENT_AUTH` on server or verify client config |
| `CertPathValidatorException: validity check failed` | Certificate is expired | Renew the certificate |
| `CertPathValidatorException: hostname mismatch` | Server cert CN/SAN doesn't match the hostname you connected to | Check the cert's SAN field matches your URL |

### Verify Certificate Chain with OpenSSL

```bash
# Verify the server presents a valid chain
openssl s_client -connect localhost:8443 \
  -cert client.crt -key client.key \
  -CAfile ca.crt

# Check what's in a KeyStore
keytool -list -v -keystore server.p12 -storetype PKCS12 -storepass server-keystore-password

# Check what's in a TrustStore
keytool -list -v -keystore truststore.p12 -storetype PKCS12 -storepass truststore-password

# Verify the client cert was signed by the CA
openssl verify -CAfile ca.crt client.crt
```

---

## Step 9: Certificate Rotation (Zero Downtime)

In production, certificates expire. Here's the approach for rotating without downtime:

```java
import javax.net.ssl.*;
import java.util.concurrent.atomic.AtomicReference;

/**
 * A reloadable SSLContext that allows certificate rotation without restarting.
 *
 * Analogy: Like an ID badge system that allows updating badge photos
 * without reissuing everyone's physical card — the terminal just
 * checks the latest version from the central system.
 */
public class ReloadableSslContext {

    private final AtomicReference<SSLContext> currentContext = new AtomicReference<>();

    public ReloadableSslContext(SSLContext initial) {
        currentContext.set(initial);
    }

    /**
     * Reload with new certificates — thread-safe, instant effect.
     * Call this when you detect certificate renewal (e.g., via file watcher,
     * scheduled job, or secrets manager notification).
     */
    public void reload(String newKeyStore, String keystorePass,
                       String newTrustStore, String truststorePass) throws Exception {
        SSLContext newContext = MtlsContextBuilder.build(
            newKeyStore, keystorePass,
            newTrustStore, truststorePass
        );
        currentContext.set(newContext);
        System.out.println("SSL context reloaded — new certificates active.");
    }

    public SSLContext get() {
        return currentContext.get();
    }
}
```

---

## Complete Project Structure

```
mtls-java-demo/
├── pom.xml
├── certs/
│   ├── ca.crt              ← CA certificate
│   ├── server.p12          ← Server KeyStore (cert + key)
│   ├── client.p12          ← Client KeyStore (cert + key)
│   └── truststore.p12      ← TrustStore (CA cert, for both sides)
└── src/main/java/
    ├── MtlsContextBuilder.java    ← Reusable SSLContext builder
    ├── MtlsServer.java            ← HTTPS server with mTLS
    ├── MtlsClient.java            ← HTTP client with mTLS
    └── ReloadableSslContext.java  ← For zero-downtime cert rotation
```

### pom.xml (Minimal Dependencies)

```xml
<dependencies>
    <!-- For Spring Boot examples -->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
    </dependency>

    <!-- For OkHttp examples -->
    <dependency>
        <groupId>com.squareup.okhttp3</groupId>
        <artifactId>okhttp</artifactId>
        <version>4.12.0</version>
    </dependency>

    <!-- Apache HttpClient for RestTemplate mTLS -->
    <dependency>
        <groupId>org.apache.httpcomponents</groupId>
        <artifactId>httpclient</artifactId>
        <version>4.5.14</version>
    </dependency>
</dependencies>
```

---

## Quick Reference Cheat Sheet

```
JAVA mTLS KEY CONCEPTS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
KeyStore    = YOUR identity wallet (private key + your cert)
TrustStore  = Your approved guest list (CA certs you trust)
SSLContext  = Combines KeyStore + TrustStore into one config object
NEED_CLIENT_AUTH = The server flag that forces mTLS (vs one-way TLS)

CERTIFICATE FILES NEEDED
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
server.p12      → Server's KeyStore (server cert + private key)
client.p12      → Client's KeyStore (client cert + private key)
truststore.p12  → CA cert(s) both sides use to verify each other

WHAT EACH SIDE NEEDS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Server: server.p12 (KeyStore) + truststore.p12 (TrustStore)
Client: client.p12 (KeyStore) + truststore.p12 (TrustStore)

KEY CLASSES
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
KeyStore              → Holds certs and keys
KeyManagerFactory     → Creates KeyManagers from a KeyStore
TrustManagerFactory   → Creates TrustManagers from a TrustStore
SSLContext            → The final TLS configuration object
SSLParameters         → Fine-tune TLS settings (e.g., setNeedClientAuth)

CLIENT-AUTH MODES (server-side)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
NEED  → Client MUST present a cert (strict mTLS, reject if missing)
WANT  → Client SHOULD present a cert (soft mTLS, allow if missing)
NONE  → Standard one-way TLS (no client cert required)

COMMON DEBUG COMMANDS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
java -Djavax.net.debug=ssl:handshake ...   → Full handshake logs
keytool -list -v -keystore file.p12 ...   → Inspect KeyStore contents
openssl s_client -connect host:port ...    → Test from command line
openssl verify -CAfile ca.crt cert.crt    → Verify cert against CA
```

---

## Summary: The mTLS Flow in Java

```
  Java Client                              Java Server
       │                                        │
       │  ① TCP connect to :8443               │
       │ ─────────────────────────────────────► │
       │                                        │
       │  ② Server presents server.p12 cert    │
       │ ◄───────────────────────────────────── │
       │  Client checks: Is this cert in        │
       │  my TrustStore? ✓                      │
       │                                        │
       │  ③ Client presents client.p12 cert    │
       │    (because NEED_CLIENT_AUTH=true)     │
       │ ─────────────────────────────────────► │
       │                      Server checks:    │
       │                      Is this in my     │
       │                      TrustStore? ✓     │
       │                                        │
       │  ④ Session key negotiated              │
       │ ◄══════════════════════════════════════ │
       │   Both authenticated. Both encrypted.  │
       │   🔒 mTLS channel established          │
```

> 🔐 **The master analogy:** In Java mTLS, your `KeyStore` is your passport (proves who you are), your `TrustStore` is your list of recognized passport-issuing countries (determines who you trust), and `SSLContext` is the border control system that enforces both rules simultaneously — requiring valid passports from *both* travelers before either gets through.

---

*With mTLS properly configured, even if network traffic is intercepted, the attacker cannot participate in the communication — they don't have a certificate signed by a trusted CA, so the handshake fails before a single byte of application data is exchanged.*
