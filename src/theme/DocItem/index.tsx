import React from 'react';
import DocItem from '@theme-original/DocItem';
import type { Props } from '@theme/DocItem';
import ReadAloud from '@site/src/components/ReadAloud';

type DocItemProps = Props;

export default function DocItemWrapper(props: DocItemProps): React.ReactElement {
  return (
    <>
      <ReadAloud />
      <DocItem {...props} />
    </>
  );
}
