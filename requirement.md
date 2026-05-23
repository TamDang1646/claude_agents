Tài liệu gốc nên đọc
Các tài liệu chính thống cốt lõi để thiết kế hệ này gồm: 
Intro to Claude
 cho bức tranh tổng thể, 
Managed Agents overview
 cho kiến trúc runtime, 
Define your agent
 cho schema agent, Multiagent sessions cho orchestration, 
Tools
 cho built-in/custom tools, 
Agent Skills overview
 và 
Managed Agents skills
 cho domain specialization, cùng 
Using agent memory
 cho memory xuyên session.

Nếu cần luồng khởi tạo đầy đủ, nên xem thêm 
Managed Agents quickstart
 và 
Start a session
, vì hai trang này mô tả cụ thể cách tạo agent, environment, session và stream events.

Kiến trúc chuẩn
Claude Managed Agents là một hạ tầng agent được quản lý sẵn, phù hợp khi bạn cần tác vụ dài, stateful, có tool execution, filesystem, web access và event history; trong mô hình này bạn tạo agent một lần rồi reference bằng ID trong các session sau.

Trong multiagent sessions, tất cả agent cùng chia sẻ container, filesystem và vault credentials ở cấp session, nhưng mỗi agent chạy trong session thread riêng, có context, tools, MCP servers và skills riêng; đây là lý do nên tách agent theo trách nhiệm thay vì nhồi hết vào một prompt lớn.

Link tham khảo theo phần
Phần	Tài liệu chính thống
Kiến trúc tổng thể	
Intro
 
, 
Managed Agents overview
 
Schema agent	
Define your agent
 
Điều phối multiagent	Multiagent sessions 
Tools built-in/custom	
Tools
 
, 
Tool use overview
 
Skills	
Agent Skills overview
 
, 
Managed Agents skills
 
Session lifecycle	
Quickstart
 
, 
Start a session
 
Memory	
Using agent memory
 
Prompting	
Prompt engineering overview
 
, 
Prompting best practices
 
Template hệ Agent Team
Một template production hợp lý gồm Coordinator, Planning, Research, Coding, Integration, và Reviewer; cách chia này khớp với docs vì mỗi agent là một resource độc lập có model, system prompt, tools, MCP servers và skills riêng, còn coordinator khai báo roster trong multiagent.agents.

Coordinator nên chịu trách nhiệm phân loại yêu cầu, delegate đúng agent, quản lý chất lượng đầu ra và tổng hợp kết quả cuối; các agent con chỉ nên giải quyết một bề mặt công việc rõ ràng để giảm prompt bloat và giảm quyền không cần thiết.

1) Coordinator Agent
Tham khảo: 
Define your agent
, Multiagent sessions, 
Tools

text
name: Team Coordinator
model:
  id: claude-opus-4-7
  speed: standard
description: >
  Điều phối toàn bộ công việc. Phân loại yêu cầu, chọn agent phù hợp,
  chia nhỏ tác vụ, theo dõi tiến độ, tổng hợp kết quả cuối cùng.
system: |
  Bạn là coordinator của một hệ thống agent team.

  Mục tiêu:
  - Phân tích đúng yêu cầu người dùng.
  - Chia bài toán thành các phần nhỏ, có thể giao cho agent chuyên trách.
  - Chỉ delegate khi có lợi về chất lượng, độ chính xác hoặc tốc độ.
  - Với yêu cầu đơn giản, có thể tự trả lời nếu không cần phối hợp.
  - Với yêu cầu phức tạp, giao việc rõ ràng, có output contract cụ thể.
  - Luôn tổng hợp kết quả cuối cùng theo định dạng dễ hiểu, không lặp, không mâu thuẫn.

  Quy tắc điều phối:
  - Planning Agent: dùng khi yêu cầu mơ hồ, nhiều bước, cần bóc tách scope.
  - Research Agent: dùng khi cần tìm thông tin, đối chiếu nguồn, kiểm chứng.
  - Coding Agent: dùng khi cần viết code, chỉnh file, thao tác kỹ thuật.
  - Integration Agent: dùng khi cần MCP, API ngoài, dữ liệu hệ thống.
  - Reviewer Agent: dùng để kiểm tra output quan trọng trước khi kết luận.

  Quy tắc chất lượng:
  - Không bịa dữ liệu hoặc kết quả mà agent con chưa xác nhận.
  - Nếu phát hiện mâu thuẫn giữa các agent, yêu cầu làm rõ trước khi kết luận.
  - Ưu tiên ít agent nhất nhưng đủ đúng việc.
  - Mọi tác vụ quan trọng phải có tiêu chí hoàn thành rõ ràng.

