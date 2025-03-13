# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: apcq070.4gl 
# Descriptions...: POS上下传显示作业 
# Date & Author..: 11/11/02 by jiangbo 
# Modify.........: FUN-CA0119

DATABASE ds
 
GLOBALS "../../config/top.global"
 
GLOBALS
   DEFINE la_license      DYNAMIC ARRAY OF RECORD
           ip             LIKE type_file.chr50,
           ap             LIKE type_file.chr50
                          END RECORD
END GLOBALS

DEFINE ga_process   DYNAMIC ARRAY OF RECORD
                       p01       STRING,   #Login User
                       user_name STRING,   #User Name
                       mail      STRING,   #User Name
                       p02       STRING,   #Program ID
                       p03       STRING,   #PID
                       p10       STRING,   #User IP
                       p04       STRING,   #Department
                       p05       STRING,   #Start Time
                       p06       STRING,   #Current Time
                      #p07       STRING,   #Execution Command
                       p07       STRING,   #Duration Time
                       p08       STRING,   #Database 
                       p09       STRING,   #Multi-AP
                       gen05     STRING,   #extension no
                       gen08     STRING    #mobile phone

                    END RECORD

DEFINE gi_count     LIKE type_file.num10   
DEFINE gi_arr       LIKE type_file.num10  
 
#FUN-CA0119
MAIN
   OPTIONS 
       INPUT NO WRAP
   DEFER INTERRUPT                                # 擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("APC")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog, g_time, 1) RETURNING g_time 
 
   OPEN WINDOW p_process_w WITH FORM "apc/42f/apcq070" 
        ATTRIBUTE(STYLE=g_win_style CLIPPED)
   CALL cl_ui_init()
 
   WHILE TRUE
      LET g_action_choice = NULL
      CALL p_generateProcessList()
      CALL p_showProcessList()
      IF g_action_choice = "exit" THEN
         EXIT WHILE
      END IF
   END WHILE
 
   CLOSE WINDOW p_process_w                  # 結束畫面

   CALL cl_used(g_prog, g_time, 2) RETURNING g_time 
END MAIN
 
FUNCTION p_generateProcessList()
   DEFINE lch_cmd     base.Channel
   DEFINE ls_cmd      STRING,
          ls_result   STRING,
          ls_token    STRING
   DEFINE lst_token   base.StringTokenizer
   DEFINE li_i        LIKE type_file.num10,
          li_minute   LIKE type_file.num10 
   DEFINE ls_sql      STRING
   DEFINE lr_gbq      DYNAMIC ARRAY OF RECORD LIKE gbq_file.*
   DEFINE li_j        LIKE type_file.num10 
   DEFINE lc_zx01     LIKE zx_file.zx01   
   DEFINE lc_zx02     LIKE zx_file.zx02  
   DEFINE lc_zx09     LIKE zx_file.zx09 
   DEFINE lc_gen01    LIKE gen_file.gen01
   DEFINE lc_gen05    LIKE gen_file.gen05
   DEFINE lc_gen08    LIKE gen_file.gen08
   DEFINE lc_pid      LIKE gbq_file.gbq01   
   DEFINE lc_machine  LIKE gbq_file.gbq11  
   DEFINE l_buf       base.StringBuffer
   DEFINE l_buf2      base.StringBuffer
   DEFINE l_str       STRING
   DEFINE temp_hour,temp_min,temp_sec,temp_hour2,temp_min2,temp_sec2   INTEGER
   DEFINE space_time  INTEGER
   DEFINE space_h,space_m   SMALLINT
   DEFINE cur_time DATETIME HOUR TO SECOND
   DEFINE cur_time_str STRING
  #DEFINE space_h     VARCHAR(6)
  #DEFINE space_m     VARCHAR(2)
 
   #拿出gbq_file裡面的資料準備對照
   CALL cl_process_check()  #先將gbq_file內的資料refresh
   LET ls_sql = " SELECT * FROM gbq_file",
		 " WHERE gbq04 = 'apcp100' OR gbq04 = 'apcp101' OR gbq04 = 'apcp200'",
		 " ORDER BY gbq03,gbq02,gbq01"
   PREPARE gbq_pre FROM ls_sql
   DECLARE gbq_curs CURSOR FOR gbq_pre
 
   LET gi_count = 1
   FOREACH gbq_curs INTO lr_gbq[gi_count].*
      IF SQLCA.sqlcode THEN
         EXIT FOREACH
      END IF
 
      LET gi_count = gi_count + 1
   END FOREACH
   CALL lr_gbq.deleteElement(gi_count)
   #No.FUN-5A0222 ---end---
 
   CALL ga_process.clear()
