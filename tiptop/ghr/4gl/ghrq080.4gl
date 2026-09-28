# Prog. Version..: '5.10.04-08.10.22(00000)'     #
#
# Pattern name...: ghrq080.4gl
# Descriptions...:
# Date & Author..: 06/24/13 by zhangbo

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE g_sql         STRING,
       g_wc1         STRING,
       g_wc2         STRING,
       g_wc3         STRING,
       g_wc4         STRING
DEFINE g_hrdm1      DYNAMIC ARRAY OF RECORD
         sel         LIKE   type_file.chr1,         #add by zhangbo130911   #sel = "N",
         hrat03      LIKE   hraa_file.hraa12,                               #hrat03 = "胜宏科技(惠州)股份有限公司",
         hrdm02      LIKE   hrdm_file.hrdm02,                               #hrdm02 = "1002",
         hrat02      LIKE   hrat_file.hrat02,                               #hrat02 = "周丽霞",
         hrat04      LIKE   hrao_file.hrao02,                               #hrat04 = "财务部",
         hrat05      LIKE   hras_file.hras04,                               #hrat05 = "会计",
         hrat25      LIKE   hrat_file.hrat25,                               #hrat25 = 13/02/27,
         hrat19      LIKE   hrad_file.hrad03,                               #hrat19 = "正式员工",
         hrat22      LIKE   hrag_file.hrag07,                               #hrat22 = "本科",
         hrat42      LIKE   hrai_file.hrai03,                               #hrat42 = "财务部",
         hraoud04    LIKE   hrag_file.hrag07                                #hraoud04 = (null)
                     END RECORD,
       g_rec_b1      LIKE type_file.num5,
       l_ac1         LIKE type_file.num5
DEFINE g_hrdm2      DYNAMIC ARRAY OF RECORD
         sel         LIKE   type_file.chr1,         #add by zhangbo130911
         hrdm02      LIKE   hrdm_file.hrdm02,
         hrat02      LIKE   hrat_file.hrat02,
         hrat03      LIKE   hraa_file.hraa12,
         hrat04      LIKE   hrao_file.hrao02,
         hram08      LIKE   hrdm_file.hrdm08,
         hrdm03      LIKE   hrdl_file.hrdl02,
         hrat05      LIKE   hras_file.hras04,
         hrat25      LIKE   hrat_file.hrat25,
         hrdm07      LIKE   hrdm_file.hrdm07,
         hrdm04      LIKE   hrdm_file.hrdm04,
         hrdm05      LIKE   hrdm_file.hrdm05,
         hrdm11      LIKE   hrdm_file.hrdm11,
         hrdm01      LIKE   hrdm_file.hrdm01
                     END RECORD,
       g_rec_b2      LIKE type_file.num5,
       l_ac2         LIKE type_file.num5
DEFINE g_hrdm3      DYNAMIC ARRAY OF RECORD
         sel         LIKE   type_file.chr1,         #add by zhangbo130911
         hrdm02      LIKE   hrdm_file.hrdm02,
         hrat02      LIKE   hrat_file.hrat02,
         hrat03      LIKE   hraa_file.hraa12,
         hrat04      LIKE   hrao_file.hrao02,
         hram08      LIKE   hrdm_file.hrdm08,
         hrdm03      LIKE   hrdl_file.hrdl02,
         hrat05      LIKE   hras_file.hras04,
         hrat25      LIKE   hrat_file.hrat25,
         hrdm07      LIKE   hrdm_file.hrdm07,
         hrdm04      LIKE   hrdm_file.hrdm04,
         hrdm05      LIKE   hrdm_file.hrdm05,
         hrdm09      LIKE   hrdm_file.hrdm09,
         hrdm11      LIKE   hrdm_file.hrdm11,
         hrdm01      LIKE   hrdm_file.hrdm01
                     END RECORD,
       g_rec_b3      LIKE type_file.num5,
       l_ac3         LIKE type_file.num5
DEFINE g_hrdm4      DYNAMIC ARRAY OF RECORD
         sel         LIKE   type_file.chr1,         #add by zhangbo130911
         hrdm02      LIKE   hrdm_file.hrdm02,
         hrat02      LIKE   hrat_file.hrat02,
         hrat03      LIKE   hraa_file.hraa12,
         hrat04      LIKE   hrao_file.hrao02,
         hram08      LIKE   hrdm_file.hrdm08,
         hrdm03      LIKE   hrdl_file.hrdl02,
         hrat05      LIKE   hras_file.hras04,
         hrat25      LIKE   hrat_file.hrat25,
         hrdm07      LIKE   hrdm_file.hrdm07,
         hrdm04      LIKE   hrdm_file.hrdm04,
         hrdm05      LIKE   hrdm_file.hrdm05,
         hrdm09      LIKE   hrdm_file.hrdm09,
         hrdm11      LIKE   hrdm_file.hrdm11,
         hrdm01      LIKE   hrdm_file.hrdm01
                     END RECORD,
       g_rec_b4      LIKE type_file.num5,
       l_ac4         LIKE type_file.num5
DEFINE g_flag        LIKE type_file.chr10
DEFINE g_cnt         LIKE type_file.num10
DEFINE g_i           LIKE type_file.num5
DEFINE g_row_count   LIKE type_file.num5
DEFINE g_curs_index  LIKE type_file.num5
#add by zhangbo130911---begin
DEFINE g_sel    DYNAMIC ARRAY OF RECORD
         hrdm02      LIKE   hrdm_file.hrdm02
                END RECORD
DEFINE g_rec_sel     LIKE   type_file.num5
DEFINE g_cx     DYNAMIC ARRAY OF RECORD
         hrdm01      LIKE   hrdm_file.hrdm01
                END RECORD
DEFINE g_rec_cx      LIKE   type_file.num5
#add by zhangbo130911---end
#add by zhuzw 20150122 start
   DEFINE w              ui.Window
   DEFINE f              ui.Form
   DEFINE page om.DomNode
#add by zhuzw 20150122 end

MAIN
DEFINE l_name   STRING
DEFINE l_items  STRING
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
   WHENEVER ERROR CALL cl_err_msg_log
   IF (NOT cl_setup("GHR")) THEN
      EXIT PROGRAM
   END IF

#   OPEN WINDOW q080_w WITH FORM "ghr/42f/ghrq080_new"
   OPEN WINDOW q080_w WITH FORM "ghr/42f/ghrq080"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)


   CALL cl_ui_init()

   LET g_wc1=" 1=1"
   LET g_wc2=" 1=1"
   LET g_wc3=" 1=1"
   LET g_wc4=" 1=1"

   LET g_flag='pg1'

   CALL q080_b_fill()

   CALL q080_menu()
   CLOSE WINDOW q080_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION q080_menu()
DEFINE l_n   LIKE  type_file.num5

   WHILE TRUE
   	  #mark by zhangbo130911---begin
   	  #CASE g_flag
   	  #   WHEN 'pg1'
      #      CALL q080_bp1("G")    #包含第一页签DISPLAY
      #   WHEN 'pg2'
      #      CALL q080_bp2("G")    #包含第二页签DISPLAY
      #   WHEN 'pg3'
      #      CALL q080_bp3("G")    #包含第三页签DISPLAY
      #   WHEN 'pg4'
      #      CALL q080_bp4("G")    #包含第四页签DISPLAY
      #   OTHERWISE
      #      CALL q080_bp("G")    #包含所有页签DISPLAY
      #END CASE
      #mark by zhangbo130911---end

      #add by zhangbo130911---begin
      IF cl_null(g_action_choice) THEN
      	 CASE g_flag
      	 	  WHEN 'pg1' CALL q080_b1()
      	 	  WHEN 'pg2' CALL q080_b2()
      	 	  WHEN 'pg3' CALL q080_b3()
      	 	  WHEN 'pg4' CALL q080_b4()
      	 END CASE
      END IF
      #add by zhangbo130911---end

      CASE g_action_choice
      	 #add by zhangbo130912---begin
      	 WHEN "pg1"
      	    IF cl_chk_act_auth() THEN
               CALL q080_b1()
            END IF

         WHEN "pg2"
      	    IF cl_chk_act_auth() THEN
               CALL q080_b2()
            END IF
         WHEN "pg3"
      	    IF cl_chk_act_auth() THEN
               CALL q080_b3()
            END IF

         WHEN "pg4"
      	    IF cl_chk_act_auth() THEN
               CALL q080_b4()
            END IF
         #add by zhangbo130912---end

         WHEN "query"
            IF cl_chk_act_auth() THEN
            	 CASE g_flag
            	 	  WHEN 'pg1'  	CALL q080_q1()
            	 	  WHEN 'pg2'  	CALL q080_q2()
            	 	  WHEN 'pg3'  	CALL q080_q3()
            	 	  WHEN 'pg4'  	CALL q080_q4()
            	 END CASE
            END IF

         WHEN "xinzeng"
            IF cl_chk_act_auth() THEN
            #	 CALL cl_cmdrun_wait("ghri080")   #mark by zhangbo130912
               CALL q080_gen()                  #add by zhangbo130912
            	 #CALL q080_b_fill()              #mark by zhangbo130912
            END IF


         WHEN "chexiao"
            IF cl_chk_act_auth() THEN
            	 CALL q080_chexiao()
            	 #CALL q080_b_fill()              #mark by zhangbo130912
            END IF

         WHEN "help"
            LET g_action_choice=NULL    #add by zhangbo130912
            CALL cl_show_help()
         WHEN "exit"
            LET g_action_choice=NULL    #add by zhangbo130912
            EXIT WHILE
         WHEN "controlg"
            LET g_action_choice=NULL    #add by zhangbo130912
            CALL cl_cmdask()
         WHEN "exporttoexcel"   #No.FUN-4B0020
            IF cl_chk_act_auth() THEN
               LET g_action_choice=NULL   #add by zhangbo130912