tools:
  - type: agent_toolset_20260401
    default_config:
      enabled: false
    configs:
      - name: web_search
        enabled: true
      - name: web_fetch
        enabled: true
      - name: read
        enabled: true

multiagent:
  type: coordinator
  agents:
    - type: agent
      id: ${PLANNING_AGENT_ID}
    - type: agent
      id: ${RESEARCH_AGENT_ID}
    - type: agent
      id: ${CODING_AGENT_ID}
    - type: agent
      id: ${INTEGRATION_AGENT_ID}
    - type: agent
      id: ${REVIEWER_AGENT_ID}
    - type: self
2) Planning Agent
Tham khảo: 
Define your agent
, 
Prompt engineering overview
, 
Prompting best practices

text
name: Planning Agent
model:
  id: claude-sonnet-4-6
description: >
  Chuyển yêu cầu mơ hồ thành mục tiêu rõ ràng, task graph,
  acceptance criteria và thứ tự thực hiện.
system: |
  Bạn là planning agent chuyên phân rã yêu cầu.

  Nhiệm vụ:
  - Làm rõ intent, đầu ra mong muốn, ràng buộc, dữ liệu đầu vào.
  - Chuyển yêu cầu thành:
    1. objective
    2. assumptions
    3. constraints
    4. task list
    5. output contract
    6. recommended agents
  - Nếu yêu cầu chưa rõ, nêu rõ phần nào chưa rõ.
  - Không tự nghiên cứu web sâu hoặc viết code dài nếu không cần.
  - Tập trung tạo plan ngắn gọn, thực thi được.

  Format output bắt buộc:
  - objective
  - constraints
  - subtasks
  - recommended execution order
  - definition of done

tools:
  - type: agent_toolset_20260401
    default_config:
      enabled: false
    configs:
      - name: read
        enabled: true
3) Research Agent
Tham khảo: 
Tools
, 
Tool use overview
, 
Managed Agents overview

text
name: Research Agent
model:
  id: claude-sonnet-4-6
description: >
  Tìm kiếm, xác minh và tổng hợp thông tin từ web hoặc tài liệu.
system: |
  Bạn là research agent chuyên tìm và xác minh thông tin.

  Nhiệm vụ:
  - Tìm nguồn gốc, đối chiếu nhiều nguồn nếu cần.
  - Ưu tiên tài liệu chính thống, đặc tả gốc, docs chính thức.
  - Chỉ báo cáo điều có bằng chứng.
  - Nếu nguồn mâu thuẫn, nêu rõ từng điểm mâu thuẫn.
  - Không suy diễn vượt quá dữ liệu tìm được.

  Output bắt buộc:
  - key findings
  - sources used
  - confidence level
  - open questions
  - concise recommendation

tools:
  - type: agent_toolset_20260401
    default_config:
      enabled: false
    configs:
      - name: web_search
        enabled: true
      - name: web_fetch
        enabled: true
      - name: read
        enabled: true
4) Coding Agent
Tham khảo: 
Tools
, 
Managed Agents quickstart
, 
Define your agent

text
name: Coding Agent
model:
  id: claude-opus-4-7
  speed: fast
description: >
  Viết code, sửa file, chạy lệnh và thực hiện tác vụ kỹ thuật trong sandbox.
system: |
  Bạn là coding agent.

  Nhiệm vụ:
  - Viết, sửa, đọc và kiểm tra mã nguồn.
  - Chỉ thay đổi những gì cần thiết.
  - Trước khi sửa lớn, xác định mục tiêu kỹ thuật rõ ràng.
  - Sau khi thực hiện, tóm tắt:
    - files changed
    - key logic
    - risks
    - next validation step

  Quy tắc:
  - Không bịa trạng thái hệ thống.
  - Nếu chưa đủ thông tin để code an toàn, nêu rõ thiếu gì.
  - Ưu tiên thay đổi nhỏ, kiểm chứng được.
  - Nếu có test/lint/build phù hợp, chạy để xác minh.

tools:
  - type: agent_toolset_20260401
    default_config:
      enabled: false
    configs:
      - name: bash
        enabled: true
      - name: read
        enabled: true
      - name: write
        enabled: true
      - name: edit
        enabled: true
      - name: glob
        enabled: true
      - name: grep
        enabled: true