#  CALL ga_color.clear()
   LET gi_count = 1
 
   CALL fgl_setenv("COLUMNS","132")	#jiangbo
  #LET ls_cmd = "ps -ef | grep fglrun | grep -v 'grep' | grep -E 'apcp100|apcp101|apcp200' | grep -v 'fgldeb'"
   LET ls_cmd = "ps -ef | grep -E 'apcp100|apcp101|apcp200'| grep fglrun-bin | grep -v p_cron | grep -v r.d2+ | grep 42r | grep -v fgldeb |grep -v 'apcq070 apcp100'"
 
   LET lch_cmd = base.Channel.create()
   CALL lch_cmd.openPipe(ls_cmd, "r")
   WHILE lch_cmd.read(ls_result)
       LET lst_token = base.StringTokenizer.create(ls_result, ' ')
       LET li_i = 1
       WHILE lst_token.hasMoreTokens()
           LET ls_token = lst_token.nextToken()
           CASE
                WHEN li_i = 1   #Login User
                     LET ga_process[gi_count].p01 = ls_token
                WHEN li_i = 2   #PID
                     LET ga_process[gi_count].p03 = ls_token
                WHEN li_i = 5   #Start Time
                     LET ga_process[gi_count].p05 = ls_token
                WHEN li_i >= 9    #Execution Command
                     LET ga_process[gi_count].p02 = ga_process[gi_count].p02, " ", ls_token
           END CASE

          # #Program ID
          # LET ls_sql = "SELECT machine FROM v$SESSION WHERE process = ? "
          # PREPARE pid_pre FROM ls_sql

          # LET lc_pid = ga_process[gi_count].p03
          # EXECUTE pid_pre USING lc_pid INTO lc_machine
          # IF STATUS THEN
          #    CALL ga_process.deleteElement(gi_count)
          #    LET gi_count = gi_count - 1 
          #    EXIT WHILE
          # END IF
          # IF lc_machine = 'top30' THEN
          #    CONTINUE WHILE
          # ELSE 
          #    LET gi_count = gi_count - 1 
          #    CALL ga_process.deleteElement(gi_count)
          #    EXIT WHILE
          # END IF
           
           LET ls_sql = "SELECT zx02,zx09 FROM zx_file WHERE zx01 = ? "
           PREPARE zx02_pre FROM ls_sql

           LET lc_zx01 = ga_process[gi_count].p01
           EXECUTE zx02_pre USING lc_zx01 INTO lc_zx02,lc_zx09
           IF NOT STATUS THEN
              LET ga_process[gi_count].user_name = lc_zx02
              LET ga_process[gi_count].mail = lc_zx09
           END IF

           #gen05,gen08
           LET ls_sql = "SELECT gen05,gen08 FROM gen_file WHERE gen01 = ? "
           PREPARE gen05_pre FROM ls_sql

           LET lc_gen01 = ga_process[gi_count].p01
           EXECUTE gen05_pre USING lc_gen01 INTO lc_gen05,lc_gen08
           IF NOT STATUS THEN
              LET ga_process[gi_count].gen05 = lc_gen05
              LET ga_process[gi_count].gen08 = lc_gen08
           END IF

           IF g_lang = '0' OR g_lang = '2' THEN
           LET ga_process[gi_count].p10 = '非本區域作業'         #都先填入非本區,本區的再由gbq更正
           ELSE
              LET ga_process[gi_count].p10 = 'Not this Area'
           END IF

           LET cur_time = CURRENT HOUR TO SECOND
           LET cur_time_str = cur_time
           LET ga_process[gi_count].p06 = cur_time_str   #当前时间
           LET ga_process[gi_count].p09 = cl_used_ap_hostname()   #本機查出的PID均應填入本機AP名稱

           FOR li_j = 1 TO lr_gbq.getLength()
               IF ga_process[gi_count].p03 = lr_gbq[li_j].gbq01 AND
                  ga_process[gi_count].p09 = lr_gbq[li_j].gbq11 THEN       
                  LET ga_process[gi_count].p01 = lr_gbq[li_j].gbq03 #User
                  LET ga_process[gi_count].p02 = lr_gbq[li_j].gbq04 #Program ID
                  LET ga_process[gi_count].p04 = lr_gbq[li_j].gbq05 #Department
                  LET ga_process[gi_count].p05 = lr_gbq[li_j].gbq07 #Start Time
                 #LET ga_process[gi_count].p06 = g_time		    #Current Time
                  LET ga_process[gi_count].p10 = lr_gbq[li_j].gbq02 #IP
                  LET cur_time = CURRENT HOUR TO SECOND
                  LET cur_time_str = cur_time
                  LET ga_process[gi_count].p06 = cur_time_str   #当前时间

                 #计算程序运行时间
                  LET l_buf = base.StringBuffer.create()
                  LET l_buf2 = base.StringBuffer.create()
                  CALL l_buf.clear()
                  CALL l_buf2.clear()
                  CALL l_buf.append(ga_process[gi_count].p05)
                  CALL l_buf2.append(ga_process[gi_count].p06)

                  #将VARCHAR-->INTEGER,并计算当前时间总秒数
                  LET temp_hour2 = l_buf2.subString(1,2)
                  LET temp_min2 = l_buf2.subString(4,5)
                  #将VARCHAR-->INTERGER,并计算开始时间总秒数
                  LET temp_hour = l_buf.subString(10,11)
                  LET temp_min = l_buf.subString(13,14)

                  #计算时间差
                  LET space_time = (temp_hour2*3600 + temp_min2*60 + temp_sec2) - (temp_hour*3600 + temp_min*60 + temp_sec)
                  LET space_h = space_time / 3600
                  LET space_m = (space_time MOD 3600) / 60
                  LET ga_process[gi_count].p07 = space_h,"h",space_m,"m"
                  LET ga_process[gi_count].p07 = ga_process[gi_count].p07

                  LET ga_process[gi_count].p08 = lr_gbq[li_j].gbq10 #Database 
               #  LET ga_process[gi_count].p09 = lr_gbq[li_j].gbq11 #Multi-AP
              #jiangbo time error
             #  ELSE 
             #     LET cur_time = CURRENT HOUR TO SECOND
             #     LET cur_time_str = cur_time
             #     LET ga_process[gi_count].p06 = cur_time_str   #当前时间
             #    #计算程序运行时间
             #     LET l_buf = base.StringBuffer.create()
             #     LET l_buf2 = base.StringBuffer.create()
             #     CALL l_buf.clear()
             #     CALL l_buf2.clear()
             #     CALL l_buf.append(ga_process[gi_count].p05)
             #     CALL l_buf2.append(ga_process[gi_count].p06)
             #     #将VARCHAR-->INTEGER,并计算当前时间总秒数
             #     LET temp_hour2 = l_buf2.subString(1,2)
             #     LET temp_min2 = l_buf2.subString(4,5)
             #     #将VARCHAR-->INTERGER,并计算开始时间总秒数
             #     LET temp_hour = l_buf.subString(1,2)
             #     LET temp_min = l_buf.subString(4,5)
             #     #计算时间差
             #     LET space_time = (temp_hour2*3600 + temp_min2*60) - (temp_hour*3600 + temp_min*60)
             #     LET space_h = space_time / 3600
             #     LET space_m = (space_time MOD 3600) / 60
             #     LET ga_process[gi_count].p07 = space_h,"h",space_m,"m"
             #     LET ga_process[gi_count].p07 = ga_process[gi_count].p07
                END IF
              # #此處不應受最大筆數控管 #FUN-780050
           END FOR
           LET li_i = li_i + 1
       END WHILE
       LET gi_count = gi_count + 1   #TQC-B90122
   END WHILE

