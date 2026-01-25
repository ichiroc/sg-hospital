class WebBrowserAgent < ApplicationAgent
  def order(message)
    @message = message
    prompt(
      #input: "瀬戸市のスシローの予約をしてみてください。明日の12:00 の予約を中谷でしたいです。このページです。 https://www.akindo-sushiro.co.jp/ ",
      #input: "瀬戸市のくら寿司の予約をしてみてください。明日の12:00 の予約を中谷でしたいです。このページです。 https://www.kurasushi.co.jp/ ",
      #input: '瀬戸市のこだま耳鼻科のホームページのURLをWeb検索してください',
      #input: "このURLのサイトで、ソニックガーデンの経営者として大切にしてるものを聞いてみてください。 https://kuragpt.app.ichiroc.in/ ページが開けない場合はスクリーンショットを保存し、その理由も調べてください。",
      #input: "URLで渡したサイトからたどって、HTMLの input 要素の radio ボタンについて概要文を抜き出してください。 https://developer.mozilla.org/ja/docs/Web",
      max_retries: 15,
      tools:
        [
          {
            name: "open_url",
            description: "agent-browser を使って URL を開きます。",
            parameters: {
              type: "object",
              properties: {
                url: { type: "string", description: "開きたいURLを指定します。" }
              },
              required: [ "url" ]
            }
          },
          {
            name: "click",
            description: "agent-browser を使って click します",
            parameters: {
              type: "object",
              properties: {
                ref: { type: "string", description: "クリックしたい要素の ref 属性を指定します。@は含めません。 例: [ref=e12] の場合は 'e12'" }
              },
              required: [ "ref" ]
            }
          },
          {
            name: "select",
            description: "agent-browser を使って combobox を操作します。",
            parameters: {
              type: "object",
              properties: {
                ref: { type: "string", description: "クリックした combobox の ref 属性を指定します。@は含めません。 例: [ref=e12] の場合は 'e12'" },
                value: { type: "string", description: "combobox の選択したい要素の値を指定します。例: option 'orange' [ref=e11] の場合は 'orange'" }
              },
              required: [ "ref", "value" ]
            }
          },
          {
            name: "fill",
            description: "agent-browser を使って入力フィールドをクリアして入力します。",
            parameters: {
              type: "object",
              properties: {
                ref: { type: "string", description: "入力したい要素の ref 属性を指定します。@は含めません。 例: [ref=e12] の場合は 'e12'" },
                text: { type: "string", description: "入力したいテキストを指定します。" }
              },
              required: [ "ref", "text" ]
            }
          },
          {
            name: "check",
            description: "agent-browser を使ってチェックボックスをチェックします。",
            parameters: {
              type: "object",
              properties: {
                ref: { type: "string", description: "チェックしたいチェックボックスの ref 属性を指定します。@は含めません。 例: [ref=e12] の場合は 'e12'" }
              },
              required: [ "ref" ]
            }
          },
          {
            name: "uncheck",
            description: "agent-browser を使ってチェックボックスのチェックを外します。",
            parameters: {
              type: "object",
              properties: {
                ref: { type: "string", description: "チェックを外したいチェックボックスの ref 属性を指定します。@は含めません。 例: [ref=e12] の場合は 'e12'" }
              },
              required: [ "ref" ]
            }
          },
          {
            name: "drag",
            description: "agent-browser を使ってドラッグ&ドロップします。",
            parameters: {
              type: "object",
              properties: {
                src_ref: { type: "string", description: "ドラッグ元の要素の ref 属性を指定します。@は含めません。 例: [ref=e12] の場合は 'e12'" },
                dst_ref: { type: "string", description: "ドロップ先の要素の ref 属性を指定します。@は含めません。 例: [ref=e13] の場合は 'e13'" }
              },
              required: [ "src_ref", "dst_ref" ]
            }
          },
          {
            name: "close",
            description: "agent-browser を使ってブラウザを閉じます。",
            parameters: {
              type: "object",
              properties: {}
            }
          },
          # {
          #   name: "screenshot",
          #   description: "agent-browser を使ってスクリーンショットを保存します。",
          #   parameters: {
          #     type: "object",
          #     properties: {
          #       path: { type: "string", description: "保存先のファイルパスを指定します。例: 'screenshot.png'" },
          #       full_page: { type: "boolean", description: "ページ全体のスクリーンショットを撮る場合は true を指定します。デフォルトは false (表示領域のみ)" }
          #     },
          #     required: [ "path" ]
          #   }
          # },
          {
            name: "web_search",
            description: "Web検索を実行して、最新の情報を取得します。",
            parameters: {
              type: "object",
              properties: {
                query: { type: "string", description: "検索クエリを指定します。例: '瀬戸市 こだま耳鼻科'" }
              },
              required: [ "query" ]
            }
          }
        ]
    )
  end

  def web_search(query:)
    client = OpenAI::Client.new(api_key: ENV.fetch('OPENAI_API_KEY'))

    response = client.responses.create(
      model: "gpt-4o",
      input: query,
      tools: [
        { type: "web_search" }
      ]
    )

    # NOTE: output の最後に検索結果が入っている( first は検索指示 )
    # text はAIがまとめた情報でURLを含む。
    response.output.last.content.first.text
  end

  def open_url(url:)
    agent_browser_command('open', url)
  end

  def click(ref:)
    agent_browser_command('click', "@#{ref}")
  end

  def select(ref:, value:)
    agent_browser_command('select', "@#{ref}", value)
  end

  def fill(ref:, text:)
    agent_browser_command('fill', "@#{ref}", text)
  end

  def check(ref:)
    agent_browser_command('check', "@#{ref}")
  end

  def uncheck(ref:)
    agent_browser_command('uncheck', "@#{ref}")
  end

  def drag(src_ref:, dst_ref:)
    agent_browser_command('drag', "@#{src_ref}", "@#{dst_ref}")
  end

  def close
    agent_browser_command('close')
  end

  # NOTE: なぜか動かん
  # def screenshot
  #   args = [ 'screenshot' ]
  #   agent_browser_command(*args)
  # end

  private

  def agent_browser_command(*args)
    `yarn agent-browser #{args.join(' ')}`
    `yarn agent-browser snapshot -c`
  end
end