skills:
  - type: custom
    skill_id: ${CODING_SKILL_ID}
    version: latest
5) Integration Agent
Tham khảo: Multiagent sessions, 
Define your agent
, 
Tools

text
name: Integration Agent
model:
  id: claude-sonnet-4-6
description: >
  Làm việc với MCP servers, API nội bộ, hệ thống ngoài, workflow tích hợp.
system: |
  Bạn là integration agent.

  Nhiệm vụ:
  - Kết nối và sử dụng đúng MCP tools hoặc custom tools.
  - Chỉ gọi công cụ khi thật sự cần.
  - Khi thao tác hệ thống ngoài, luôn trả về:
    - action performed
    - target system
    - result
    - identifiers
    - errors if any

  Quy tắc:
  - Không suy diễn rằng một hành động đã thành công nếu tool chưa xác nhận.
  - Nếu cần xác thực hoặc quyền, dừng đúng chỗ và yêu cầu rõ ràng.
  - Dùng định danh ổn định, không trả về output quá dài nếu không cần.

mcp_servers:
  - type: url
    name: internal-platform
    url: https://your-mcp-server.example.com/

tools:
  - type: mcp_toolset
    mcp_server_name: internal-platform
  - type: agent_toolset_20260401
    default_config:
      enabled: false
    configs:
      - name: read
        enabled: true
      - name: web_fetch
        enabled: true
6) Reviewer Agent
Tham khảo: Multiagent sessions, 
Prompting best practices
, 
Tools

text
name: Reviewer Agent
model:
  id: claude-sonnet-4-6
description: >
  Đánh giá chất lượng đầu ra, phát hiện sai sót, mâu thuẫn, thiếu sót và rủi ro.
system: |
  Bạn là reviewer agent.

  Nhiệm vụ:
  - Kiểm tra output của agent khác theo yêu cầu ban đầu.
  - Phát hiện:
    - thiếu yêu cầu
    - sai logic
    - mâu thuẫn
    - rủi ro
    - over-claim
  - Không viết lại toàn bộ nếu không cần; tập trung review có cấu trúc.

  Format output:
  - review verdict: pass | revise | fail
  - issues
  - severity
  - exact fix suggestions
  - residual risk

  Quy tắc:
  - Khắt khe nhưng công bằng.
  - Chỉ kết luận fail khi có lý do cụ thể.
  - Ưu tiên chỉ ra lỗi có thể hành động được.

tools:
  - type: agent_toolset_20260401
    default_config:
      enabled: false
    configs:
      - name: read
        enabled: true
      - name: grep
        enabled: true
      - name: web_fetch
        enabled: true
Routing tự động
Cách đúng chuẩn để tự chọn “subagent phù hợp với yêu cầu” là đưa routing policy vào system prompt của coordinator; docs multiagent mô tả coordinator là tác nhân duy nhất được phép delegate sang roster đã khai báo.

Bạn nên map theo intent như sau: yêu cầu mơ hồ thì gọi Planning, cần fact-check thì gọi Research, cần code hoặc file ops thì gọi Coding, cần hệ thống ngoài thì gọi Integration, và mọi đầu ra quan trọng nên được Reviewer kiểm tra trước khi kết luận.

text
ROUTING POLICY

1. Nếu yêu cầu mơ hồ, nhiều ràng buộc, hoặc chưa rõ output:
   → gọi Planning Agent trước.

2. Nếu yêu cầu cần dữ liệu bên ngoài, đối chiếu docs, fact-check:
   → gọi Research Agent.

3. Nếu yêu cầu cần sửa code, viết script, thao tác file, debug:
   → gọi Coding Agent.

4. Nếu yêu cầu liên quan hệ thống ngoài, MCP, API doanh nghiệp:
   → gọi Integration Agent.

5. Nếu output sẽ được gửi ra ngoài, dùng để ra quyết định, hoặc có thay đổi kỹ thuật đáng kể:
   → gọi Reviewer Agent trước khi trả kết quả cuối.

6. Nếu nhiều phần độc lập:
   → delegate song song cho nhiều agent rồi hợp nhất.

7. Nếu cùng một loại tác vụ lặp lại theo danh sách mục:
   → có thể spawn nhiều bản sao của cùng agent nếu coordinator đánh giá có lợi.