#  FUN-A80037 新增 顯示非本機(AP Server)所有的gbq資料
#  DISPLAY gi_count TO FORMONLY.cnt

   LET li_i = 1
   WHILE TRUE
      IF li_i > lr_gbq.getLength() THEN
         EXIT WHILE
      END IF
      FOR li_j = 1 TO ga_process.getLength()
         IF ga_process[li_j].p03 = lr_gbq[li_i].gbq01 AND ga_process[li_j].p09 = lr_gbq[li_i].gbq11 THEN
            LET li_i = li_i + 1
            CONTINUE WHILE
         END IF
      END FOR
      LET li_minute = ga_process.getLength() + 1
      LET ga_process[li_minute].p01 = lr_gbq[li_i].gbq03 #User
      LET ga_process[li_minute].p02 = lr_gbq[li_i].gbq04 #Program ID
      LET ga_process[li_minute].p03 = lr_gbq[li_i].gbq01 #ProcessID
      LET ga_process[li_minute].p04 = lr_gbq[li_i].gbq05 #Department
      LET ga_process[li_minute].p05 = lr_gbq[li_i].gbq07 #Start Time
      LET ga_process[li_minute].p08 = lr_gbq[li_i].gbq10 #Database No.FUN-660135
      LET ga_process[li_minute].p10 = lr_gbq[li_i].gbq02 #Program ID
      LET cur_time = CURRENT HOUR TO SECOND
      LET cur_time_str = cur_time
      LET ga_process[li_minute].p06 = cur_time_str	 #Current Time

      IF g_lang = '0' OR g_lang = '2' THEN
         LET ga_process[li_minute].p07 = '非本機(AP Server)作業'
      ELSE
         LET ga_process[li_minute].p07 = 'Job is on Another AP Server.'
      END IF

      #计算程序运行时间
        LET l_buf = base.StringBuffer.create()
        LET l_buf2 = base.StringBuffer.create()
        CALL l_buf.clear()
        CALL l_buf2.clear()
        CALL l_buf.append(ga_process[li_minute].p05)
        CALL l_buf2.append(ga_process[li_minute].p06)

        #将VARCHAR-->INTEGER,并计算当前时间总秒数
        LET temp_hour2 = l_buf2.subString(1,2)
        LET temp_min2 = l_buf2.subString(4,5)
        #将VARCHAR-->INTERGER,并计算开始时间总秒数
        LET temp_hour = l_buf.subString(10,11)
        LET temp_min = l_buf.subString(13,14)

        #计算时间差
        LET space_time = (temp_hour2*3600 + temp_min2*60 + temp_sec2) - (temp_hour*3600 + temp_min*60 + temp_sec)
        LET space_h = space_time / 3600
        LET space_m = (space_time MOD 3600) / 60
        LET ga_process[li_minute].p07 = space_h,"h",space_m,"m"
        LET ga_process[li_minute].p07 = ga_process[li_minute].p07 CLIPPED

      LET ga_process[li_minute].p09 = lr_gbq[li_i].gbq11 #Multi-AP

      LET ls_sql = "SELECT zx02,zx09 FROM zx_file WHERE zx01 = ? "
      PREPARE zx02_pre2 FROM ls_sql
      LET lc_zx01 = ga_process[li_minute].p01
      EXECUTE zx02_pre2 USING lc_zx01 INTO lc_zx02,lc_zx09
      IF NOT STATUS THEN
         LET ga_process[li_minute].user_name = lc_zx02
         LET ga_process[li_minute].mail = lc_zx09
      END IF

      #gen05,gen08
      LET lc_gen01 = ga_process[li_minute].p01
      EXECUTE gen05_pre USING lc_gen01 INTO lc_gen05,lc_gen08
      IF NOT STATUS THEN
         LET ga_process[li_minute].gen05 = lc_gen05
         LET ga_process[li_minute].gen08 = lc_gen08
      END IF

      LET li_i = li_i + 1
   END WHILE

   LET gi_count = gi_count - 1
   DISPLAY gi_count TO FORMONLY.cnt
   CALL lch_cmd.close()
