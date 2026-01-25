class ChatController < ApplicationController
  def index
    @latest_chat = Chat.latest
  end

  def create
    client = OpenAI::Client.new(access_token: ENV["OPENAI_API_KEY"])

    system_prompt = <<~PROMPT
      You are an assistant developer. Your only job is to parse a user's message and provide browser-ready HTML/CSS/Script that matches the intent as closely as possible, returned in the "html" field of the JSON response.

      Additional Rules:
        - always return json in this exact format:
        {
          "html": "<the html code here>",
          "follow_up_message": ["your message", "follow up questions to ask the user if any"]
        }

      PROMPT

    response = client.chat(
      parameters: {
        model: "gpt-4o-mini",
        messages: [{
          role: "system", content: system_prompt
        }, {
          role: "user", content: params[:message] }]
      }
    )

    reply = response.dig("choices", 0, "message", "content")
    parsed = JSON.parse(reply)

    chat = Chat.create!(
      message: params[:message],
      html_response: parsed["html"],
      follow_up_messages: parsed["follow_up_message"]
    )

    respond_to do |format|
      format.html { redirect_to chat_path }
      format.json { render json: { chat: chat } }
    end
  end
end



  