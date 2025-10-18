library(shiny)

# Landing Page Module UI
landingPageUI <- function(id) {
  ns <- NS(id)
  
  fluidPage(
  
  # Include custom CSS
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "styles.css"),
    tags$link(rel = "preconnect", href = "https://fonts.googleapis.com"),
    tags$link(rel = "preconnect", href = "https://fonts.gstatic.com", crossorigin = ""),
    tags$link(href = "https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&family=Poppins:wght@400;500;600;700;800&display=swap", rel = "stylesheet"),
    tags$meta(name = "viewport", content = "width=device-width, initial-scale=1.0"),
    tags$title("Baho - The First Line of Health Service Delivery"),
    # Font Awesome for icons
    tags$link(rel = "stylesheet", href = "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css")
  ),
  
  # Skip link for accessibility
  tags$a(href = "#main-content", class = "skip-link", "Skip to main content"),
  
  # Navigation Bar
  navbarPage(
    id = "main-nav",
    title = NULL,
    windowTitle = "Baho - AI Health Platform",
    collapsible = TRUE,
    fluid = TRUE,
    
    # Custom navbar with logo and navigation
    header = tags$nav(
      class = "navbar-custom",
      id = "main-navbar",
      tags$div(
        class = "navbar-container",
        tags$div(
          class = "navbar-brand",
          tags$img(src = "logo.png", alt = "Baho Logo", class = "navbar-logo")
        ),
        tags$div(
          class = "navbar-nav",
          tags$a(href = "#home", class = "nav-link active", "Home"),
          tags$a(href = "#about", class = "nav-link", "About"),
          tags$a(href = "#features", class = "nav-link", "Features"),
          tags$a(href = "#contact", class = "nav-link", "Contact")
        ),
        tags$div(
          class = "navbar-actions",
           tags$div(
             class = "language-switcher",
             tags$button(
               id = "lang-btn",
               class = "btn btn-ghost btn-sm lang-switcher-btn",
               tags$i(class = "fas fa-globe"),
               tags$span(class = "lang-text", "RW"),
               tags$i(class = "fas fa-chevron-down dropdown-arrow")
             ),
             tags$div(class = "lang-dropdown", id = "lang-dropdown",
               tags$a(href = "#", class = "lang-option", `data-lang` = "rw",
                 tags$span("🇷🇼 Kinyarwanda")
               ),
               tags$a(href = "#", class = "lang-option", `data-lang` = "en",
                 tags$span("🇺🇸 English")
               )
             )
           ),
          tags$a(
            href = "#get-started",
            class = "btn btn-primary btn-sm cta-btn",
            tags$span("Get Started"),
            tags$i(class = "fas fa-arrow-right")
          ),
          tags$button(
            class = "mobile-menu-toggle",
            id = "mobile-menu-btn",
            tags$span(class = "hamburger-line"),
            tags$span(class = "hamburger-line"),
            tags$span(class = "hamburger-line")
          )
        )
      ),
      tags$div(class = "mobile-menu", id = "mobile-menu",
        tags$div(class = "mobile-menu-content",
          tags$a(href = "#home", class = "mobile-nav-link active", "Home"),
          tags$a(href = "#about", class = "mobile-nav-link", "About"),
          tags$a(href = "#programs", class = "mobile-nav-link", "Programs"),
          tags$a(href = "#contact", class = "mobile-nav-link", "Contact"),
          tags$div(class = "mobile-menu-actions",
            tags$button(class = "btn btn-primary mobile-cta", "Get Started")
          )
        )
      )
    ),
    
    # Main Content
    tabPanel(
      value = "home",
      title = "",
      
      # Hero Section
      tags$section(
        id = "hero",
        class = "hero-section",
        tags$div(
          class = "container hero-content",
          tags$div(
            class = "hero-grid",
            tags$div(
              class = "hero-text",
              tags$div(class = "hero-badge", 
                tags$i(class = "fas fa-star"),
                tags$span(`data-en` = "AI-Powered Health Innovation", `data-rw` = " Artificial Intelligence mu Buzima", "AI-Powered Health Innovation")
              ),
              tags$h1(class = "hero-title", 
                tags$span(class = "title-main", "Baho"),
                tags$span(class = "title-accent", ".")
              ),
              tags$h2(class = "hero-subtitle", 
                tags$span(class = "subtitle-highlight", `data-en` = "The First Line of", `data-rw` = "Umurongo wa Mbere wa", "The First Line of"),
                tags$span(class = "subtitle-main", `data-en` = "Health Service Delivery", `data-rw` = "Serivisi z'Ubuzima", "Health Service Delivery")
              ),
              tags$p(class = "hero-description", 
                tags$span(`data-en` = "An advanced, ", `data-rw` = "Sisiteme ya Artificial Intelligence yihuse, ", "An advanced, "),
                tags$span(class = "text-accent", `data-en` = "Kinyarwanda-speaking", `data-rw` = "ivuga Ikinyarwanda", "Kinyarwanda-speaking"),
                tags$span(`data-en` = " Artificial Intelligence system designed to ", `data-rw` = " yateguwe ", " Artificial Intelligence system designed to "),
                tags$span(class = "text-highlight", `data-en` = "augment Rwanda's Community Health Worker program", `data-rw` = "kongera ubukangurambaga bwu Rwanda  mu buzima", "augment Rwanda's Community Health Worker program"),
                tags$span(`data-en` = " through intelligent, data-driven, and accessible health communication.", `data-rw` = " mu kugira ubuzima buzira umuze ", " through intelligent, data-driven, and accessible health communication.")
              ),
              tags$div(class = "hero-stats",
                tags$div(class = "stat-item",
                  tags$div(class = "stat-number", "500K+"),
                  tags$div(class = "stat-label", `data-en` = "Lives Impacted", `data-rw` = "Ubuzima Bwoherejwe", "Lives Impacted")
                ),
                tags$div(class = "stat-item",
                  tags$div(class = "stat-number", "24/7"),
                  tags$div(class = "stat-label", `data-en` = "AI Support", `data-rw` = "Ubwoba bwa AI", "AI Support")
                ),
                tags$div(class = "stat-item",
                  tags$div(class = "stat-number", "95%"),
                  tags$div(class = "stat-label", `data-en` = "Accuracy Rate", `data-rw` = "Ubwoba bw'Ubuzima", "Accuracy Rate")
                )
              ),
              tags$div(
                class = "hero-actions",
              actionButton(
                inputId = ns("start_chatting"),
                label = tags$span(
                  tags$span(`data-en` = "Start Chatting", `data-rw` = "Tangira Kuvugana", "Start Chatting"),
                  tags$i(class = "fas fa-comments")
                ),
                class = "btn btn-primary hero-btn primary-cta"
              ),
                tags$a(
                  href = "#learn-more",
                  class = "btn btn-outline hero-btn secondary-cta",
                  tags$span(`data-en` = "Watch Demo", `data-rw` = "Reba Demo", "Watch Demo"),
                  tags$i(class = "fas fa-play")
                )
              )
            ),
            tags$div(
              class = "hero-image-container",
              tags$div(class = "image-carousel",
                tags$img(src = "doctor.png", alt = "Healthcare Professional", class = "hero-doctor-image active", id = "doctor-1"),
                tags$img(src = "doctor1.png", alt = "Healthcare Professional", class = "hero-doctor-image", id = "doctor-2"),
                tags$img(src = "doctor2.png", alt = "Healthcare Professional", class = "hero-doctor-image", id = "doctor-3"),
                tags$img(src = "doctor3.png", alt = "Healthcare Professional", class = "hero-doctor-image", id = "doctor-4")
              ),
              tags$div(class = "carousel-indicators",
                tags$button(class = "indicator active", `data-slide` = "0"),
                tags$button(class = "indicator", `data-slide` = "1"),
                tags$button(class = "indicator", `data-slide` = "2"),
                tags$button(class = "indicator", `data-slide` = "3")
              )
            ),
          )
        )
      ),
      
        # Story of Baho Section
        tags$section(
          id = "story",
          class = "story-section",
          tags$div(
            class = "container",
            
            # Story Section Header
            tags$div(class = "story-header",
              tags$h1(class = "story-title",
                tags$span(`data-en` = "The Story of Baho", `data-rw` = "Inkuru ya Baho", "The Story of Baho")
              ),
              tags$p(class = "story-subtitle",
                tags$span(`data-en` = "From Challenge to Innovation", `data-rw` = "Kuva ku Kibazo kugeza ku Gushishoza", "From Challenge to Innovation")
              )
            ),
            
            # Section 1: The Foundation
           tags$div(class = "story-section-content",
             tags$div(class = "story-text",
               tags$div(class = "story-icon-container",
                 tags$img(src = "foundation_icon.png", alt = "Foundation Icon", class = "story-icon")
               ),
               tags$h2(class = "story-section-title",
                 tags$span(`data-en` = "The Foundation", `data-rw` = "Ishingiro", "The Foundation")
               ),
              tags$p(class = "story-section-description",
                tags$span(`data-en` = "Rwanda's healthcare system has a powerful story to tell. The Community Health Worker program, called ", `data-rw` = "Sisiteme y'ubuzima y'u Rwanda ifite inkuru y'ubushobozi. Porogaramu y'Abakozi b'Ubuzima bo mu Cyaro, yitwa ", "Rwanda's healthcare system has a powerful story to tell. The Community Health Worker program, called "),
                tags$strong(tags$span(`data-en` = "Abajyanama b'Ubuzima", `data-rw` = "Abajyanama b'Ubuzima", "Abajyanama b'Ubuzima")),
                tags$span(`data-en` = " (Health Advisors), is a model that other countries look up to. Started after the ", `data-rw` = " (Abashyuzi b'Ubuzima), ni ikigereranyo cy'ubuzima cy'ibanze cyemejwe ku isi yose. Yatangiye nyuma y'", " (Health Advisors), is a model that other countries look up to. Started after the "),
                tags$em(tags$span(`data-en` = "1994 genocide", `data-rw` = "jenoside ya 1994", "1994 genocide")),
                tags$span(`data-en` = " and officially launched in ", `data-rw` = " maze yatangijwe mu ", " and officially launched in "),
                tags$em(tags$span(`data-en` = "1995", `data-rw` = "1995", "1995")),
                tags$span(`data-en` = ", this program now has over ", `data-rw` = ", iyo porogaramu ubu ifite ", " this program now has over "),
                tags$strong(tags$span(`data-en` = "45,000 health workers", `data-rw` = "45,000 abakozi b'ubuzima", "45,000 health workers")),
                tags$span(`data-en` = " serving communities across Rwanda. These workers walk long distances, cross rivers, and climb hills to reach people in remote areas. They carry medical supplies and share important health information with families. Their hard work has helped reduce deaths among mothers and children, increase vaccination rates, and better manage diseases. However, as Rwanda grows and faces new health problems, this system is under pressure. There are not enough workers, limited resources, and new types of diseases that are harder to manage.", `data-rw` = " batanga serivisi ku baturage bo mu Rwanda yose. Abo bakozi bagendera ku nzira ndende, bagera ku nyanja, bakagera ku misozi kugera ku bantu bo mu cyaro. Batwara ibikoresho by'ubuzima kandi basangira amakuru y'ubuzima y'ingenzi ku miryango. Ibyo bakora byafashe mu kugabanya ubwoba bw'ababyeyi n'abana, kwongera ubwoba bw'ubuzima, n'gutezimbere ubwoba bw'ibyago. Ariko, uko u Rwanda rukura kandi ruhanganye n'ibibazo by'ubuzima by'ubu bikirambye, iyo sisiteme ihanganye. Nta bakozi bihagije, ibikoresho bike, n'ibibazo by'ubuzima by'ubu bikirambye byihanganye.", " serving communities across Rwanda. These workers walk long distances, cross rivers, and climb hills to reach people in remote areas. They carry medical supplies and share important health information with families. Their hard work has helped reduce deaths among mothers and children, increase vaccination rates, and better manage diseases. However, as Rwanda grows and faces new health problems, this system is under pressure. There are not enough workers, limited resources, and new types of diseases that are harder to manage.")
              )
            ),
            tags$div(class = "story-image",
              tags$img(src = "foundation.jpg", alt = "Rwanda Healthcare Foundation", class = "story-img")
            )
          ),
          
           # Section 2: The Challenge
           tags$div(class = "story-section-content reverse",
             tags$div(class = "story-text",
               tags$div(class = "story-icon-container",
                 tags$img(src = "challenge_icon.png", alt = "Challenge Icon", class = "story-icon")
               ),
               tags$h2(class = "story-section-title",
                 tags$span(`data-en` = "The Challenge", `data-rw` = "Ikibazo", "The Challenge")
               ),
              tags$p(class = "story-section-description",
                tags$span(`data-en` = "Think about this: Rwanda has about ", `data-rw` = "Tekereza ibi: u Rwanda rufite hafi ", "Think about this: Rwanda has about "),
                tags$strong(tags$span(`data-en` = "45,000 CHWs", `data-rw` = "45,000", "45,000 CHWs")),
                tags$span(`data-en` = " serving more than ", `data-rw` = " batanga serivisi ku bantu barenga ", " serving more than "),
                tags$em(tags$span(`data-en` = "13.4 million people", `data-rw` = "13.4 miliyoni", "13.4 million people")),
                tags$span(`data-en` = ". This means each health worker takes care of about 300 people spread across villages, farms, and remote areas. Each worker has many responsibilities: helping pregnant women, checking for diseases, organizing vaccinations, and now dealing with new health problems like diabetes and high blood pressure. The numbers show us the real situation: diseases like diabetes and high blood pressure now cause ", `data-rw` = ". Ibi bivuze ko umukozi wese w'ubuzima akurikirana hafi abantu 300 batandukanye mu midugudu, mu mirima, n'ubwoba bw'ubwoba. Umukozi wese w'ubuzima afite inshingano nyinshi: gufasha ababyeyi b'ubwoba, gusuzuma ibyago, gutegura ubuzima, kandi ubu guhangana n'ibibazo by'ubuzima by'ubu bikirambye nka isukari n'ubwoba bw'amaraso. Inomero ziranga ibyo bimeze: ibyago nka isukari n'ubwoba bw'amaraso ubu bikora ", " This means each health worker takes care of about 300 people spread across villages, farms, and remote areas. Each worker has many responsibilities: helping pregnant women, checking for diseases, organizing vaccinations, and now dealing with new health problems like diabetes and high blood pressure. The numbers show us the real situation: diseases like diabetes and high blood pressure now cause "),
                tags$em(tags$span(`data-en` = "36% of all deaths", `data-rw` = "36% by'impfu zose", "36% of all deaths")),
                tags$span(`data-en` = " in Rwanda. Here, ", `data-rw` = " mu Rwanda. Hano, ", " in Rwanda. Here, "),
                tags$strong(tags$span(`data-en` = "22% of adults", `data-rw` = "22% by'abantu bakuru", "22% of adults")),
                tags$span(`data-en` = " have high blood pressure and ", `data-rw` = " bafite ubwoba bw'amaraso kandi ", " have high blood pressure and "),
                tags$strong(tags$span(`data-en` = "2% have diabetes", `data-rw` = "2% bafite isukari", "2% have diabetes")),
                tags$span(`data-en` = ". But there's another big problem: many people don't know enough about health. Even though Rwanda has worked hard to teach people about health, only ", `data-rw` = ". Ariko hari ikindi kibazo kinini: abantu benshi ntibamenya ubuzima bw'ubuzima. Nubwo u Rwanda rwakoze cyane mu kwigisha abantu ubuzima bw'ubuzima, gusa ", " But there's another big problem: many people don't know enough about health. Even though Rwanda has worked hard to teach people about health, only "),
                tags$em(tags$span(`data-en` = "38% of women and 43% of men", `data-rw` = "38% by'abagore na 43% by'abagabo", "38% of women and 43% of men")),
                tags$span(`data-en` = " know enough about HIV prevention. This shows us that basic health information is still not reaching everyone, even in a country that works hard on health education.", `data-rw` = " bamenya ubuzima bw'ubuzima. Ibi biranga ko amakuru y'ubuzima bw'ubuzima ataragera ku bantu bose, n'ubwo u Rwanda rwakoze cyane mu kwigisha ubuzima bw'ubuzima.", " know enough about HIV prevention. This shows us that basic health information is still not reaching everyone, even in a country that works hard on health education.")
              )
            ),
            tags$div(class = "story-image",
              tags$img(src = "challenge.jpg", alt = "Healthcare Challenge in Rwanda", class = "story-img")
            )
          ),
          
           # Section 3: The Solution
           tags$div(class = "story-section-content",
             tags$div(class = "story-text",
               tags$div(class = "story-icon-container",
                 tags$img(src = "solution_icon.png", alt = "Solution Icon", class = "story-icon")
               ),
               tags$h2(class = "story-section-title",
                 tags$span(`data-en` = "The Solution", `data-rw` = "Icyisubizo", "The Solution")
               ),
              tags$p(class = "story-section-description",
                tags$span(`data-en` = "This is where Baho comes in. Baho is a smart health assistant that uses artificial intelligence to help people with their health needs. Think of it as having a knowledgeable health worker available ", `data-rw` = "Hano niho Baho iravuka. Baho ni umufasha w'ubuzima w'ubuhanga ukoresha ubuhanga bw'AI gufasha abantu ku bibazo by'ubuzima. Tekereza ko ufite umukozi w'ubuzima w'ubuzima uboneka ", "This is where Baho comes in. Baho is a smart health assistant that uses artificial intelligence to help people with their health needs. Think of it as having a knowledgeable health worker available "),
                tags$strong(tags$span(`data-en` = "24/7", `data-rw` = "24/7", "24/7")),
                tags$span(`data-en` = " in your phone, speaking Kinyarwanda perfectly and understanding local health problems. Baho is not just another app—it's a smart health helper that works well with Rwanda's existing health system. Baho offers three main programs to help with different health needs: ", `data-rw` = " mu telefone yawe, uvuga Kinyarwanda neza kandi uzi ibibazo by'ubuzima bw'ubuzima. Baho si gusa porogaramu y'ubu bikirambye—ni umufasha w'ubuzima w'ubuhanga ukora neza na sisiteme y'ubuzima y'u Rwanda. Baho itanga ibikoresho bitatu by'ingenzi mu gufasha ku bibazo by'ubuzima by'ubu bikirambye: ", " in your phone, speaking Kinyarwanda perfectly and understanding local health problems. Baho is not just another app—it's a smart health helper that works well with Rwanda's existing health system. Baho offers three main programs to help with different health needs: "),
                tags$strong(tags$span(`data-en` = "9 Months with Baho", `data-rw` = "Amezi 9 na Baho", "9 Months with Baho")),
                tags$span(`data-en` = " helping pregnant women through their pregnancy, ", `data-rw` = " gufasha ababyeyi b'ubwoba mu gihe cy'ubwoba, ", " helping pregnant women through their pregnancy, "),
                tags$strong(tags$span(`data-en` = "1000 Days with Baho", `data-rw` = "Iminsi 1000 na Baho", "1000 Days with Baho")),
                tags$span(`data-en` = " supporting children from birth until age 2, and ", `data-rw` = " gufasha abana kuva bazavuka kugeza ku myaka ibiri, na ", " supporting children from birth until age 2, and "),
                tags$strong(tags$span(`data-en` = "Baho for Life", `data-rw` = "Baho y'Ubuzima", "Baho for Life")),
                tags$span(`data-en` = " helping people manage long-term health problems like diabetes. The best part is that Baho works on phones, and ", `data-rw` = " gufasha abantu gukurikirana ibibazo by'ubuzima by'ubu bikirambye nka isukari. Ikintu cyiza ni uko Baho ikora ku telefone, kandi ", " helping people manage long-term health problems like diabetes. The best part is that Baho works on phones, and "),
                tags$em(tags$span(`data-en` = "92% of families", `data-rw` = "92% by'imiryango", "92% of families")),
                tags$span(`data-en` = " already have phones, so Baho can reach almost everyone. Baho connects with Rwanda's existing health systems like ", `data-rw` = " yamaze gufite telefone, bityo Baho ishobora kugera ku bantu bose. Baho ikurikirana na sisiteme z'ubuzima z'u Rwanda nka ", " already have phones, so Baho can reach almost everyone. Baho connects with Rwanda's existing health systems like "),
                tags$strong(tags$span(`data-en` = "RapidSMS and DHIS2", `data-rw` = "RapidSMS na DHIS2", "RapidSMS and DHIS2")),
                tags$span(`data-en` = " to share health information quickly and help health workers make better decisions. This means health data can flow easily between different parts of the system, helping everyone work together to improve health across Rwanda.", `data-rw` = " mu gusangira amakuru y'ubuzima vuba kandi gufasha abakozi b'ubuzima gufata ibyemezo byiza. Ibi bivuze ko amakuru y'ubuzima ashobora gukurikirana neza hagati y'ibice by'ubu bikirambye by'ubuzima, bikafasha abantu bose gukorana mu gutezimbere ubuzima mu Rwanda yose.", " to share health information quickly and help health workers make better decisions. This means health data can flow easily between different parts of the system, helping everyone work together to improve health across Rwanda.")
              )
            ),
            tags$div(class = "story-image",
              tags$img(src = "solution.png", alt = "Baho AI Solution", class = "story-img")
            )
          )
        )
      ),
      
      # Features Section
      tags$section(
        id = "features",
        class = "features-section",
        tags$div(
          class = "container",
          
          # Features Header
          tags$div(class = "features-header",
            tags$h1(class = "features-title",
              tags$span(`data-en` = "Baho Features", `data-rw` = "Ibiranga Baho", "Baho Features")
            ),
            tags$p(class = "features-subtitle",
              tags$span(`data-en` = "Comprehensive AI-Powered Health Solutions", `data-rw` = "Ibisubizo by'Ubuzima by'AI", "Comprehensive AI-Powered Health Solutions")
            )
          ),
          
          # Features Grid
          tags$div(class = "features-grid",
            
            # Feature 1: AI Chat Interface
            tags$div(class = "feature-card",
              tags$div(class = "feature-icon",
                tags$img(src = "chat.png", alt = "Chat Icon", class = "feature-icon-img")
              ),
              tags$h3(class = "feature-title",
                tags$span(`data-en` = "AI Health Assistant", `data-rw` = "Umufasha w'Ubuzima w'AI", "AI Health Assistant")
              ),
              tags$p(class = "feature-description",
                tags$span(`data-en` = "• Chat with Baho in Kinyarwanda for instant health guidance\n• Ask questions about health, first aid, and medical advice\n• Get personalized wellness tips for Rwanda's healthcare context\n• Access 24/7 AI health support anytime, anywhere", `data-rw` = "• Korana na Baho mu Kinyarwanda ubuvuzi bw'ubu bikirambye\n• Babaza ibibazo ku buzima, ubuvuzi bw'ibanze, n'ibindi\n• Mugire inama z'ubuzima z'ubu bikirambye z'u Rwanda\n• Mugire ubuvuzi bw'ubu bikirambye kuva kuri AI y'ubuhanga", "• Chat with Baho in Kinyarwanda for instant health guidance\n• Ask questions about health, first aid, and medical advice\n• Get personalized wellness tips for Rwanda's healthcare context\n• Access 24/7 AI health support anytime, anywhere")
              ),
              tags$a(href = "#", class = "feature-button",
                tags$span(`data-en` = "Start Chat", `data-rw` = "Tangira", "Start Chat")
              )
            ),
            
            # Feature 2: Health Programs
            tags$div(class = "feature-card",
              tags$div(class = "feature-icon",
                tags$img(src = "programs.png", alt = "Programs Icon", class = "feature-icon-img")
              ),
              tags$h3(class = "feature-title",
                tags$span(`data-en` = "Health Programs", `data-rw` = "Porogaramu z'Ubuzima", "Health Programs")
              ),
              tags$p(class = "feature-description",
                tags$span(`data-en` = "• 9 Months with Baho\n• 1000 Days with Baho\n• Baho for Life", `data-rw` = "• 9 Months with Baho\n• 1000 Days with Baho\n• Baho for Life", "• 9 Months with Baho\n• 1000 Days with Baho\n• Baho for Life")
              ),
              tags$a(href = "#", class = "feature-button",
                tags$span(`data-en` = "View Programs", `data-rw` = "Reba Porogaramu", "View Programs")
              )
            ),
            
            # Feature 3: Health Consultations
            tags$div(class = "feature-card",
              tags$div(class = "feature-icon",
                tags$img(src = "checkups.png", alt = "Checkups Icon", class = "feature-icon-img")
              ),
              tags$h3(class = "feature-title",
                tags$span(`data-en` = "Health Assessments", `data-rw` = "Gusuzuma Ubuzima", "Health Assessments")
              ),
              tags$p(class = "feature-description",
                tags$span(`data-en` = "• Get health assessments from home comfort\n• Monitor child health with Red/Yellow/Green classification\n• Receive pregnancy checkups and prenatal evaluations\n• Access non-physical medical tests and screenings", `data-rw` = "• Mugire ubuvuzi bw'ubuzima bw'ubu bikirambye mu nzu yanyu\n• Mugire ubuzima bw'abana n'ubuzima bw'ibiribwa (Umutuku/Icyatsi/Icyatsi)\n• Mugire ubuvuzi bw'ababyeyi b'ubwoba n'ubuzima bw'ubwoba\n• Mugire ubuvuzi bw'ubuzima butakeneye ubuvuzi bw'umubiri", "• Get health assessments from home comfort\n• Monitor child health with Red/Yellow/Green classification\n• Receive pregnancy checkups and prenatal evaluations\n• Access non-physical medical tests and screenings")
              ),
              tags$a(href = "#", class = "feature-button",
                tags$span(`data-en` = "Get Assessment", `data-rw` = "Suzuma", "Get Assessment")
              )
            ),
            
            # Feature 4: Phone Calls
            tags$div(class = "feature-card",
              tags$div(class = "feature-icon",
                tags$img(src = "call.png", alt = "Call Icon", class = "feature-icon-img")
              ),
              tags$h3(class = "feature-title",
                tags$span(`data-en` = "Voice Consultations", `data-rw` = "Ubuvuzi bwa Jwi", "Voice Consultations")
              ),
              tags$p(class = "feature-description",
                tags$span(`data-en` = "• Call Baho directly for immediate voice consultations\n• Get instant advice through real-time conversations\n• Perfect for urgent health questions needing immediate help\n• Speak in Kinyarwanda for culturally-relevant health support", `data-rw` = "• Hamagara Baho mu buryo butaziguye ubuvuzi bw'ubu bikirambye\n• Mugire inama vuba n'ubu bikirambye mu biganiro by'ubu bikirambye\n• Byiza ku bibazo by'ubuzima by'ubu bikirambye mugihe mukeneye ubuvuzi vuba\n• Muvuge mu Kinyarwanda ubuvuzi bw'ubu bikirambye n'ubuzima bw'ubu bikirambye", "• Call Baho directly for immediate voice consultations\n• Get instant advice through real-time conversations\n• Perfect for urgent health questions needing immediate help\n• Speak in Kinyarwanda for culturally-relevant health support")
              ),
              tags$a(href = "#", class = "feature-button",
                tags$span(`data-en` = "Call Now", `data-rw` = "Hamagara", "Call Now")
              )
            )
          )
        )
      )
    ),
    
    # Call-to-Action Section (Overlapping Footer)
    tags$section(
      class = "cta-overlay-section",
      tags$div(
        class = "container",
          tags$div(
            class = "cta-content",
            tags$div(
              class = "cta-text",
              tags$h2(class = "cta-title",
                tags$span(`data-en` = "Transform Healthcare in Rwanda", `data-rw` = "Guhindura Ubuzima bw'Ubuzima mu Rwanda", "Transform Healthcare in Rwanda")
              ),
              tags$p(class = "cta-subtitle",
                tags$span(`data-en` = "Join 2M+ users across 30 districts with AI-powered health solutions", `data-rw` = "Wongere ku bakoresha 2M+ mu turere 30 n'ibisubizo by'ubuzima by'AI", "Join 2M+ users across 30 districts with AI-powered health solutions")
              ),
              tags$a(href = "#demo", class = "cta-button",
                tags$span(`data-en` = "Get Started", `data-rw` = "Tangira", "Get Started")
              )
            )
          )
      )
    )
  ),
  
  # Footer
  tags$footer(
    class = "footer",
    tags$div(
      class = "footer-main",
      tags$div(
        class = "container",
        tags$div(
          class = "footer-content",
          
          # Brand Section
          tags$div(
            class = "footer-brand",
            tags$div(
              class = "brand-logo",
              tags$img(src = "logo.png", alt = "Baho Logo", class = "footer-logo")
            ),
            tags$p(
              class = "brand-description",
              tags$span(`data-en` = "The First Line of Health Service Delivery for Rwanda. Empowering communities with AI-driven healthcare solutions.", `data-rw` = "Umurongo w'Ubuzima w'Ubuzima w'U Rwanda. Dufasha imiryango n'ibisubizo by'ubuzima by'AI.", "The First Line of Health Service Delivery for Rwanda. Empowering communities with AI-driven healthcare solutions.")
            ),
            tags$div(
              class = "newsletter-signup",
              tags$h4(class = "newsletter-title",
                tags$span(`data-en` = "Stay Updated", `data-rw` = "Menya Ibikurikira", "Stay Updated")
              ),
              tags$div(class = "newsletter-form",
                tags$input(type = "email", placeholder = "Enter your email", class = "newsletter-input"),
                tags$button(class = "newsletter-btn",
                  tags$span(`data-en` = "Subscribe", `data-rw` = "Kwiyandikisha", "Subscribe")
                )
              )
            ),
            tags$div(
              class = "social-links",
              tags$a(href = "#", class = "social-link", tags$i(class = "fab fa-twitter"), "Twitter"),
              tags$a(href = "#", class = "social-link", tags$i(class = "fab fa-linkedin"), "LinkedIn"),
              tags$a(href = "#", class = "social-link", tags$i(class = "fab fa-facebook"), "Facebook"),
              tags$a(href = "#", class = "social-link", tags$i(class = "fab fa-instagram"), "Instagram"),
              tags$a(href = "#", class = "social-link", tags$i(class = "fab fa-youtube"), "YouTube")
            )
          ),
          
          # Quick Links
          tags$div(
            class = "footer-section",
            tags$h4(class = "section-title", 
              tags$span(`data-en` = "Quick Links", `data-rw` = "Amashami", "Quick Links")
            ),
            tags$ul(class = "footer-links",
              tags$li(tags$a(href = "#hero", 
                tags$span(`data-en` = "Home", `data-rw` = "Urugo", "Home")
              )),
              tags$li(tags$a(href = "#story", 
                tags$span(`data-en` = "Our Story", `data-rw` = "Inkuru Yacu", "Our Story")
              )),
              tags$li(tags$a(href = "#features", 
                tags$span(`data-en` = "Features", `data-rw` = "Ibiranga", "Features")
              )),
              tags$li(tags$a(href = "#demo", 
                tags$span(`data-en` = "Request Demo", `data-rw` = "Saba Demo", "Request Demo")
              )),
              tags$li(tags$a(href = "#partners", 
                tags$span(`data-en` = "Partners", `data-rw` = "Abafatanyabikorwa", "Partners")
              ))
            )
          ),
          
          # Health Programs
          tags$div(
            class = "footer-section",
            tags$h4(class = "section-title",
              tags$span(`data-en` = "Health Programs", `data-rw` = "Porogaramu z'Ubuzima", "Health Programs")
            ),
            tags$ul(class = "footer-links",
              tags$li(tags$a(href = "#features", 
                tags$span(`data-en` = "9 Months with Baho", `data-rw` = "9 Months with Baho", "9 Months with Baho")
              )),
              tags$li(tags$a(href = "#features", 
                tags$span(`data-en` = "1000 Days with Baho", `data-rw` = "1000 Days with Baho", "1000 Days with Baho")
              )),
              tags$li(tags$a(href = "#features", 
                tags$span(`data-en` = "Baho for Life", `data-rw` = "Baho for Life", "Baho for Life")
              )),
              tags$li(tags$a(href = "#ai-assistant", 
                tags$span(`data-en` = "AI Health Assistant", `data-rw` = "Umufasha w'Ubuzima w'AI", "AI Health Assistant")
              )),
              tags$li(tags$a(href = "#consultations", 
                tags$span(`data-en` = "Health Consultations", `data-rw` = "Ubuvuzi bw'Ubuzima", "Health Consultations")
              ))
            )
          ),
          
          # Resources
          tags$div(
            class = "footer-section",
            tags$h4(class = "section-title",
              tags$span(`data-en` = "Resources", `data-rw` = "Ubwoba", "Resources")
            ),
            tags$ul(class = "footer-links",
              tags$li(tags$a(href = "#help", 
                tags$span(`data-en` = "Help Center", `data-rw` = "Ikigo cy'Ubufasha", "Help Center")
              )),
              tags$li(tags$a(href = "#faq", 
                tags$span(`data-en` = "FAQ", `data-rw` = "FAQ", "FAQ")
              )),
              tags$li(tags$a(href = "#guides", 
                tags$span(`data-en` = "User Guides", `data-rw` = "Amabwiriza y'Abakoresha", "User Guides")
              )),
              tags$li(tags$a(href = "#api", 
                tags$span(`data-en` = "API Documentation", `data-rw` = "Inyandiko z'API", "API Documentation")
              )),
              tags$li(tags$a(href = "#download", 
                tags$span(`data-en` = "Download App", `data-rw` = "Kuramo Porogaramu", "Download App")
              ))
            )
          ),
          
          # Contact Info
          tags$div(
            class = "footer-section contact-section",
            tags$h4(class = "section-title",
              tags$span(`data-en` = "Contact Us", `data-rw` = "Tuvugane", "Contact Us")
            ),
            tags$div(class = "contact-info",
              tags$div(class = "contact-item",
                tags$i(class = "fas fa-map-marker-alt"),
                tags$div(class = "contact-details",
                  tags$span(class = "contact-label", 
                    tags$span(`data-en` = "Address", `data-rw` = "Aderesi", "Address")
                  ),
                  tags$span(`data-en` = "KG 7 Ave, Kigali, Rwanda", `data-rw` = "KG 7 Ave, Kigali, Rwanda", "KG 7 Ave, Kigali, Rwanda")
                )
              ),
              tags$div(class = "contact-item",
                tags$i(class = "fas fa-phone"),
                tags$div(class = "contact-details",
                  tags$span(class = "contact-label",
                    tags$span(`data-en` = "Phone", `data-rw` = "Telefone", "Phone")
                  ),
                  tags$span(`data-en` = "+250 123 456 789", `data-rw` = "+250 123 456 789", "+250 123 456 789")
                )
              ),
              tags$div(class = "contact-item",
                tags$i(class = "fas fa-envelope"),
                tags$div(class = "contact-details",
                  tags$span(class = "contact-label",
                    tags$span(`data-en` = "Email", `data-rw` = "Imeri", "Email")
                  ),
                  tags$span(`data-en` = "info@baho.rw", `data-rw` = "info@baho.rw", "info@baho.rw")
                )
              ),
              tags$div(class = "contact-item",
                tags$i(class = "fas fa-clock"),
                tags$div(class = "contact-details",
                  tags$span(class = "contact-label",
                    tags$span(`data-en` = "Hours", `data-rw` = "Amasaha", "Hours")
                  ),
                  tags$span(`data-en` = "Mon-Fri: 8AM-6PM", `data-rw` = "Kuwa Gatatu-Kuwa Gatanu: 8AM-6PM", "Mon-Fri: 8AM-6PM")
                )
              )
            )
          )
        )
      )
    ),
    
    # Footer Bottom
    tags$div(
      class = "footer-bottom",
      tags$div(
        class = "container",
        tags$div(
          class = "footer-bottom-content",
          tags$div(class = "footer-bottom-left",
            tags$p(class = "copyright",
              tags$span(`data-en` = paste0("© ", format(Sys.Date(), "%Y"), " Baho. All rights reserved. Built for Rwanda's healthcare future."), 
                       `data-rw` = paste0("© ", format(Sys.Date(), "%Y"), " Baho. Uburenganzira bwose burabitswe. Byakozwe ku buzima bw'ubuzima bw'u Rwanda."), 
                       paste0("© ", format(Sys.Date(), "%Y"), " Baho. All rights reserved. Built for Rwanda's healthcare future."))
            )
          ),
          tags$div(class = "footer-bottom-right",
            tags$div(class = "footer-bottom-links",
              tags$a(href = "#privacy", 
                tags$span(`data-en` = "Privacy Policy", `data-rw` = "Politiki y'Ubwigenge", "Privacy Policy")
              ),
              tags$a(href = "#terms", 
                tags$span(`data-en` = "Terms of Service", `data-rw` = "Amabwiriza y'Ubucuruzi", "Terms of Service")
              ),
              tags$a(href = "#cookies", 
                tags$span(`data-en` = "Cookie Policy", `data-rw` = "Politiki y'Amakuki", "Cookie Policy")
              )
            )
          )
        )
      )
    )
  ),
  
  # Include Font Awesome for icons
  tags$script(src = "https://kit.fontawesome.com/your-fontawesome-kit.js", crossorigin = "anonymous"),
  
  # Advanced JavaScript for navbar interactions
  tags$script(HTML("
    document.addEventListener('DOMContentLoaded', function() {
      
      // Navigation handling
      Shiny.addCustomMessageHandler('navigateToChat', function(message) {
        // This will be handled by the main app server
        Shiny.setInputValue('start_chatting', Math.random(), {priority: 'event'});
      });
      
      Shiny.addCustomMessageHandler('navigateToHome', function(message) {
        Shiny.setInputValue('back_to_home', Math.random(), {priority: 'event'});
      });
      const navbar = document.getElementById('main-navbar');
      const mobileMenuBtn = document.getElementById('mobile-menu-btn');
      const mobileMenu = document.getElementById('mobile-menu');
      const langBtn = document.getElementById('lang-btn');
      const langText = document.querySelector('.lang-text');
      
      
      // Mobile menu toggle
      mobileMenuBtn.addEventListener('click', function() {
        mobileMenuBtn.classList.toggle('active');
        mobileMenu.classList.toggle('active');
        document.body.style.overflow = mobileMenu.classList.contains('active') ? 'hidden' : '';
      });
      
      // Close mobile menu when clicking on links
      const mobileNavLinks = document.querySelectorAll('.mobile-nav-link');
      mobileNavLinks.forEach(link => {
        link.addEventListener('click', function() {
          mobileMenuBtn.classList.remove('active');
          mobileMenu.classList.remove('active');
          document.body.style.overflow = '';
        });
      });
      
      // Language switcher with Kinyarwanda as default
      let currentLang = 'rw'; // Default to Kinyarwanda
      const langDropdown = document.getElementById('lang-dropdown');
      
      // Function to switch language
      function switchLanguage(lang) {
        currentLang = lang;
        const elements = document.querySelectorAll('[data-en][data-rw]');
        
        elements.forEach(element => {
          if (lang === 'en') {
            element.textContent = element.getAttribute('data-en');
          } else {
            element.textContent = element.getAttribute('data-rw');
          }
        });
        
        // Update language button text
        langText.textContent = lang === 'en' ? 'EN' : 'RW';
        
        // Store preference
        localStorage.setItem('baho-language', lang);
      }
      
      // Load saved language preference or default to Kinyarwanda
      const savedLang = localStorage.getItem('baho-language') || 'rw';
      switchLanguage(savedLang);
      
      // Toggle dropdown
      langBtn.addEventListener('click', function(e) {
        e.preventDefault();
        e.stopPropagation();
        langDropdown.classList.toggle('active');
      });
      
      // Close dropdown when clicking outside
      document.addEventListener('click', function(e) {
        if (!e.target.closest('.language-switcher')) {
          langDropdown.classList.remove('active');
        }
      });
      
      // Language switcher event listeners
      const langOptions = document.querySelectorAll('.lang-option');
      langOptions.forEach(option => {
        option.addEventListener('click', function(e) {
          e.preventDefault();
          const langCode = this.getAttribute('data-lang');
          switchLanguage(langCode);
          langDropdown.classList.remove('active');
          
          // Add ripple effect
          const ripple = document.createElement('span');
          ripple.classList.add('ripple');
          this.appendChild(ripple);
          
          setTimeout(() => {
            ripple.remove();
          }, 600);
        });
      });
      
      // Smooth scrolling for navigation links
      const navLinks = document.querySelectorAll('.nav-link, .mobile-nav-link');
      navLinks.forEach(link => {
        link.addEventListener('click', function(e) {
          const href = this.getAttribute('href');
          if (href.startsWith('#')) {
            e.preventDefault();
            const target = document.querySelector(href);
            if (target) {
              target.scrollIntoView({
                behavior: 'smooth',
                block: 'start'
              });
            }
          }
        });
      });
      
      // Add intersection observer for active nav link highlighting
      const sections = document.querySelectorAll('section[id]');
      const observerOptions = {
        root: null,
        rootMargin: '-50% 0px -50% 0px',
        threshold: 0
      };
      
      const observer = new IntersectionObserver(function(entries) {
        entries.forEach(entry => {
          if (entry.isIntersecting) {
            const id = entry.target.getAttribute('id');
            const activeLink = document.querySelector(`.nav-link[href='#${id}']`);
            const activeMobileLink = document.querySelector(`.mobile-nav-link[href='#${id}']`);
            
            // Remove active class from all links
            document.querySelectorAll('.nav-link, .mobile-nav-link').forEach(link => {
              link.classList.remove('active');
            });
            
            // Add active class to current section links
            if (activeLink) activeLink.classList.add('active');
            if (activeMobileLink) activeMobileLink.classList.add('active');
          }
        });
      }, observerOptions);
      
      sections.forEach(section => {
        observer.observe(section);
      });
      
      
       // Image Carousel Functionality
       let currentSlide = 0;
       const images = document.querySelectorAll('.hero-doctor-image');
       const indicators = document.querySelectorAll('.indicator');
       const totalSlides = images.length;
       
       function showSlide(index) {
         // Remove active class from all images
         images.forEach(img => img.classList.remove('active'));
         indicators.forEach(ind => ind.classList.remove('active'));
         
         // Add active class to current image and indicator
         images[index].classList.add('active');
         indicators[index].classList.add('active');
         
         currentSlide = index;
       }
       
       function nextSlide() {
         const nextIndex = (currentSlide + 1) % totalSlides;
         showSlide(nextIndex);
       }
       
       // Auto-advance slides every 15 seconds
       setInterval(nextSlide, 15000);
       
       // Manual navigation with indicators
       indicators.forEach((indicator, index) => {
         indicator.addEventListener('click', function() {
           showSlide(index);
         });
       });
       
       // Pause auto-advance on hover
       const carousel = document.querySelector('.image-carousel');
       if (carousel) {
         carousel.addEventListener('mouseenter', function() {
           clearInterval(window.carouselInterval);
         });
         
         carousel.addEventListener('mouseleave', function() {
           window.carouselInterval = setInterval(nextSlide, 15000);
         });
       }
       
       // Story Section Scroll Animations
       const storyObserver = new IntersectionObserver(function(entries) {
         entries.forEach(entry => {
           if (entry.isIntersecting) {
             entry.target.style.animationPlayState = 'running';
             entry.target.classList.add('animate-in');
             
             // Add staggered animation to child elements
             const textElement = entry.target.querySelector('.story-text');
             const imageElement = entry.target.querySelector('.story-image');
             const iconElement = entry.target.querySelector('.story-icon');
             
             if (textElement) {
               setTimeout(() => {
                 textElement.style.opacity = '1';
                 textElement.style.transform = 'translateY(0)';
               }, 200);
             }
             
             if (imageElement) {
               setTimeout(() => {
                 imageElement.style.opacity = '1';
                 imageElement.style.transform = 'translateY(0) scale(1)';
               }, 400);
             }
             
             if (iconElement) {
               setTimeout(() => {
                 iconElement.style.opacity = '1';
                 iconElement.style.transform = 'scale(1) rotate(0deg)';
               }, 100);
             }
           }
         });
       }, {
         threshold: 0.2,
         rootMargin: '0px 0px -100px 0px'
       });
       
       // Initialize story sections with hidden state
       const storySections = document.querySelectorAll('.story-section-content');
       storySections.forEach(section => {
         const textElement = section.querySelector('.story-text');
         const imageElement = section.querySelector('.story-image');
         const iconElement = section.querySelector('.story-icon');
         
         if (textElement) {
           textElement.style.opacity = '0';
           textElement.style.transform = 'translateY(30px)';
           textElement.style.transition = 'all 0.6s cubic-bezier(0.25, 0.46, 0.45, 0.94)';
         }
         
         if (imageElement) {
           imageElement.style.opacity = '0';
           imageElement.style.transform = 'translateY(30px) scale(0.95)';
           imageElement.style.transition = 'all 0.8s cubic-bezier(0.25, 0.46, 0.45, 0.94)';
         }
         
         if (iconElement) {
           iconElement.style.opacity = '0';
           iconElement.style.transform = 'scale(0.8) rotate(-10deg)';
           iconElement.style.transition = 'all 0.5s cubic-bezier(0.25, 0.46, 0.45, 0.94)';
         }
         
         storyObserver.observe(section);
       });
       
       // Parallax effect for story icons
       window.addEventListener('scroll', function() {
         const scrolled = window.pageYOffset;
         const storyIcons = document.querySelectorAll('.story-icon');
         
         storyIcons.forEach((icon, index) => {
           const rect = icon.getBoundingClientRect();
           const speed = 0.1 + (index * 0.05);
           const yPos = -(scrolled - rect.top) * speed;
           icon.style.transform = `translateY(${yPos}px)`;
         });
       });
       
       // Floating animation for story icons
       function addFloatingAnimation() {
         const storyIcons = document.querySelectorAll('.story-icon');
         storyIcons.forEach((icon, index) => {
           icon.style.animation = `float ${3 + index * 0.5}s ease-in-out infinite`;
           icon.style.animationDelay = `${index * 0.3}s`;
         });
       }
       
       // Add floating keyframes
       const style = document.createElement('style');
       style.textContent = `
         @keyframes float {
           0%, 100% { transform: translateY(0px); }
           50% { transform: translateY(-10px); }
         }
       `;
       document.head.appendChild(style);
       
       // Initialize floating animation
       addFloatingAnimation();
       
       // Scroll to Top Button Functionality
       const scrollToTopBtn = document.getElementById('scroll-to-top');
       
       // Show/hide button based on scroll position
       window.addEventListener('scroll', function() {
         if (window.pageYOffset > 300) {
           scrollToTopBtn.classList.add('show');
         } else {
           scrollToTopBtn.classList.remove('show');
         }
       });
       
       // Scroll to top when button is clicked
       scrollToTopBtn.addEventListener('click', function() {
         window.scrollTo({
           top: 0,
           behavior: 'smooth'
         });
       });
    });
  ")),
  
  # Scroll to Top Button
  tags$img(
    id = "scroll-to-top",
    src = "scroll.png",
    alt = "Scroll to top",
    class = "scroll-to-top-btn"
  )
  )
}

# Landing Page Module Server
landingPageServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    # Handle start chatting button
    observeEvent(input$start_chatting, {
      # Debug output
      cat("Start chatting button clicked!\n")
      
      # Trigger navigation to chat page
      session$sendCustomMessage("navigateToChat", list())
    })
    
    # Landing page server logic can be added here
    # Currently all functionality is handled by JavaScript
  })
}