END FUNCTION
 
FUNCTION p_showProcessList()
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY ga_process TO s_process.*
       ATTRIBUTE (COUNT = gi_count - 1, UNBUFFERED)
 
       BEFORE DISPLAY
#          CALL DIALOG.setCellAttributes(ga_color)	#mark by jiangbo
           LET gi_arr = 1
           CALL FGL_SET_ARR_CURR(gi_arr) 
 
       BEFORE ROW
           LET gi_arr = ARR_CURR()
           CALL cl_show_fld_cont()
 
       ON ACTION accept
           CONTINUE DISPLAY
 
       ON ACTION cancel
           LET INT_FLAG = FALSE
           LET g_action_choice = "exit"
           EXIT DISPLAY
 
       #No.FUN-660158 --start--
       #ON ACTION output
       #   LET g_action_choice="output"
       #   IF cl_chk_act_auth() THEN
       #      CALL cl_set_act_visible("accept,cancel",TRUE)   #No.FUN-740179
       #      CALL process_out()
       #      CALL cl_set_act_visible("accept,cancel",FALSE)  #No.FUN-740179
       #   END IF
       #No.FUN-660158 ---end---
 
       #No.FUN-5A0222 --start--
       ON ACTION about
          CALL cl_about()
 
       ON ACTION license_detail                #FUN-A80037
          CALL p_process_license_detail()

       ON ACTION help
          CALL cl_show_help()
 
       ON ACTION controlg
          CALL cl_cmdask()
 
       ON ACTION locale
          CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()
       #No.FUN-5A0222 ---end---
 
       ON ACTION exit
           LET g_action_choice = "exit"
           EXIT DISPLAY
 
       ON ACTION refresh
           EXIT DISPLAY 
 
       #No.FUN-5A0222 --start--   
