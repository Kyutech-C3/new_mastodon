import React from 'react';
import { defineMessages, useIntl } from 'react-intl';

const messages = defineMessages({
  cautionMessage: { id: 'custom.caution_message', defaultMessage: 'CAUTION' },
});

// 注意喚起メッセージのコンポーネント
export const LiteracyCaution = () => {
  const intl = useIntl();

  return (
    <div className="literacy-caution">
      {/* 九工大の情報基盤センターの出している「情報発信時の注意点」のリンク */}
      <a href="https://onlineguide.isc.kyutech.ac.jp/guide2020/index.php/home/2020-02-04-02-50-29/2020-03-03-01-40-44">
        <p>
          {intl.formatMessage(messages.cautionMessage)}
        </p>
      </a>
    </div>
  )
}