#mark by zhuzw 20150122 start
#               CASE g_flag
#               	  WHEN 'pg1'
#                     CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrdm1),'','')
#                  WHEN 'pg2'
#              	     CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrdm2),'','')
#              	  WHEN 'pg3'
#              	     CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrdm3),'','')
#              	  WHEN 'pg4'
#              	     CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrdm4),'','')
#               END CASE
#mark by zhuzw 20150122 end
#add by zhuzw 20150122 start
               LET w = ui.Window.getCurrent()
               LET f = w.getForm()
               CASE g_flag
               	  WHEN 'pg1'
                     LET page = f.FindNode("Page","page1")
                     CALL cl_export_to_excel(page,base.TypeInfo.create(g_hrdm1),'','')
                  WHEN 'pg2'
                     LET page = f.FindNode("Page","page2")
              	     CALL cl_export_to_excel(page,base.TypeInfo.create(g_hrdm2),'','')
              	  WHEN 'pg3'
              	     LET page = f.FindNode("Page","page3")
              	     CALL cl_export_to_excel(page,base.TypeInfo.create(g_hrdm3),'','')
              	  WHEN 'pg4'
              	     LET page = f.FindNode("Page","page4")
              	     CALL cl_export_to_excel(page,base.TypeInfo.create(g_hrdm4),'','')
               END CASE
#add by zhuzw 20150122 end
            END IF




      END CASE
   END WHILE

END FUNCTION

FUNCTION q080_q1()
   #CALL q080_b_fill()       #mark by zhangbo130911
   LET g_action_choice=NULL  #add by zhangbo130912
   CALL q080_b1_askkey()     #add by zhangbo130911
END FUNCTION

#add by zhangbo130911---begin
FUNCTION q080_b1_askkey()
    CLEAR FORM
    CALL g_hrdm1.clear()
    LET g_rec_b1=0
    CONSTRUCT g_wc1 ON hrat03,hrat01,hrat02
         FROM s_hrdm1[1].hrat03_1,s_hrdm1[1].hrdm02_1,s_hrdm1[1].hrat02_1

    BEFORE CONSTRUCT
         CALL cl_qbe_init()

      ON ACTION CONTROLP
         CASE
         	  WHEN INFIELD(hrdm02_1)
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_hrat01"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO s_hrdm1[1].hrdm02_1
               NEXT FIELD hrdm02_1
         OTHERWISE
              EXIT CASE
         END CASE


      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT

      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121

      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121

      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121


      #No.FUN-580031 --start--
      ON ACTION qbe_select
         CALL cl_qbe_select()
      ON ACTION qbe_save
         CALL cl_qbe_save()
      #No.FUN-580031 ---end---
    END CONSTRUCT
    LET g_wc1 = g_wc1 CLIPPED,cl_get_extra_cond('hratuser', 'hratgrup')

    IF INT_FLAG THEN
       LET INT_FLAG = 0
       LET g_wc1 = NULL
       RETURN
    END IF
#No.TQC-710076 -- end --

    CALL q080_b_fill()

END FUNCTION
#add by zhangbo130911---end

FUNCTION q080_q2()
   LET g_action_choice=NULL   #add by zhangbo130912
   CALL q080_b2_askkey()
END FUNCTION

FUNCTION q080_b2_askkey()
    CLEAR FORM
    LET g_rec_b2=0
    CALL g_hrdm2.clear()

    CONSTRUCT g_wc2 ON hrdm02,hrdm08,hrdm03,hrdm07,hrdm04,hrdm05,hrdm11
         FROM s_hrdm2[1].hrdm02_2,s_hrdm2[1].hrdm08_2,s_hrdm2[1].hrdm03_2,
              s_hrdm2[1].hrdm07_2,s_hrdm2[1].hrdm04_2,s_hrdm2[1].hrdm05_2,
              s_hrdm2[1].hrdm11_2

      BEFORE CONSTRUCT
         CALL cl_qbe_init()

      ON ACTION CONTROLP
         CASE
         	  WHEN INFIELD(hrdm02_2)
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_hrat01"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO s_hrdm2[1].hrdm02_2
               NEXT FIELD hrdm02_2
            WHEN INFIELD(hrdm03_2)
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_hrdl01"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO s_hrdm2[1].hrdm03_2
               NEXT FIELD hrdm03_2
         OTHERWISE
              EXIT CASE
         END CASE


      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT

      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121

      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121

      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121


      #No.FUN-580031 --start--
      ON ACTION qbe_select
         CALL cl_qbe_select()
      ON ACTION qbe_save
         CALL cl_qbe_save()
      #No.FUN-580031 ---end---
    END CONSTRUCT


    IF INT_FLAG THEN
       LET INT_FLAG = 0
       LET g_wc2 = NULL
       RETURN
    END IF
#No.TQC-710076 -- end --

    CALL cl_replace_str(g_wc2,'hrdm02','hrat01') RETURNING g_wc2

    CALL q080_b_fill()

END FUNCTION

FUNCTION q080_q3()
   LET g_action_choice=NULL   #add by zhangbo130912
   CALL q080_b3_askkey()
END FUNCTION

FUNCTION q080_b3_askkey()
    CLEAR FORM
    LET g_rec_b3=0
    CALL g_hrdm3.clear()

    CONSTRUCT g_wc3 ON hrdm02,hrdm08,hrdm03,hrdm07,hrdm04,hrdm05,hrdm09,hrdm11
         FROM s_hrdm3[1].hrdm02_3,s_hrdm3[1].hrdm08_3,s_hrdm3[1].hrdm03_3,
              s_hrdm3[1].hrdm07_3,s_hrdm3[1].hrdm04_3,s_hrdm3[1].hrdm05_3,
              s_hrdm3[1].hrdm09_3,s_hrdm3[1].hrdm11_3

      BEFORE CONSTRUCT
         CALL cl_qbe_init()

      ON ACTION CONTROLP
         CASE
         	  WHEN INFIELD(hrdm02_3)
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_hrat01"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO s_hrdm3[1].hrdm02_3
               NEXT FIELD hrdm02_3
            WHEN INFIELD(hrdm03_3)
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_hrdl01"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO s_hrdm3[1].hrdm03_3
               NEXT FIELD hrdm03_3
         OTHERWISE
              EXIT CASE
         END CASE


      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT

      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121

      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121

      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121


      #No.FUN-580031 --start--
      ON ACTION qbe_select
         CALL cl_qbe_select()
      ON ACTION qbe_save
         CALL cl_qbe_save()
      #No.FUN-580031 ---end---
    END CONSTRUCT


    IF INT_FLAG THEN
       LET INT_FLAG = 0
       LET g_wc3 = NULL
       RETURN
    END IF
#No.TQC-710076 -- end --

    CALL cl_replace_str(g_wc3,'hrdm02','hrat01') RETURNING g_wc3

    CALL q080_b_fill()

END FUNCTION

FUNCTION q080_q4()
   LET g_action_choice=NULL   #add by zhangbo130912
   CALL q080_b4_askkey()
END FUNCTION

FUNCTION q080_b4_askkey()
    CLEAR FORM
    LET g_rec_b4=0
    CALL g_hrdm4.clear()

    CONSTRUCT g_wc4 ON hrdm02,hrdm08,hrdm03,hrdm07,hrdm04,hrdm05,hrdm09,hrdm11
         FROM s_hrdm4[1].hrdm02_4,s_hrdm4[1].hrdm08_4,s_hrdm4[1].hrdm03_4,
              s_hrdm4[1].hrdm07_4,s_hrdm4[1].hrdm04_4,s_hrdm4[1].hrdm05_4,
              s_hrdm4[1].hrdm09_4,s_hrdm4[1].hrdm11_4

      BEFORE CONSTRUCT
         CALL cl_qbe_init()

      ON ACTION CONTROLP
         CASE
         	  WHEN INFIELD(hrdm02_4)
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_hrat01"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO s_hrdm4[1].hrdm02_4
               NEXT FIELD hrdm02_4
            WHEN INFIELD(hrdm03_4)
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_hrdl01"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO s_hrdm4[1].hrdm03_4
               NEXT FIELD hrdm03_4
         OTHERWISE
              EXIT CASE
         END CASE


      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT

      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121

      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121

      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121


      #No.FUN-580031 --start--
      ON ACTION qbe_select
         CALL cl_qbe_select()
      ON ACTION qbe_save
         CALL cl_qbe_save()
      #No.FUN-580031 ---end---
    END CONSTRUCT


    IF INT_FLAG THEN
       LET INT_FLAG = 0
       LET g_wc4 = NULL
       RETURN
    END IF
#No.TQC-710076 -- end --

    CALL cl_replace_str(g_wc4,'hrdm02','hrat01') RETURNING g_wc4

    CALL q080_b_fill()

END FUNCTION

FUNCTION q080_b_fill()
#add by yinbq 20141126 for 用户不输入条件即不查询数据
#IF g_wc2=" 1=1" THEN LET g_wc2 = " 1=0" END IF
#IF g_wc3=" 1=1" THEN LET g_wc3 = " 1=0" END IF
#IF g_wc4=" 1=1" THEN LET g_wc4 = " 1=0" END IF
#add by yinbq 20141126 for 用户不输入条件即不查询数据