#      ON ACTION kill
#          CALL p_killProcess()
#          EXIT DISPLAY
       #No.FUN-5A0222 ---end---
 
       ON IDLE 10
           EXIT DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 

FUNCTION p_process_license_detail()

   DEFINE lw_window    ui.Window
   DEFINE ls_result    STRING
   DEFINE li_i         LIKE type_file.num10

   OPEN WINDOW p_process_license WITH 50 ROWS, 30 COLUMNS

   LET lw_window = ui.Window.getCurrent()
   CALL lw_window.setText("TIPTOP GP Licensed List")
   CALL cl_licensed_list()

   LET ls_result = "Client IP:Port / AP Server \n"
   FOR li_i = 1 TO la_license.getLength()
      LET ls_result = ls_result,la_license[li_i].ip CLIPPED," / ",la_license[li_i].ap CLIPPED,"\n"
   END FOR
   LET ls_result = ls_result,"\nTotal Licensed: ",la_license.getLength() USING "<<<<&"," User(s)."
   LET ls_result = ls_result,"\nCount Time: ",current year to second CLIPPED
   DISPLAY ls_result at 5,5

   MENU
      COMMAND "Ok!"
         EXIT MENU
      COMMAND KEY(INTERRUPT)
         EXIT MENU
   END MENU

   CLOSE WINDOW p_process_license

END FUNCTION


FUNCTION p_killProcess()
   DEFINE li_ret     LIKE type_file.num10   #No.FUN-680135 INTEGER
 
 
   IF g_user CLIPPED != ga_process[gi_arr].p01 THEN
      IF g_user CLIPPED != "tiptop" THEN
         CALL cl_err("You're not TIPTOP administrator.", "!", 1)
      ELSE
         RUN "killproc " || ga_process[gi_arr].p03 RETURNING li_ret
         SLEEP 1
      END IF
   ELSE
      RUN "kill -9 " || ga_process[gi_arr].p03 RETURNING li_ret
      SLEEP 1
   END IF
 
   IF li_ret THEN
      CALL cl_err("Fail to kill this process.", "!", 1)
   END IF
END FUNCTION
 