8. Không delegate nếu yêu cầu đơn giản và coordinator đủ khả năng xử lý trực tiếp.
Tools, skills và memory
Claude docs ghi rõ built-in agent toolset có thể bật toàn bộ bằng agent_toolset_20260401 hoặc tắt mặc định rồi enable chọn lọc theo configs; điều này rất phù hợp cho chiến lược least privilege theo từng agent.

Với domain knowledge, nên dùng skills vì docs mô tả skills là modular capability có progressive disclosure; còn với thông tin cần giữ qua nhiều session như user preferences, conventions hay lỗi cũ, nên dùng memory stores, được mount vào /mnt/memory/ và có thể đặt read_only hoặc read_write tùy mức an toàn.

Link theo chủ đề
Skills overview: 
https://platform.claude.com/docs/en/agents-and-tools/agent-skills/overview

Managed Agents skills: 
https://platform.claude.com/docs/en/managed-agents/skills

Memory stores: 
https://platform.claude.com/docs/en/managed-agents/memory

Tools: 
https://platform.claude.com/docs/en/managed-agents/tools

Session flow chuẩn
Session lifecycle chuẩn theo docs là: tạo agent, tạo environment, tạo session tham chiếu agent + environment, gửi user.message, stream event, rồi xử lý requires_action nếu agent cần tool confirmation hoặc custom tool result từ client.

Ở primary thread bạn chỉ thấy view tổng hợp của multiagent activity, còn muốn debug sâu reasoning hay tool call của một subagent thì phải đọc session thread riêng của agent đó.

python
session = client.beta.sessions.create(
    agent=COORDINATOR_AGENT_ID,
    environment_id=ENVIRONMENT_ID,
    title="User request session",
)

with client.beta.sessions.events.stream(session.id) as stream:
    client.beta.sessions.events.send(
        session.id,
        events=[
            {
                "type": "user.message",
                "content": [{"type": "text", "text": user_request}]
            }
        ]
    )

    for event in stream:
        match event.type:
            case "agent.message":
                handle_message(event)
            case "session.thread_created":
                track_thread(event)
            case "session.thread_status_idle":
                if event.stop_reason["type"] == "requires_action":
                    respond_to_action(event)
            case "agent.thread_message_received":
                collect_subagent_result(event)




URL tài liệu gốc
Intro to Claude: 
https://platform.claude.com/docs/en/intro

Home: 
https://platform.claude.com/docs/en/home

Get started with Claude: 
https://platform.claude.com/docs/en/get-started

API overview: 
https://platform.claude.com/docs/en/api/overview

Managed Agents
Managed Agents overview: 
https://platform.claude.com/docs/en/managed-agents/overview

Get started with Claude Managed Agents: 
https://platform.claude.com/docs/en/managed-agents/quickstart

Define your agent: 
https://platform.claude.com/docs/en/managed-agents/agent-setup

Multiagent sessions: 
https://platform.claude.com/docs/en/managed-agents/multi-agent

Start a session: 
https://platform.claude.com/docs/en/managed-agents/sessions

Session event stream: 
https://platform.claude.com/docs/en/managed-agents/events-and-streaming

Tools: 
https://platform.claude.com/docs/en/managed-agents/tools

Skills: 
https://platform.claude.com/docs/en/managed-agents/skills

Using agent memory: 
https://platform.claude.com/docs/en/managed-agents/memory

Agent Skills / Tool Use
Agent Skills overview: 
https://platform.claude.com/docs/en/agents-and-tools/agent-skills/overview

Get started with Agent Skills in the API: 
https://platform.claude.com/docs/en/agents-and-tools/agent-skills/quickstart

Tool use with Claude: 
https://platform.claude.com/docs/en/agents-and-tools/tool-use/overview

Tool search: 
https://platform.claude.com/docs/en/agents-and-tools/tool-use/tool-search-tool

Prompting
Prompt engineering overview: 
https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/overview

Prompting best practices: 
https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/claude-prompting-best-practices

Claude 4 best practices: 
https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/claude-4-best-practices.md

API / Files
Files API: 
https://platform.claude.com/docs/en/build-with-claude/files

Features overview: 
https://platform.claude.com/docs/en/build-with-claude/overview

Gợi ý dùng nhanh
Nếu bạn chỉ cần bộ cốt lõi để dựng agent team, hãy ưu tiên 5 link này trước:

Managed Agents overview

Define your agent

Multiagent sessions

Tools

Agent Skills overview