#xie150508 增加薪资组别栏位
IF g_flag = 'pg1' THEN
	  #待设置人员
	  LET g_sql=" SELECT 'N',hrat03,hrat01,hrat02,hrat04,hrat05,hrat25,hrat19,hrat22,hrat42,hraoud04",#mod by zhangbo130911
	            "   FROM hrat_file ",
                    "  left join hrbh_file on hratid=hrbh01 ",
                    "  left join hrad_file on hrad02=hrat19 ",
                    "  left join hrao_file on hrat04=hrao01 ",
	            "  WHERE  (hrad01<>'003' or (hrbh09='N' or hrbh09 is null)) and NOT EXISTS",
	            "  (SELECT 1 FROM hrdm_file,hrct_file ",
	            "    WHERE hrdm12='0'  AND hrdm02=hratid",
                    "      AND ((hrdm05=hrct11 AND hrdm13='N'",                       #mod by zhangbo130912 #mark by zhuzw 20131111
	            "      AND hrct08>='",g_today,"') OR (hrdm13='Y')))",             #mod by zhangbo130912
	            "    AND ",g_wc1 CLIPPED,
	            "    AND hratconf='Y' ",
	            "  ORDER BY hrat03,hrat01"
	  PREPARE q080_pb1 FROM g_sql
    DECLARE hrdm1_curs CURSOR FOR q080_pb1

    CALL g_hrdm1.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH hrdm1_curs INTO g_hrdm1[g_cnt].*
        IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
        END IF

        SELECT hraa12 INTO g_hrdm1[g_cnt].hrat03
          FROM hraa_file
         WHERE hraa01=g_hrdm1[g_cnt].hrat03

        SELECT hrao02 INTO g_hrdm1[g_cnt].hrat04
          FROM hrao_file
         WHERE hrao01=g_hrdm1[g_cnt].hrat04

        SELECT hras04 INTO g_hrdm1[g_cnt].hrat05
          FROM hras_file
         WHERE hras01=g_hrdm1[g_cnt].hrat05

        SELECT hrad03 INTO g_hrdm1[g_cnt].hrat19
          FROM hrad_file
         WHERE hrad02=g_hrdm1[g_cnt].hrat19

        SELECT hrag07 INTO g_hrdm1[g_cnt].hrat22
          FROM hrag_file
         WHERE hrag01='317'
           AND hrag06=g_hrdm1[g_cnt].hrat22

        SELECT hrai04 INTO g_hrdm1[g_cnt].hrat42
          FROM hrai_file
         WHERE hrai03=g_hrdm1[g_cnt].hrat42

         SELECT hrag07 INTO g_hrdm1[g_cnt].hraoud04
         FROM  hrag_file
         WHERE hrag06=g_hrdm1[g_cnt].hraoud04 AND hrag01='658'

        LET g_cnt = g_cnt + 1

        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_hrdm1.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b1 = g_cnt-1
    #DISPLAY g_rec_b1 TO FORMONLY.cn2_1
    LET g_cnt = 0

END IF
IF g_flag = 'pg2' THEN
    #已设置人员
	  LET g_sql=" SELECT 'N',hrdm02,'','','',hrdm08,hrdm03,'','',hrdm07,hrdm04,hrdm05,hrdm11,hrdm01",
      " FROM hrdm_file",
      " LEFT JOIN hrat_file ON hratid=hrdm02",
      " LEFT JOIN hrbh_file ON hrbh01=hratid",
      " LEFT JOIN hrad_file ON hrad02=hrat19",
      " WHERE ((hrad01<> '003') OR (hrbh09='N' or hrbh09 is null)) AND ",
	            g_wc2 CLIPPED,
      " ORDER BY hrdm01 DESC"
	  PREPARE q080_pb2 FROM g_sql
    DECLARE hrdm2_curs CURSOR FOR q080_pb2

    CALL g_hrdm2.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH hrdm2_curs INTO g_hrdm2[g_cnt].*
        IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
        END IF

        SELECT hrat01 INTO g_hrdm2[g_cnt].hrdm02
          FROM hrat_file
         WHERE hratid=g_hrdm2[g_cnt].hrdm02

       SELECT hrat02 INTO g_hrdm2[g_cnt].hrat02
         FROM hrat_file
        WHERE hrat01=g_hrdm2[g_cnt].hrdm02

       SELECT hraa12 INTO g_hrdm2[g_cnt].hrat03
         FROM hrat_file,hraa_file
        WHERE hrat01=g_hrdm2[g_cnt].hrdm02
          AND hrat03=hraa01

       SELECT hrao02 INTO g_hrdm2[g_cnt].hrat04
         FROM hrat_file,hrao_file
        WHERE hrat01=g_hrdm2[g_cnt].hrdm02
          AND hrat04=hrao01

       SELECT hrdl02 INTO g_hrdm2[g_cnt].hrdm03
         FROM hrdl_file
        WHERE hrdl01=g_hrdm2[g_cnt].hrdm03

       SELECT hras04 INTO g_hrdm2[g_cnt].hrat05
         FROM hrat_file,hras_file
        WHERE hrat01=g_hrdm2[g_cnt].hrdm02
          AND hrat05=hras01

       SELECT hrat25 INTO g_hrdm2[g_cnt].hrat25
         FROM hrat_file
        WHERE hrat01=g_hrdm2[g_cnt].hrdm02

        LET g_cnt = g_cnt + 1

        #IF g_cnt > g_max_rec THEN
        #   CALL cl_err( '', 9035, 0 )
        #   EXIT FOREACH
        #END IF
    END FOREACH
    CALL g_hrdm2.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b2 = g_cnt-1
    #DISPLAY g_rec_b2 TO FORMONLY.cn2_2
    LET g_cnt = 0

END IF
IF g_flag = 'pg3' THEN
    #已撤销人员
	  LET g_sql=" SELECT DISTINCT 'N',hrdm02,'','','',hrdm08,hrdm03,'','', ", #mod by zhangbo130911
	            "        hrdm07,hrdm04,hrdm05,hrdm09,hrdm11,hrdm01 ",
	            "   FROM hrdm_file,hrat_file ",
	            "  WHERE hrdm12='1' ",
	            "    AND ",g_wc3 CLIPPED,
                    "    AND hrdm02=hratid ",
	            "  ORDER BY hrdm01,hrdm02"
	  PREPARE q080_pb3 FROM g_sql
    DECLARE hrdm3_curs CURSOR FOR q080_pb3

    CALL g_hrdm3.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH hrdm3_curs INTO g_hrdm3[g_cnt].*
        IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
        END IF

        SELECT hrat01 INTO g_hrdm3[g_cnt].hrdm02
          FROM hrat_file
         WHERE hratid=g_hrdm3[g_cnt].hrdm02

        SELECT hrat02 INTO g_hrdm3[g_cnt].hrat02
          FROM hrat_file
         WHERE hrat01=g_hrdm3[g_cnt].hrdm02

        SELECT hraa12 INTO g_hrdm3[g_cnt].hrat03
          FROM hrat_file,hraa_file
         WHERE hrat01=g_hrdm3[g_cnt].hrdm02
           AND hrat03=hraa01

        SELECT hrao02 INTO g_hrdm3[g_cnt].hrat04
          FROM hrat_file,hrao_file
         WHERE hrat01=g_hrdm3[g_cnt].hrdm02
           AND hrat04=hrao01

        SELECT hrdl02 INTO g_hrdm3[g_cnt].hrdm03
          FROM hrdl_file
         WHERE hrdl01=g_hrdm3[g_cnt].hrdm03

        SELECT hras04 INTO g_hrdm3[g_cnt].hrat05
          FROM hrat_file,hras_file
         WHERE hrat01=g_hrdm3[g_cnt].hrdm02
           AND hrat05=hras01

        SELECT hrat25 INTO g_hrdm3[g_cnt].hrat25
         FROM hrat_file
        WHERE hrat01=g_hrdm3[g_cnt].hrdm02

        LET g_cnt = g_cnt + 1

        #IF g_cnt > g_max_rec THEN
        #   CALL cl_err( '', 9035, 0 )
        #   EXIT FOREACH
        #END IF
    END FOREACH
    CALL g_hrdm3.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b3 = g_cnt-1
    #DISPLAY g_rec_b3 TO FORMONLY.cn2_3
    LET g_cnt = 0

END IF
IF g_flag = 'pg4' THEN
    #所有人员
	  LET g_sql=" SELECT DISTINCT 'N',hrdm02,'','','',hrdm08,hrdm03,'','', ", #mod by zhangbo130911
	            "        hrdm07,hrdm04,hrdm05,hrdm09,hrdm11,hrdm01 ",
	            "   FROM hrdm_file,hrat_file ",
	            "  WHERE ",g_wc4 CLIPPED,
              "    AND hrdm02=hratid ",
	            "  ORDER BY hrdm01,hrdm02"
	  PREPARE q080_pb4 FROM g_sql
    DECLARE hrdm4_curs CURSOR FOR q080_pb4

    CALL g_hrdm4.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH hrdm4_curs INTO g_hrdm4[g_cnt].*
        IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
        END IF

        SELECT hrat01 INTO g_hrdm4[g_cnt].hrdm02
          FROM hrat_file
         WHERE hratid=g_hrdm4[g_cnt].hrdm02

        SELECT hrat02 INTO g_hrdm4[g_cnt].hrat02
          FROM hrat_file
         WHERE hrat01=g_hrdm4[g_cnt].hrdm02

        SELECT hraa12 INTO g_hrdm4[g_cnt].hrat03
          FROM hrat_file,hraa_file
         WHERE hrat01=g_hrdm4[g_cnt].hrdm02
           AND hrat03=hraa01

        SELECT hrao02 INTO g_hrdm4[g_cnt].hrat04
          FROM hrat_file,hrao_file
         WHERE hrat01=g_hrdm4[g_cnt].hrdm02
           AND hrat04=hrao01

        SELECT hrdl02 INTO g_hrdm4[g_cnt].hrdm03
          FROM hrdl_file
         WHERE hrdl01=g_hrdm4[g_cnt].hrdm03

        SELECT hras04 INTO g_hrdm4[g_cnt].hrat05
          FROM hrat_file,hras_file
         WHERE hrat01=g_hrdm4[g_cnt].hrdm02
           AND hrat05=hras01

        SELECT hrat25 INTO g_hrdm4[g_cnt].hrat25
         FROM hrat_file
        WHERE hrat01=g_hrdm4[g_cnt].hrdm02

        LET g_cnt = g_cnt + 1

        #IF g_cnt > g_max_rec THEN
        #   CALL cl_err( '', 9035, 0 )
        #   EXIT FOREACH
        #END IF
    END FOREACH
    CALL g_hrdm4.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b4 = g_cnt-1
    #DISPLAY g_rec_b4 TO FORMONLY.cn2_4
    LET g_cnt = 0
	END IF
END FUNCTION