##No.FUN-660158 --start--
#FUNCTION process_out()
#   DEFINE   sr              RECORD
#               p01          STRING,   #Login User
#               user_name    STRING,   #User Name
#               mail         STRING,   #User Name
#              #p02          STRING,   #Login IP
#               p02          STRING,   #Program ID
#               p03          STRING,   #PID
#               p04          STRING,   #Department
#               p05          STRING,   #Start Time
#              #p06          STRING,   #GUI Mode
#               p06          STRING,   #Current Time
#               p07          STRING,   #Execution Command
#               p08          STRING,   #Database No.FUN-660135
#               p09          STRING,   #Multi-AP No.FUN-950082
#               gen05        STRING,   #extesion no
#               gen08        STRING    #mobile phone
#                            END RECORD
#   DEFINE   li_i         LIKE type_file.num5,   #No.FUN-680135 SMALLINT
#            l_name       LIKE type_file.chr20,  # External(Disk) file name    #No.FUN-680135 VARCHAR(20)
#            l_za05       LIKE type_file.chr1000 #        #No.FUN-680135 VARCHAR(40)
#  
#   CALL cl_wait()
#   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
# 
#   CALL cl_outnam('p_process') RETURNING l_name
#   START REPORT process_rep TO l_name
# 
#   FOR li_i = 1 TO ga_process.getLength()
#       LET sr.* = ga_process[li_i].*
#       OUTPUT TO REPORT process_rep(sr.*)
#   END FOR
# 
#   FINISH REPORT process_rep
# 
#   ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)
#END FUNCTION
# 
#REPORT process_rep(sr)
#   DEFINE   l_trailer_sw    LIKE type_file.chr1,    #No.FUN-680135 VARCHAR(1)
#            sr              RECORD
#               p01          LIKE gbq_file.gbq03,    #No.FUN-680135 VARCHAR(10) #Login User
#               user_name    LIKE gbq_file.gbq03,    #No.FUN-680135 VARCHAR(10) #User Name
#              #p02          LIKE gbq_file.gbq02,    #No.FUN-680135 VARCHAR(30) #Login IP
#               p02          LIKE gbq_file.gbq04,    #No.FUN-680135 VARCHAR(30) #Program ID
#               p03          LIKE gbq_file.gbq03,    #No.FUN-680135 VARCHAR(10) #PID
# Prog. Version..: '5.30.06-13.03.12(06) #Department
#               p05          LIKE gbq_file.gbq07,    #No.FUN-680135 VARCHAR(20) #Start Time
#              #p06          LIKE gbq_file.gbq06,    #No.FUN-680135 SMALLINT #GUI Mode
#               p06          LIKE gbq_file.gbq07,    #No.FUN-680135 SMALLINT #Current time
#               p07          LIKE type_file.chr1000, #No.FUN-680135 VARCHAR(100)#Execution Command
#               p08          LIKE gbq_file.gbq10,    #No.FUN-680135 VARCHAR(20) #Database No.FUN-660135
#               p09          LIKE gbq_file.gbq11                                #Multi-AP No.FUN-950082
#                            END RECORD
# 
#   OUTPUT
#       TOP MARGIN g_top_margin
#       LEFT MARGIN g_left_margin
#       BOTTOM MARGIN g_bottom_margin
#       PAGE LENGTH g_page_line
# 
#    ORDER BY sr.p01
# 
#    FORMAT
#        PAGE HEADER
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#            LET g_pageno=g_pageno+1
#            LET pageno_total=PAGENO USING '<<<',"/pageno"
#            PRINT g_head CLIPPED,pageno_total
#            PRINT g_dash[1,g_len]
#            PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
#                  g_x[35] CLIPPED,g_x[36] CLIPPED,g_x[37] CLIPPED,g_x[38] CLIPPED,
#                  g_x[39] CLIPPED,g_x[40] CLIPPED                                    #MOD-B70145 add ,g_x[40] CLIPPED
#            PRINT g_dash1
#            LET l_trailer_sw = 'y'
# 
#        ON EVERY ROW
#           PRINT COLUMN g_c[31],sr.p01,
#                 COLUMN g_c[32],sr.user_name,
#                 COLUMN g_c[33],sr.user_name,
#                 COLUMN g_c[34],sr.p02,
#                 COLUMN g_c[35],sr.p03,
#                 COLUMN g_c[36],sr.p04,
#                 COLUMN g_c[37],sr.p05,
#                 COLUMN g_c[38],sr.p06,
#                 COLUMN g_c[39],sr.p07,
#                 COLUMN g_c[40],sr.p08,
#                 COLUMN g_c[41],sr.p09,
#                 COLUMN g_c[42],sr.gen05,
#                 COLUMN g_c[43],sr.gen08,
# 
#        ON LAST ROW
#            PRINT g_dash[1,g_len]
#            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#            LET l_trailer_sw = 'n'
# 
#        PAGE TRAILER
#            IF l_trailer_sw = 'y' THEN
#                PRINT g_dash[1,g_len]
#                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#            ELSE
#                SKIP 2 LINE
#            END IF
#END REPORT
##No.FUN-660158 ---end---
