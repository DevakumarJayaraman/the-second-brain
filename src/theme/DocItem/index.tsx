import React from 'react';
import DocItem from '@theme-original/DocItem';
import type { Props } from '@theme/DocItem';
import StickyReadingTime from '@site/src/components/StickyReadingTime';

type DocItemProps = Props;

export default function DocItemWrapper(props: DocItemProps): React.ReactElement {
  const readingTime = (props as any)?.content?.metadata?.readingTime;
  
  return (
    <>
      <StickyReadingTime readingTime={readingTime} />
      <DocItem {...props} />
    </>
  );
}