FUNCTION q080_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1


   IF p_ud <> "G"  THEN
      RETURN
   END IF

   LET g_action_choice = " "
   LET g_row_count = 0               #No.TQC-680158 add
   LET g_curs_index = 0              #No.TQC-680158 add

   CALL cl_set_act_visible("accept,cancel", FALSE)

   DIALOG ATTRIBUTES(UNBUFFERED)

      DISPLAY ARRAY g_hrdm1 TO s_hrdm1.*  ATTRIBUTE(COUNT=g_rec_b1)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         DISPLAY g_rec_b1 TO FORMONLY.cn2

      BEFORE ROW
         LET l_ac1 = ARR_CURR()
         CALL cl_show_fld_cont()
         #DISPLAY g_rec_b1 TO FORMONLY.cn2

      ON ACTION pg2
         LET g_flag = "pg2"
         EXIT DIALOG

      ON ACTION pg3
         LET g_flag = "pg3"
         EXIT DIALOG

      ON ACTION pg4
         LET g_flag = "pg4"
         EXIT DIALOG

      ON ACTION xinzeng
         LET g_action_choice="xinzeng"
         EXIT DIALOG


      END DISPLAY

      DISPLAY ARRAY g_hrdm2 TO s_hrdm2.*  ATTRIBUTE(COUNT=g_rec_b2)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      BEFORE ROW
         LET l_ac2 = ARR_CURR()
         CALL cl_show_fld_cont()

      ON ACTION pg1
         LET g_flag = "pg1"
         EXIT DIALOG

      ON ACTION pg3
         LET g_flag = "pg3"
         EXIT DIALOG

      ON ACTION pg4
         LET g_flag = "pg4"
         EXIT DIALOG

      ON ACTION chexiao
         LET g_action_choice="chexiao"
         EXIT DIALOG


      END DISPLAY

      DISPLAY ARRAY g_hrdm3 TO s_hrdm3.*  ATTRIBUTE(COUNT=g_rec_b3)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      BEFORE ROW
         LET l_ac3 = ARR_CURR()
         CALL cl_show_fld_cont()

      ON ACTION pg1
         LET g_flag = "pg1"
         EXIT DIALOG

      ON ACTION pg2
         LET g_flag = "pg2"
         EXIT DIALOG

      ON ACTION pg4
         LET g_flag = "pg4"
         EXIT DIALOG


      END DISPLAY

      DISPLAY ARRAY g_hrdm4 TO s_hrdm4.*  ATTRIBUTE(COUNT=g_rec_b4)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      BEFORE ROW
         LET l_ac4 = ARR_CURR()
         CALL cl_show_fld_cont()

      ON ACTION pg1
         LET g_flag = "pg1"
         EXIT DIALOG

      ON ACTION pg2
         LET g_flag = "pg2"
         EXIT DIALOG

      ON ACTION pg3
         LET g_flag = "pg3"
         EXIT DIALOG


      END DISPLAY


      #ON ACTION query
      #   LET g_action_choice="query"
      #   EXIT DIALOG

      ON ACTION help
         LET g_action_choice="help"
         CALL cl_show_help()
         EXIT DIALOG

      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()
         EXIT DIALOG

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG

      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DIALOG

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG

      ON ACTION about
         CALL cl_about()

      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG

   END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION q080_bp1(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1


   IF p_ud <> "G"  THEN
      RETURN
   END IF

   LET g_action_choice = " "
   LET g_row_count = 0               #No.TQC-680158 add
   LET g_curs_index = 0              #No.TQC-680158 add

   CALL cl_set_act_visible("accept,cancel", FALSE)

   DIALOG ATTRIBUTES(UNBUFFERED)


      DISPLAY ARRAY g_hrdm1 TO s_hrdm1.*  ATTRIBUTE(COUNT=g_rec_b1)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         DISPLAY g_rec_b1 TO FORMONLY.cn2

      BEFORE ROW
         LET l_ac1 = ARR_CURR()
         CALL cl_show_fld_cont()
         #DISPLAY g_rec_b1 TO FORMONLY.cn2

      ON ACTION pg2
         LET g_flag = "pg2"
         EXIT DIALOG

      ON ACTION pg3
         LET g_flag = "pg3"
         EXIT DIALOG

      ON ACTION pg4
         LET g_flag = "pg4"
         EXIT DIALOG

      END DISPLAY


      #ON ACTION query
      #   LET g_action_choice="query"
      #   EXIT DIALOG

      ON ACTION xinzeng
         LET g_action_choice="xinzeng"
         EXIT DIALOG

      ON ACTION help
         LET g_action_choice="help"
         CALL cl_show_help()
         EXIT DIALOG

      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()
         EXIT DIALOG

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG

      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DIALOG

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG

      ON ACTION about
         CALL cl_about()

      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG

   END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION q080_bp2(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1


   IF p_ud <> "G"  THEN
      RETURN
   END IF

   LET g_action_choice = " "
   LET g_row_count = 0               #No.TQC-680158 add
   LET g_curs_index = 0              #No.TQC-680158 add

   CALL cl_set_act_visible("accept,cancel", FALSE)

   DIALOG ATTRIBUTES(UNBUFFERED)


      DISPLAY ARRAY g_hrdm2 TO s_hrdm2.*  ATTRIBUTE(COUNT=g_rec_b2)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         DISPLAY g_rec_b2 TO FORMONLY.cn2

      BEFORE ROW
         LET l_ac2 = ARR_CURR()
         CALL cl_show_fld_cont()
         #DISPLAY g_rec_b2 TO FORMONLY.cn2

      ON ACTION chexiao
         LET g_action_choice="chexiao"
         EXIT DIALOG

      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG

      ON ACTION pg1
         LET g_flag = "pg1"
         EXIT DIALOG

      ON ACTION pg3
         LET g_flag = "pg3"
         EXIT DIALOG

      ON ACTION pg4
         LET g_flag = "pg4"
         EXIT DIALOG


      END DISPLAY


      #ON ACTION query
      #   LET g_action_choice="query"
      #   EXIT DIALOG

      ON ACTION help
         LET g_action_choice="help"
         CALL cl_show_help()
         EXIT DIALOG

      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()
         EXIT DIALOG

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG

      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DIALOG

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG

      ON ACTION about
         CALL cl_about()

      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG

   END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION q080_bp3(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1


   IF p_ud <> "G"  THEN
      RETURN
   END IF

   LET g_action_choice = " "
   LET g_row_count = 0               #No.TQC-680158 add
   LET g_curs_index = 0              #No.TQC-680158 add

   CALL cl_set_act_visible("accept,cancel", FALSE)

   DIALOG ATTRIBUTES(UNBUFFERED)


      DISPLAY ARRAY g_hrdm3 TO s_hrdm3.*  ATTRIBUTE(COUNT=g_rec_b3)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         DISPLAY g_rec_b3 TO FORMONLY.cn2

      BEFORE ROW
         LET l_ac3 = ARR_CURR()
         CALL cl_show_fld_cont()
         #DISPLAY g_rec_b3 TO FORMONLY.cn2

      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG

      ON ACTION pg2
         LET g_flag = "pg2"
         EXIT DIALOG

      ON ACTION pg1
         LET g_flag = "pg1"
         EXIT DIALOG

      ON ACTION pg4
         LET g_flag = "pg4"
         EXIT DIALOG

      END DISPLAY


      #ON ACTION query
      #   LET g_action_choice="query"
      #   EXIT DIALOG

      ON ACTION help
         LET g_action_choice="help"
         CALL cl_show_help()
         EXIT DIALOG

      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()
         EXIT DIALOG

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG

      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DIALOG

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG

      ON ACTION about
         CALL cl_about()

      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG

   END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION q080_bp4(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1


   IF p_ud <> "G"  THEN
      RETURN
   END IF

   LET g_action_choice = " "
   LET g_row_count = 0               #No.TQC-680158 add
   LET g_curs_index = 0              #No.TQC-680158 add

   CALL cl_set_act_visible("accept,cancel", FALSE)

   DIALOG ATTRIBUTES(UNBUFFERED)


      DISPLAY ARRAY g_hrdm4 TO s_hrdm4.*  ATTRIBUTE(COUNT=g_rec_b4)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         DISPLAY g_rec_b4 TO FORMONLY.cn2

      BEFORE ROW
         LET l_ac4 = ARR_CURR()
         CALL cl_show_fld_cont()
         #DISPLAY g_rec_b4 TO FORMONLY.cn2

      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG

      ON ACTION pg2
         LET g_flag = "pg2"
         EXIT DIALOG

      ON ACTION pg3
         LET g_flag = "pg3"
         EXIT DIALOG

      ON ACTION pg1
         LET g_flag = "pg1"
         EXIT DIALOG

      END DISPLAY


      #ON ACTION query
      #   LET g_action_choice="query"
      #   EXIT DIALOG

      ON ACTION help
         LET g_action_choice="help"
         CALL cl_show_help()
         EXIT DIALOG

      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()
         EXIT DIALOG

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG

      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DIALOG

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG

      ON ACTION about
         CALL cl_about()

      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG

   END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION q080_chexiao()
DEFINE p_row,p_col  LIKE type_file.num5
DEFINE l_hrdm09     LIKE hrdm_file.hrdm09
DEFINE l_hrdm11     LIKE hrdm_file.hrdm11
DEFINE l_n          LIKE type_file.num5
DEFINE l_date       LIKE hrct_file.hrct08
DEFINE l_date_b     LIKE hrct_file.hrct08
DEFINE l_date_c     LIKE hrct_file.hrct07
DEFINE l_hrdm       RECORD LIKE hrdm_file.*
DEFINE li_hrdm       RECORD LIKE hrdm_file.*
DEFINE l_year       STRING
DEFINE l_month      STRING
DEFINE l_day        STRING
DEFINE l_no         LIKE type_file.chr10
DEFINE l_sql        STRING
DEFINE l_hrdm01     LIKE  hrdm_file.hrdm01
DEFINE l_hrat03     LIKE  hrat_file.hrat03      #add by zhangbo130705
DEFINE l_i          LIKE  type_file.num5        #add by zhangbo130912
DEFINE l_hrat03_1   LIKE  hrat_file.hrat03      #add by zhangbo130912
DEFINE l_check      LIKE  type_file.chr1        #add by zhangbo130912
#add by zhangbo130912---begin
DEFINE   li_k                    LIKE type_file.num5
DEFINE   li_i_r                  LIKE type_file.num5
DEFINE   lr_err    DYNAMIC ARRAY OF RECORD
            line    STRING,
            key1    STRING,
            err     STRING
                   END RECORD
#add by zhangbo130912---end

	 #mark by zhangbo130911---begin
	 #IF g_hrdm2[l_ac2].hrdm01 IS NULL THEN
	 #	  CALL cl_err("无此笔已设置资料","!",1)
	 #	  RETURN
	 #END IF
	 #
	 #
	 #SELECT * INTO l_hrdm.* FROM hrdm_file WHERE hrdm01=g_hrdm2[l_ac2].hrdm01
	 #
	 #IF l_hrdm.hrdm12 != '0' THEN
	 #	  CALL cl_err('此笔资料不是已设置状态','!',0)
	 #	  RETURN
	 #END IF
	 #mark by zhangbo130911---end

	 #add by zhangbo130911---begin
	 LET g_action_choice=NULL
   #如果未选取任何资料则退出此函数
   IF g_rec_cx = 0 THEN
      CALL cl_err('','-400',1)
      RETURN
   END IF

   #选取的员工公司必须一致
   FOR l_i=1 TO g_rec_cx
      LET l_check='N'
      IF l_i=1 THEN
      	 SELECT hrat03 INTO l_hrat03_1 FROM hrdm_file,hrat_file
      	  WHERE hratid=hrdm02
      	    AND hrdm01=g_cx[l_i].hrdm01
      ELSE
      	 SELECT hrat03 INTO l_hrat03 FROM hrdm_file,hrat_file
      	  WHERE hratid=hrdm02
      	    AND hrdm01=g_cx[l_i].hrdm01
      	 IF l_hrat03 != l_hrat03_1 THEN
      	 	  LET l_check='Y'
      	 	  EXIT FOR
      	 END IF
      END IF
   END FOR
   IF l_check='Y' THEN
   	  CALL cl_err('选取的员工公司必须一致','!',1)
   	  RETURN
   END IF
   #add by zhangbo130911---end

	 LET p_row=3   LET p_col=6

   OPEN WINDOW q080_c_w AT p_row,p_col WITH FORM "ghr/42f/ghrq080_c"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_locale("ghrq080_c")

   INPUT l_hrdm09,l_hrdm11 WITHOUT DEFAULTS FROM hrdm09,hrdm11

   AFTER FIELD hrdm09
      IF NOT cl_null(l_hrdm09) THEN
      	 LET l_n=0
         #SELECT hrat03 INTO l_hrat03 FROM hrat_file WHERE hratid=l_hrdm.hrdm02       #add by zhangbo130705
      	 SELECT COUNT(*) INTO l_n FROM hrct_file WHERE hrct11=l_hrdm09
                                                   #AND hrct03=l_hrat03               #add by zhangbo130705
      	 IF l_n=0 THEN
      	 	  CALL cl_err('无此薪资月','!',0)
      	 	  NEXT FIELD hrdm09
      	 END IF


      	 LET l_date=''
      	 SELECT hrct08 INTO l_date FROM hrct_file WHERE hrct11=l_hrdm09
      	 #IF l_date<g_today THEN
      	 #	  CALL cl_err('撤销薪资月结束日期不可比当前日期小','!',0)
      	 #	  NEXT FIELD hrdm09
      	 #END IF

      	 #mark by zhangbo130912---begin
      	 ##SELECT hrct08 INTO l_date_b FROM hrct_file      #mark by zhangbo130705
         #SELECT hrct07 INTO l_date_b FROM hrct_file      #add by zhangbo130705
      	 #WHERE hrct11=hrdm04                  #开始薪资月结束日期
      	 #   AND hrdm01=l_hrdm.hrdm01
      	 #SELECT hrct07 INTO l_date_c FROM hrct_file
      	 # WHERE hrct11=l_hrdm09                #撤销薪资月开始日期
      	 #IF l_date_c<l_date_b THEN             #mod by zhangbo130705
      	 #	  CALL cl_err('撤销薪资月的开始日期不能小于或等于原开始薪资月的开始日期','!',0)
      	 #	  NEXT FIELD hrdm09
      	 #END IF
         #mark by zhangbo130912---end

      END IF

      ON ACTION controlp
           IF INFIELD(hrdm09) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrct11"
              LET g_qryparam.default1 = l_hrdm09
              CALL cl_create_qry() RETURNING l_hrdm09
              DISPLAY l_hrdm09 TO hrdm09
           END IF

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

      ON ACTION about
         CALL cl_about()

      ON ACTION help
         CALL cl_show_help()

      ON ACTION controlg
         CALL cl_cmdask()
    END INPUT

    IF INT_FLAG THEN
    	 CLOSE WINDOW q080_c_w
       LET INT_FLAG = 0
       RETURN
    END IF

    CLOSE WINDOW q080_c_w

    LET li_k=0               #add by zhangbo130912

    FOR l_i=1 TO g_rec_cx    #add by zhangbo130912---begin

       BEGIN WORK

       LET g_success='Y'

       #add by zhangbo130912---begin
       SELECT * INTO l_hrdm.* FROM hrdm_file WHERE hrdm01=g_cx[l_i].hrdm01
       SELECT hrct07 INTO l_date_b FROM hrct_file      #add by zhangbo130705
      	WHERE hrct11=hrdm04                  #开始薪资月结束日期
         AND hrdm01=l_hrdm.hrdm01
       SELECT hrct07 INTO l_date_c FROM hrct_file
      	WHERE hrct11=l_hrdm09                #撤销薪资月开始日期
       IF l_date_c<l_date_b THEN             #mod by zhangbo130705
       	  LET lr_err[li_k].line=li_k
       	  LET lr_err[li_k].key1=l_hrdm.hrdm01
          LET lr_err[li_k].err="撤销薪资月的开始日期不能小于或等于原开始薪资月的开始日期"
          LET li_k=li_k+1
       	  ROLLBACK WORK
          CONTINUE FOR
       END IF
       #add by zhangbo130912---end

       LET li_hrdm.*=l_hrdm.*

       LET l_year=YEAR(g_today) USING "&&&&"
       LET l_month=MONTH(g_today) USING "&&"
       LET l_day=DAY(g_today) USING "&&"
       LET l_year=l_year.trim()
       LET l_month=l_month.trim()
       LET l_day=l_day.trim()
       LET li_hrdm.hrdm01=l_year CLIPPED,l_month CLIPPED,l_day CLIPPED
       LET l_hrdm01=li_hrdm.hrdm01,"%"
       LET l_sql="SELECT MAX(hrdm01) FROM hrdm_file",
                 " WHERE hrdm01 LIKE '",l_hrdm01,"'"
       PREPARE q080_hrdm01 FROM l_sql
       EXECUTE q080_hrdm01 INTO li_hrdm.hrdm01
       IF cl_null(li_hrdm.hrdm01) THEN
          LET li_hrdm.hrdm01=l_hrdm01[1,8],'0001'
       ELSE
          LET l_no=li_hrdm.hrdm01[9,12]
          LET l_no=l_no+1 USING "&&&&"
          LET li_hrdm.hrdm01=l_hrdm01[1,8],l_no
       END IF

       LET li_hrdm.hrdm05=l_hrdm09
       LET li_hrdm.hrdm11=l_hrdm11

       INSERT INTO hrdm_file VALUES (li_hrdm.*)
       UPDATE hrat_file SET hrat71 = li_hrdm.hrdm03 WHERE hratid = li_hrdm.hrdm02

       IF SQLCA.sqlcode THEN
       	 LET g_success='N'
       	 #CALL cl_err('生成新单据失败','!',0)    #mark by zhangbo130912
       	 #add by zhangbo130912---begin
       	 LET lr_err[li_k].line=li_k
       	 LET lr_err[li_k].key1=l_hrdm.hrdm01
         LET lr_err[li_k].err="生成新单据失败"
         LET li_k=li_k+1
         #add by zhangbo130912---end
       END IF

       IF g_success='Y' THEN
       	 UPDATE hrdm_file SET hrdm12='1',
       	                      hrdm09=l_hrdm09,
       	                      hrdm10=li_hrdm.hrdm01
       	                WHERE hrdm01=l_hrdm.hrdm01
       	 IF SQLCA.sqlcode THEN
       	 	  LET g_success='N'
       	 	  #CALL cl_err('更新原单据失败','!',0)    #mark by zhangbo130912
       	 	  #add by zhangbo130912---begin
       	    LET lr_err[li_k].line=li_k
       	    LET lr_err[li_k].key1=l_hrdm.hrdm01
            LET lr_err[li_k].err="更新原单据失败"
            LET li_k=li_k+1
            #add by zhangbo130912---end
       	 END IF

       END IF


       IF g_success='Y' THEN
    	    COMMIT WORK
       ELSE
    	    ROLLBACK WORK
       END IF

    END FOR

    IF lr_err.getLength() > 0 THEN
    	 CALL cl_show_array(base.TypeInfo.create(lr_err),cl_getmsg("lib-314",g_lang),"序号|流水号|错误描述")
    END IF

    CALL q080_b_fill()   #add by zhangbo130912

END FUNCTION

#add by zhangbo130911---begin
FUNCTION q080_b1()
DEFINE
    l_ac_t          LIKE type_file.num5,
    l_n             LIKE type_file.num5,
    l_i             LIKE type_file.num5,
    l_lock_sw       LIKE type_file.chr1,
    p_cmd           LIKE type_file.chr1,
    l_allow_insert  LIKE type_file.chr1,
    l_allow_delete  LIKE type_file.chr1
DEFINE l_j          LIKE type_file.num5
DEFINE l_check      LIKE type_file.chr1


    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
    LET g_action_choice = ""

    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')

    CALL cl_set_act_visible("accept,cancel", FALSE)

    INPUT ARRAY g_hrdm1 WITHOUT DEFAULTS FROM s_hrdm1.*
          ATTRIBUTE (COUNT=g_rec_b1,MAXCOUNT=g_rec_b1,UNBUFFERED,
                     INSERT ROW = FALSE,DELETE ROW=FALSE,APPEND ROW=TRUE)

    BEFORE INPUT
       IF g_rec_b1 != 0 THEN
          CALL fgl_set_arr_curr(l_ac1)
       END IF
       DISPLAY g_rec_b1 TO FORMONLY.cn2

    BEFORE ROW
        LET p_cmd=''
        LET l_ac1 = ARR_CURR()
        LET l_lock_sw = 'N'            #DEFAULT
        LET l_n  = ARR_COUNT()


    #ON CHANGE sel
        #LET g_sel_b = 0
        #CALL g_hray_t.clear()
        #CALL g_hray01_t.clear()
        #FOR l_i = 1 TO g_rec_b1
        #  IF g_hray[l_i].sel = 'Y' THEN
        #    LET g_sel_b = g_sel_b + 1
        #    LET g_hray_t[g_sel_b].*=g_hray[l_i].*
        #    LET g_hray01_t[g_sel_b]=g_hray01[l_i]
        #  END IF
        #END FOR
        #DISPLAY g_sel_b TO FORMONLY.cnt2

     ON ACTION xinzeng
        LET g_action_choice="xinzeng"
        LET g_rec_sel=0
        CALL g_sel.clear()

        FOR l_i=1 TO g_rec_b1
           IF g_hrdm1[l_i].sel='Y' THEN
                  LET l_check='N'
           	  IF g_rec_sel>0 THEN
           	     FOR l_j=1 TO g_rec_sel
           	        IF g_sel[l_j].hrdm02=g_hrdm1[l_i].hrdm02 THEN
           	        	 LET l_check='Y'
           	        	 EXIT FOR
           	        END IF
           	     END FOR
           	  END IF
           	  IF l_check='N' THEN
           	     LET g_rec_sel=g_rec_sel+1
           	     LET g_sel[g_rec_sel].hrdm02=g_hrdm1[l_i].hrdm02
           	  END IF
           END IF
        END FOR
        EXIT INPUT
     #全选
     ON ACTION sel_all
           FOR l_i = 1 TO g_rec_b1
              LET g_hrdm1[l_i].sel = 'Y'
           END FOR
     #全不选
     ON ACTION sel_no
           FOR l_i = 1 TO g_rec_b1
              LET g_hrdm1[l_i].sel = 'N'
           END FOR           

     ON ACTION pg2
        LET g_flag="pg2"
        LET g_action_choice="pg2"
        EXIT INPUT

     ON ACTION pg3
        LET g_flag="pg3"
        LET g_action_choice="pg3"
        EXIT INPUT

     ON ACTION pg4
        LET g_flag="pg4"
        LET g_action_choice="pg4"
        EXIT INPUT

     ON ACTION query
         LET g_action_choice="query"
         EXIT INPUT



     ON ACTION help
         LET g_action_choice="help"
         EXIT INPUT

     ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf

     ON ACTION exit
         LET g_action_choice="exit"
         EXIT INPUT

     ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT INPUT


     ON ACTION cancel
         LET INT_FLAG=TRUE  		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT INPUT

     ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

     ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121


     ON ACTION exporttoexcel   #No.FUN-4B0020
         LET g_action_choice = 'exporttoexcel'
         EXIT INPUT

    END INPUT
    CALL cl_set_act_visible("accept,cancel", TRUE)

END FUNCTION
#add by zhangbo130911---end

#add by zhangbo130911---begin
FUNCTION q080_b2()
DEFINE
    l_ac_t          LIKE type_file.num5,
    l_n             LIKE type_file.num5,
    l_i             LIKE type_file.num5,
    l_lock_sw       LIKE type_file.chr1,
    p_cmd           LIKE type_file.chr1,
    l_allow_insert  LIKE type_file.chr1,
    l_allow_delete  LIKE type_file.chr1
DEFINE l_j          LIKE type_file.num5
DEFINE l_check      LIKE type_file.chr1


    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
    LET g_action_choice = ""

    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')

    CALL cl_set_act_visible("accept,cancel", FALSE)

    INPUT ARRAY g_hrdm2 WITHOUT DEFAULTS FROM s_hrdm2.*
          ATTRIBUTE (COUNT=g_rec_b2,MAXCOUNT=g_rec_b2,UNBUFFERED,
                     INSERT ROW = FALSE,DELETE ROW=FALSE,APPEND ROW=TRUE)

    BEFORE INPUT
       IF g_rec_b2 != 0 THEN
          CALL fgl_set_arr_curr(l_ac2)
       END IF
       DISPLAY g_rec_b2 TO FORMONLY.cn2

    BEFORE ROW
        LET p_cmd=''
        LET l_ac2 = ARR_CURR()
        LET l_lock_sw = 'N'            #DEFAULT
        LET l_n  = ARR_COUNT()


    #ON CHANGE sel
        #LET g_sel_b = 0
        #CALL g_hray_t.clear()
        #CALL g_hray01_t.clear()
        #FOR l_i = 1 TO g_rec_b1
        #  IF g_hray[l_i].sel = 'Y' THEN
        #    LET g_sel_b = g_sel_b + 1
        #    LET g_hray_t[g_sel_b].*=g_hray[l_i].*
        #    LET g_hray01_t[g_sel_b]=g_hray01[l_i]
        #  END IF
        #END FOR
        #DISPLAY g_sel_b TO FORMONLY.cnt2

     ON ACTION xinzeng
        LET g_action_choice="xinzeng"
        LET g_rec_sel=0
        CALL g_sel.clear()
        FOR l_i=1 TO g_rec_b2
           IF g_hrdm2[l_i].sel='Y' THEN
                  LET l_check='N'
           	  IF g_rec_sel>0 THEN
           	     FOR l_j=1 TO g_rec_sel
           	        IF g_sel[l_j].hrdm02=g_hrdm2[l_i].hrdm02 THEN
           	        	 LET l_check='Y'
           	        	 EXIT FOR
           	        END IF
           	     END FOR
           	  END IF
           	  IF l_check='N' THEN
           	     LET g_rec_sel=g_rec_sel+1
           	     LET g_sel[g_rec_sel].hrdm02=g_hrdm2[l_i].hrdm02
           	  END IF
           END IF
        END FOR
        EXIT INPUT

     ON ACTION chexiao
        LET g_action_choice="chexiao"
        LET g_rec_cx = 0
        CALL g_cx.clear()
        FOR l_i = 1 TO g_rec_b2
          IF g_hrdm2[l_i].sel = 'Y' THEN
             LET g_rec_cx = g_rec_cx + 1
             LET g_cx[g_rec_cx].hrdm01=g_hrdm2[l_i].hrdm01
          END IF
        END FOR
        EXIT INPUT
     #全选
     ON ACTION sel_all
           FOR l_i = 1 TO g_rec_b2
              LET g_hrdm2[l_i].sel = 'Y'
           END FOR
     #全不选
     ON ACTION sel_no
           FOR l_i = 1 TO g_rec_b2
              LET g_hrdm2[l_i].sel = 'N'
           END FOR           

     ON ACTION pg1
        LET g_flag="pg1"
        LET g_action_choice="pg1"
        EXIT INPUT

     ON ACTION pg3
        LET g_flag="pg3"
        LET g_action_choice="pg3"
        EXIT INPUT

     ON ACTION pg4
        LET g_flag="pg4"
        LET g_action_choice="pg4"
        EXIT INPUT

     ON ACTION query
         LET g_action_choice="query"
         EXIT INPUT

     ON ACTION help
         LET g_action_choice="help"
         EXIT INPUT

     ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf

     ON ACTION exit
         LET g_action_choice="exit"
         EXIT INPUT

     ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT INPUT


     ON ACTION cancel
         LET INT_FLAG=TRUE  		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT INPUT

     ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

     ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121


     ON ACTION exporttoexcel   #No.FUN-4B0020
         LET g_action_choice = 'exporttoexcel'
         EXIT INPUT

    END INPUT
    CALL cl_set_act_visible("accept,cancel", TRUE)

END FUNCTION
#add by zhangbo130911---end

#add by zhangbo130911---begin
FUNCTION q080_b3()
DEFINE
    l_ac_t          LIKE type_file.num5,
    l_n             LIKE type_file.num5,
    l_i             LIKE type_file.num5,
    l_lock_sw       LIKE type_file.chr1,
    p_cmd           LIKE type_file.chr1,
    l_allow_insert  LIKE type_file.chr1,
    l_allow_delete  LIKE type_file.chr1
DEFINE l_j          LIKE type_file.num5
DEFINE l_check      LIKE type_file.chr1


    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
    LET g_action_choice = ""

    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')

    CALL cl_set_act_visible("accept,cancel", FALSE)

    INPUT ARRAY g_hrdm3 WITHOUT DEFAULTS FROM s_hrdm3.*
          ATTRIBUTE (COUNT=g_rec_b3,MAXCOUNT=g_rec_b3,UNBUFFERED,
                     INSERT ROW = FALSE,DELETE ROW=FALSE,APPEND ROW=TRUE)

    BEFORE INPUT
       IF g_rec_b3 != 0 THEN
          CALL fgl_set_arr_curr(l_ac3)
       END IF
       DISPLAY g_rec_b3 TO FORMONLY.cn2

    BEFORE ROW
        LET p_cmd=''
        LET l_ac3 = ARR_CURR()
        LET l_lock_sw = 'N'            #DEFAULT
        LET l_n  = ARR_COUNT()


    #ON CHANGE sel
        #LET g_sel_b = 0
        #CALL g_hray_t.clear()
        #CALL g_hray01_t.clear()
        #FOR l_i = 1 TO g_rec_b1
        #  IF g_hray[l_i].sel = 'Y' THEN
        #    LET g_sel_b = g_sel_b + 1
        #    LET g_hray_t[g_sel_b].*=g_hray[l_i].*
        #    LET g_hray01_t[g_sel_b]=g_hray01[l_i]
        #  END IF
        #END FOR
        #DISPLAY g_sel_b TO FORMONLY.cnt2

     ON ACTION xinzeng
        LET g_action_choice="xinzeng"
        LET g_rec_sel=0
        CALL g_sel.clear()
        FOR l_i=1 TO g_rec_b3
           IF g_hrdm3[l_i].sel='Y' THEN
                  LET l_check='N'
           	  IF g_rec_sel>0 THEN
           	     FOR l_j=1 TO g_rec_sel
           	        IF g_sel[l_j].hrdm02=g_hrdm3[l_i].hrdm02 THEN
           	        	 LET l_check='Y'
           	        	 EXIT FOR
           	        END IF
           	     END FOR
           	  END IF
           	  IF l_check='N' THEN
           	     LET g_rec_sel=g_rec_sel+1
           	     LET g_sel[g_rec_sel].hrdm02=g_hrdm3[l_i].hrdm02
           	  END IF
           END IF
        END FOR
        EXIT INPUT
        
     #全选
     ON ACTION sel_all
           FOR l_i = 1 TO g_rec_b3
              LET g_hrdm3[l_i].sel = 'Y'
           END FOR
     #全不选
     ON ACTION sel_no
           FOR l_i = 1 TO g_rec_b3
              LET g_hrdm3[l_i].sel = 'N'
           END FOR           

     ON ACTION pg1
        LET g_flag="pg1"
        LET g_action_choice="pg1"
        EXIT INPUT

     ON ACTION pg2
        LET g_flag="pg2"
        LET g_action_choice="pg2"
        EXIT INPUT

     ON ACTION pg4
        LET g_flag="pg4"
        LET g_action_choice="pg4"
        EXIT INPUT

     ON ACTION query
         LET g_action_choice="query"
         EXIT INPUT

     ON ACTION help
         LET g_action_choice="help"
         EXIT INPUT

     ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf

     ON ACTION exit
         LET g_action_choice="exit"
         EXIT INPUT

     ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT INPUT


     ON ACTION cancel
         LET INT_FLAG=TRUE  		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT INPUT

     ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

     ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121


     ON ACTION exporttoexcel   #No.FUN-4B0020
         LET g_action_choice = 'exporttoexcel'
         EXIT INPUT

    END INPUT
    CALL cl_set_act_visible("accept,cancel", TRUE)

END FUNCTION
#add by zhangbo130911---end

#add by zhangbo130911---begin
FUNCTION q080_b4()
DEFINE
    l_ac_t          LIKE type_file.num5,
    l_n             LIKE type_file.num5,
    l_i             LIKE type_file.num5,
    l_lock_sw       LIKE type_file.chr1,
    p_cmd           LIKE type_file.chr1,
    l_allow_insert  LIKE type_file.chr1,
    l_allow_delete  LIKE type_file.chr1
DEFINE l_j          LIKE type_file.num5
DEFINE l_check      LIKE type_file.chr1


    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
    LET g_action_choice = ""

    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')

    CALL cl_set_act_visible("accept,cancel", FALSE)

    INPUT ARRAY g_hrdm4 WITHOUT DEFAULTS FROM s_hrdm4.*
          ATTRIBUTE (COUNT=g_rec_b4,MAXCOUNT=g_rec_b4,UNBUFFERED,
                     INSERT ROW = FALSE,DELETE ROW=FALSE,APPEND ROW=TRUE)

    BEFORE INPUT
       IF g_rec_b4 != 0 THEN
          CALL fgl_set_arr_curr(l_ac4)
       END IF
       DISPLAY g_rec_b4 TO FORMONLY.cn2

    BEFORE ROW
        LET p_cmd=''
        LET l_ac4 = ARR_CURR()
        LET l_lock_sw = 'N'            #DEFAULT
        LET l_n  = ARR_COUNT()


    #ON CHANGE sel
        #LET g_sel_b = 0
        #CALL g_hray_t.clear()
        #CALL g_hray01_t.clear()
        #FOR l_i = 1 TO g_rec_b1
        #  IF g_hray[l_i].sel = 'Y' THEN
        #    LET g_sel_b = g_sel_b + 1
        #    LET g_hray_t[g_sel_b].*=g_hray[l_i].*
        #    LET g_hray01_t[g_sel_b]=g_hray01[l_i]
        #  END IF
        #END FOR
        #DISPLAY g_sel_b TO FORMONLY.cnt2

     ON ACTION xinzeng
        LET g_action_choice="xinzeng"
        LET g_rec_sel=0
        CALL g_sel.clear()
        FOR l_i=1 TO g_rec_b4
           IF g_hrdm4[l_i].sel='Y' THEN
                  LET l_check='N'
           	  IF g_rec_sel>0 THEN
           	     FOR l_j=1 TO g_rec_sel
           	        IF g_sel[l_j].hrdm02=g_hrdm4[l_i].hrdm02 THEN
           	        	 LET l_check='Y'
           	        	 EXIT FOR
           	        END IF
           	     END FOR
           	  END IF
           	  IF l_check='N' THEN
           	     LET g_rec_sel=g_rec_sel+1
           	     LET g_sel[g_rec_sel].hrdm02=g_hrdm4[l_i].hrdm02
           	  END IF
           END IF
        END FOR
        EXIT INPUT
     #全选
     ON ACTION sel_all
           FOR l_i = 1 TO g_rec_b4
              LET g_hrdm4[l_i].sel = 'Y'
           END FOR
     #全不选
     ON ACTION sel_no
           FOR l_i = 1 TO g_rec_b4
              LET g_hrdm4[l_i].sel = 'N'
           END FOR           

     ON ACTION pg1
        LET g_flag="pg1"
        LET g_action_choice="pg1"
        EXIT INPUT

     ON ACTION pg2
        LET g_flag="pg2"
        LET g_action_choice="pg2"
        EXIT INPUT

     ON ACTION pg3
        LET g_flag="pg3"
        LET g_action_choice="pg3"
        EXIT INPUT

     ON ACTION query
         LET g_action_choice="query"
         EXIT INPUT

     ON ACTION help
         LET g_action_choice="help"
         EXIT INPUT

     ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf

     ON ACTION exit
         LET g_action_choice="exit"
         EXIT INPUT

     ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT INPUT


     ON ACTION cancel
         LET INT_FLAG=TRUE  		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT INPUT

     ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

     ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121


     ON ACTION exporttoexcel   #No.FUN-4B0020
         LET g_action_choice = 'exporttoexcel'
         EXIT INPUT

    END INPUT
    CALL cl_set_act_visible("accept,cancel", TRUE)

END FUNCTION
#add by zhangbo130911---end

#add by zhangbo130912---begin
FUNCTION q080_gen()
DEFINE p_row,p_col  LIKE type_file.num5
DEFINE l_hrdm   RECORD LIKE  hrdm_file.*
DEFINE l_hrat03     LIKE  hrat_file.hrat03
DEFINE l_i          LIKE  type_file.num5
DEFINE l_hrat03_1   LIKE  hrat_file.hrat03
DEFINE l_check      LIKE  type_file.chr1
DEFINE l_n           LIKE type_file.num5
DEFINE l_sql         STRING
DEFINE   li_k                    LIKE type_file.num5
DEFINE   li_i_r                  LIKE type_file.num5
DEFINE   lr_err    DYNAMIC ARRAY OF RECORD
            line    STRING,
            key1    STRING,
            err     STRING
                   END RECORD
DEFINE l_hrdl02    LIKE   hrdl_file.hrdl02
DEFINE l_hrct07_b,l_hrct07_e    LIKE hrct_file.hrct07
DEFINE l_hrct08_e,l_hrct08_b    LIKE hrct_file.hrct08
DEFINE l_str      STRING
DEFINE tok base.StringTokenizer
DEFINE l_value    LIKE   hrat_file.hrat01
DEFINE l_year       STRING
DEFINE l_month      STRING
DEFINE l_day        STRING
DEFINE l_no         LIKE type_file.chr10
DEFINE l_hrdm01     LIKE  hrdm_file.hrdm01
DEFINE l_n1,l_n2    LIKE  type_file.num5

       LET g_action_choice=NULL
       #如果未选取任何资料则退出此函数
       IF g_rec_sel = 0 THEN
          CALL cl_err('','-400',1)
          RETURN
       END IF

       #选取的员工公司必须一致
       FOR l_i=1 TO g_rec_sel
          LET l_check='N'
          IF l_i=1 THEN
      	     SELECT hrat03 INTO l_hrat03_1 FROM hrat_file
      	      WHERE hrat01=g_sel[l_i].hrdm02
          ELSE
      	     SELECT hrat03 INTO l_hrat03 FROM hrat_file
      	      WHERE hrat01=g_sel[l_i].hrdm02
      	     IF l_hrat03 != l_hrat03_1 THEN
      	 	      LET l_check='Y'
      	 	      EXIT FOR
      	     END IF
          END IF
       END FOR
       IF l_check='Y' THEN
   	      CALL cl_err('选取的员工公司必须一致','!',1)
   	      RETURN
       ELSE                          #add by zhangbo130913
          LET l_hrat03=l_hrat03_1    #add by zhangbo130913
       END IF

       LET p_row=3   LET p_col=6

       OPEN WINDOW q080_gen AT p_row,p_col WITH FORM "ghr/42f/ghrq080_gen"
         ATTRIBUTE (STYLE = g_win_style CLIPPED)
       CALL cl_ui_locale("ghrq080_gen")

       CLEAR FORM
       INITIALIZE l_hrdm.* TO NULL

       #WHILE TRUE

       INPUT l_hrdm.hrdm08,l_hrdm.hrdm03,l_hrdm.hrdm13,l_hrdm.hrdm04,
             l_hrdm.hrdm05,l_hrdm.hrdm07,l_hrdm.hrdm11
       WITHOUT DEFAULTS FROM hrdm08,hrdm03,hrdm13,hrdm04,hrdm05,hrdm07,hrdm11

       BEFORE INPUT
          LET l_hrdm.hrdm08=1
          LET l_hrdm.hrdm07=g_today
          LET l_hrdm.hrdm12 = '0'
          LET l_hrdm.hrdm13 = 'N'
          LET l_hrdm.hrdmuser = g_user
          LET l_hrdm.hrdmoriu = g_user
          LET l_hrdm.hrdmorig = g_grup
          LET l_hrdm.hrdmgrup = g_grup               #
          LET l_hrdm.hrdmdate = g_today
          LET l_hrdm.hrdmacti = 'Y'
          IF l_hrdm.hrdm13 = 'N' THEN
          #	 CALL cl_set_comp_required("hrdm05",TRUE)  #mark by zhuzw 20131111
          	 CALL cl_set_comp_entry("hrdm05",TRUE)
          ELSE
          	 LET l_hrdm.hrdm05=''
          	 DISPLAY l_hrdm.hrdm05 TO hrdm05
          	# CALL cl_set_comp_required("hrdm05",FALSE)  #mark by zhuzw 20131111
          	 CALL cl_set_comp_entry("hrdm05",FALSE)
          END IF

          DISPLAY l_hrdm.hrdm07 TO hrdm07
          DISPLAY l_hrdm.hrdm08 TO hrdm08
          DISPLAY l_hrdm.hrdm13 TO hrdm13

       AFTER FIELD hrdm03
          IF NOT cl_null(l_hrdm.hrdm03) THEN
             LET l_n=0
             SELECT COUNT(*) INTO l_n FROM hrdl_file
              WHERE hrdl01=l_hrdm.hrdm03

             IF l_n=0 THEN
                CALL cl_err('无此薪资类别','!',0)
                NEXT FIELD hrdm03
             END IF

             SELECT hrdl02 INTO l_hrdl02 FROM hrdl_file WHERE hrdl01=l_hrdm.hrdm03
             DISPLAY l_hrdl02 TO hrdl02

          END IF

       AFTER FIELD hrdm13
         IF NOT cl_null(l_hrdm.hrdm13) THEN
         	  IF l_hrdm.hrdm13 = 'N' THEN
          	#   CALL cl_set_comp_required("hrdm05",TRUE)  #mark by zhuzw 20131111
          	   CALL cl_set_comp_entry("hrdm05",TRUE)
            ELSE
          	   LET l_hrdm.hrdm05=''
          	   DISPLAY l_hrdm.hrdm05 TO hrdm05
          	#   CALL cl_set_comp_required("hrdm05",FALSE)  #mark by zhuzw 20131111
          	   CALL cl_set_comp_entry("hrdm05",FALSE)
            END IF
         END IF


       AFTER FIELD hrdm04
          IF NOT cl_null(l_hrdm.hrdm04) THEN
             LET l_n=0
             SELECT COUNT(*) INTO l_n FROM hrct_file WHERE hrct11=l_hrdm.hrdm04
                                                     #  AND hrct03=l_hrat03
       	     IF l_n=0 THEN
       	  	    CALL cl_err('无此薪资月','!',0)
       	  	    NEXT FIELD hrdm04
       	     END IF

       	     IF NOT cl_null(l_hrdm.hrdm05) THEN
       	     	  IF l_hrdm.hrdm04 != l_hrdm.hrdm05 THEN
                  SELECT hrct07 INTO l_hrct07_b FROM hrct_file WHERE hrct11=l_hrdm.hrdm04
                  SELECT hrct07 INTO l_hrct07_e FROM hrct_file WHERE hrct11=l_hrdm.hrdm05
                  IF l_hrct07_b>l_hrct07_e THEN
                     CALL cl_err('开始期间不可比结束期间大','!',0)
                     NEXT FIELD hrdm04
                  END IF
                END IF
             END IF

          END IF

       AFTER FIELD hrdm05
          IF NOT cl_null(l_hrdm.hrdm05) THEN
             LET l_n=0
             SELECT COUNT(*) INTO l_n FROM hrct_file WHERE hrct11=l_hrdm.hrdm05
                                                       #$AND hrct03=l_hrat03
       	     IF l_n=0 THEN
       	  	    CALL cl_err('无此薪资月','!',0)
       	  	    NEXT FIELD hrdm05
       	     END IF

       	     IF NOT cl_null(l_hrdm.hrdm04) THEN
       	     	  IF l_hrdm.hrdm04 != l_hrdm.hrdm05 THEN
                  SELECT hrct07 INTO l_hrct07_b FROM hrct_file WHERE hrct11=l_hrdm.hrdm04
                  SELECT hrct07 INTO l_hrct07_e FROM hrct_file WHERE hrct11=l_hrdm.hrdm05
                  IF l_hrct07_b>l_hrct07_e THEN
                     CALL cl_err('开始期间不可比结束期间大','!',0)
                     NEXT FIELD hrdm05
                  END IF
                END IF
             END IF

          END IF

       AFTER INPUT
          IF INT_FLAG THEN
             EXIT INPUT
          END IF
          IF cl_null(l_hrdm.hrdm05) THEN
             LET l_hrdm.hrdm13 = 'Y'
             DISPLAY BY NAME l_hrdm.hrdm13
          END IF

       ON ACTION controlp
          CASE
            WHEN INFIELD(hrdm03)
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_hrdl01"
            LET g_qryparam.default1 = l_hrdm.hrdm03
            CALL cl_create_qry() RETURNING l_hrdm.hrdm03
            DISPLAY l_hrdm.hrdm03 TO hrdm03
            NEXT FIELD hrdm03

            WHEN INFIELD(hrdm04)
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_hrct11"
            LET g_qryparam.arg1 = l_hrat03
            LET g_qryparam.default1 = l_hrdm.hrdm04
            CALL cl_create_qry() RETURNING l_hrdm.hrdm04
            DISPLAY l_hrdm.hrdm04 TO hrdm04
            NEXT FIELD hrdm04

            WHEN INFIELD(hrdm05)
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_hrct11"
            LET g_qryparam.arg1 = l_hrat03
            LET g_qryparam.default1 = l_hrdm.hrdm05
            CALL cl_create_qry() RETURNING l_hrdm.hrdm05
            DISPLAY l_hrdm.hrdm05 TO hrdm05
            NEXT FIELD hrdm05

          END CASE

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT

       ON ACTION about
          CALL cl_about()

       ON ACTION help
          CALL cl_show_help()

       ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
       END INPUT

       IF INT_FLAG THEN
          LET INT_FLAG=0
          CLOSE WINDOW q080_gen
          RETURN
       END IF


       CLOSE WINDOW q080_gen

       LET li_k=1

       FOR l_i = 1 TO g_rec_sel

           LET g_success='Y'
           BEGIN WORK

           SELECT hratid INTO l_hrdm.hrdm02 FROM hrat_file WHERE hrat01=g_sel[l_i].hrdm02

         	 SELECT hrct07 INTO l_hrct07_b FROM hrct_file WHERE hrct11=l_hrdm.hrdm04
                                                         # AND hrct03=l_hrat03
           IF l_hrdm.hrdm13='N' THEN
              SELECT hrct08 INTO l_hrct08_e FROM hrct_file WHERE hrct11=l_hrdm.hrdm05
                                                          #   AND hrct03=l_hrat03
           END IF
          DELETE FROM hrdm_file WHERE hrdm02=l_hrdm.hrdm02
           LET l_n=0
           LET l_n1=0
           LET l_n2=0
           IF l_hrdm.hrdm13='Y' THEN    #此笔设置无限期
              SELECT COUNT(*) INTO l_n1 FROM hrct_file,hrdm_file
               WHERE hrdm02=l_hrdm.hrdm02
                 AND hrdm12='0'
                 AND hrdm13='N'         #对比的不是无限期,那么开始日期必须比对比资料的结束日期大
                 AND hrct11=hrdm05
                # AND hrct03=l_hrat03
                 AND hrct08>=l_hrct07_b
              SELECT COUNT(*) INTO l_n2 FROM hrct_file,hrdm_file
               WHERE hrdm02=l_hrdm.hrdm02
                 AND hrdm12='0'
                 AND hrdm13='Y'         #对比资料是无限期,那么肯定交叉
           ELSE                         #此笔不是无限期
              SELECT COUNT(*) INTO l_n1 FROM hrct_file A,hrct_file B,hrdm_file
               WHERE hrdm02=l_hrdm.hrdm02
                 AND hrdm12='0'
                 AND hrdm13='N'          #对比资料也不是无限期
                 AND A.hrct11=hrdm04
                 AND B.hrct11=hrdm05
                # AND A.hrct03=l_hrat03        #add by zhangbo130705
                # AND B.hrct03=l_hrat03        #add by zhangbo130705
                 AND ((l_hrct07_b>=A.hrct07 AND l_hrct08_e<=B.hrct08)
                     OR (A.hrct07 BETWEEN l_hrct07_b AND l_hrct08_e)
                     OR (B.hrct08 BETWEEN l_hrct07_b AND l_hrct08_e))
              SELECT COUNT(*) INTO l_n2 FROM hrct_file,hrdm_file
               WHERE hrdm02=l_hrdm.hrdm02
                 AND hrdm12='0'
                 AND hrdm13='Y'         #对比的是无限期,那么结束日期必须比对比资料的开始日期小
                 AND hrct11=hrdm05
                # AND hrct03=l_hrat03
                 AND hrct07<=l_hrct08_e
           END IF

           IF l_n1>0 OR l_n2>0 THEN
              LET lr_err[li_k].line=li_k
              LET lr_err[li_k].key1=g_sel[l_i].hrdm02
              LET lr_err[li_k].err="此员工薪资月有交叉"
              LET li_k=li_k+1
              ROLLBACK WORK
              CONTINUE FOR
           END IF

           LET l_year=YEAR(g_today) USING "&&&&"
           LET l_month=MONTH(g_today) USING "&&"
           LET l_day=DAY(g_today) USING "&&"
           LET l_year=l_year.trim()
           LET l_month=l_month.trim()
           LET l_day=l_day.trim()
           LET l_hrdm.hrdm01=l_year CLIPPED,l_month CLIPPED,l_day CLIPPED
           LET l_hrdm01=l_hrdm.hrdm01,"%"
           LET l_sql="SELECT MAX(hrdm01) FROM hrdm_file",
                     " WHERE hrdm01 LIKE '",l_hrdm01,"'"
           PREPARE i080_gen_hrdm01 FROM l_sql
           EXECUTE i080_gen_hrdm01 INTO l_hrdm.hrdm01
           IF cl_null(l_hrdm.hrdm01) THEN
              LET l_hrdm.hrdm01=l_hrdm01[1,8],'0001'
           ELSE
              LET l_no=l_hrdm.hrdm01[9,12]
              LET l_no=l_no+1 USING "&&&&"
              LET l_hrdm.hrdm01=l_hrdm01[1,8],l_no
           END IF

           INSERT INTO hrdm_file VALUES (l_hrdm.*)
           UPDATE hrat_file SET hrat71 = l_hrdm.hrdm03 WHERE hratid = l_hrdm.hrdm02

           IF SQLCA.sqlcode THEN
              LET g_success='N'
              LET lr_err[li_k].line=li_k
              LET lr_err[li_k].key1=g_sel[l_i].hrdm02
              LET lr_err[li_k].err=SQLCA.sqlcode
              LET li_k=li_k+1
           END IF
           	IF lr_err.getLength() > 0 THEN
           	   CALL cl_err('异常','!',1)
           	END IF

           IF g_success='Y' THEN
    	       COMMIT WORK
           ELSE
    	       ROLLBACK WORK
           END IF

       END FOR

       CALL q080_b_fill()

END FUNCTION
#add by zhangbo130912---end






