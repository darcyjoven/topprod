# Prog. Version..: '5.10.04-08.10.22(00000)'     #
#
# Pattern name...: ghri014.4gl
# Descriptions...: 直接主管配置作业
# Date & Author..: 13/04/12 by liudong
# Modify.........: by zhuzw 20140923 修改查询逻辑

DATABASE ds

GLOBALS "../../config/top.global"


DEFINE
     g_hrat_bf      DYNAMIC ARRAY OF RECORD
        sel         LIKE type_file.chr1,       #选择，默认'N'
        hrat01      LIKE hray_file.hray01,     #试用期工号
        hrat02      LIKE hrat_file.hrat02,     #员工姓名
        hrat06      LIKE hrat_file.hrat06,     #直接主管工号
        mgname      LIKE hrat_file.hrat02,     #直接主管名
        hrat03      LIKE hrat_file.hrat03,     #公司编号
        hraa12      LIKE hraa_file.hraa12,     #公司名称
        hrat04      LIKE hrat_file.hrat04,     #部门编号
        hrao02      LIKE hrao_file.hrao02,     #部门名称
        hrat87      LIKE hrat_file.hrat87,     #课别编号
        hrat87_name LIKE hrao_file.hrao02,     #课别名称
        hrat88      LIKE hrat_file.hrat88,     #组别编号
        hrat88_name LIKE hrao_file.hrao02,     #组别名称
        hrat05      LIKE hrat_file.hrat05,     #职位编号
        hras04      LIKE hras_file.hras04,     #职位
        hras06      LIKE hras_file.hras06,     #职位等级编号
        hras06_0    LIKE hrag_file.hrag07,     #职位等级说明 hras06=hrag06 and hrag01='205' and hrag03='2'
        hrat07      LIKE hrat_file.hrat07,     #部门主管否
        status_0    LIKE hrad_file.hrad03,     #员工状态     hrat19=hrad02
        hrat25      LIKE hrat_file.hrat25,     #入司日期
        hratid_0    LIKE hrat_file.hratid      #员工ID(KEY)
                    END RECORD,
     g_hrat_af      DYNAMIC ARRAY OF RECORD
        sel1        LIKE type_file.chr1,       #选择，默认'N'
        hrat01_1    LIKE hray_file.hray01,     #试用期工号
        hrat02_1    LIKE hrat_file.hrat02,     #员工姓名
        hrat06_1    LIKE hrat_file.hrat06,     #直接主管工号
        mgname_1    LIKE hrat_file.hrat02,     #直接主管名
        hrat03_1    LIKE hrat_file.hrat03,     #公司编号
        hraa12_1    LIKE hraa_file.hraa12,     #公司名称
        hrat04_1    LIKE hrat_file.hrat04,     #部门编号
        hrao02_1    LIKE hrao_file.hrao02,     #部门名称
        hrat87_1      LIKE hrat_file.hrat87,     #课别编号
        hrat87_name1 LIKE hrao_file.hrao02,     #课别名称
        hrat88_1      LIKE hrat_file.hrat88,     #组别编号
        hrat88_name1 LIKE hrao_file.hrao02,     #组别名称
        hrat05_1    LIKE hrat_file.hrat05,     #职位编号
        hras04_1    LIKE hras_file.hras04,     #职位
        hras06_1    LIKE hras_file.hras06,     #职位等级编号
        hras06_01   LIKE hrag_file.hrag07,     #职位等级说明 hras06=hrag06 and hrag01='205' and hrag03='2'
        hrat07_1    LIKE hrat_file.hrat07,     #部门主管否
        status_1    LIKE hrad_file.hrad03,     #员工状态     hrat19=hrad02
        hrat25_1    LIKE hrat_file.hrat25,     #入司日期
        hratid_1    LIKE hrat_file.hratid      #员工ID(KEY)
                    END RECORD,
     g_hrat_all     DYNAMIC ARRAY OF RECORD
        sel2        LIKE type_file.chr1,       #选择，默认'N'
        hrat01_2    LIKE hray_file.hray01,     #试用期工号
        hrat02_2    LIKE hrat_file.hrat02,     #员工姓名
        hrat06_2    LIKE hrat_file.hrat06,     #直接主管工号
        mgname_2    LIKE hrat_file.hrat02,     #直接主管名
        hrat03_2    LIKE hrat_file.hrat03,     #公司编号
        hraa12_2    LIKE hraa_file.hraa12,     #公司名称
        hrat04_2    LIKE hrat_file.hrat04,     #部门编号
        hrao02_2    LIKE hrao_file.hrao02,     #部门名称
        hrat87_2     LIKE hrat_file.hrat87,     #课别编号
        hrat87_name2 LIKE hrao_file.hrao02,     #课别名称
        hrat88_2      LIKE hrat_file.hrat88,     #组别编号
        hrat88_name2 LIKE hrao_file.hrao02,     #组别名称
        hrat05_2    LIKE hrat_file.hrat05,     #职位编号
        hras04_2    LIKE hras_file.hras04,     #职位
        hras06_2    LIKE hras_file.hras06,     #职位等级编号
        hras06_02   LIKE hrag_file.hrag07,     #职位等级说明 hras06=hrag06 and hrag01='205' and hrag03='2'
        hrat07_2    LIKE hrat_file.hrat07,     #部门主管否
        status_2    LIKE hrad_file.hrad03,     #员工状态     hrat19=hrad02
        hrat25_2    LIKE hrat_file.hrat25,     #入司日期
        hratid_2    LIKE hrat_file.hratid      #员工ID(KEY)
                    END RECORD,
    g_wc1           STRING,
    g_wc2           STRING,
    g_wc3           STRING,
    g_wc            STRING,
    g_sql           STRING,
    g_cmd           LIKE type_file.chr1000,
    g_rec_b1         LIKE type_file.num5,
    g_sel_b1         LIKE type_file.num5,
    g_rec_b2         LIKE type_file.num5,
    g_sel_b2         LIKE type_file.num5,
    g_rec_b3         LIKE type_file.num5,
    g_sel_b3         LIKE type_file.num5,
    l_ac            LIKE type_file.num5

DEFINE g_forupd_sql STRING
DEFINE g_cnt        LIKE type_file.num10
DEFINE g_before_input_done   LIKE type_file.num5
DEFINE g_i          LIKE type_file.num5
DEFINE g_on_change  LIKE type_file.num5
DEFINE g_row_count  LIKE type_file.num5
DEFINE g_curs_index LIKE type_file.num5
DEFINE g_str        STRING
DEFINE g_flag       LIKE type_file.chr1

MAIN

    DEFINE p_row,p_col   LIKE type_file.num5

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

      CALL  cl_used(g_prog,g_time,1)
         RETURNING g_time

    LET p_row = 4 LET p_col = 3
    OPEN WINDOW i014_w AT p_row,p_col WITH FORM "ghr/42f/ghri014"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)

    CALL cl_ui_init()
   # CALL i014_cx()
    LET g_forupd_sql = "SELECT hratid ",
                       "  FROM hrat_file WHERE hratid=?  FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i014_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

    LET g_wc1 = '1=0'
    LET g_wc2 = '1=0'
    LET g_wc3 = '1=0'
    LET g_flag='1'                           #PAGE页签标识
#   CALL i014_b_fill(g_wc1,g_wc2,g_wc3)
    CALL i014_menu()
    CLOSE WINDOW i014_w
      CALL  cl_used(g_prog,g_time,2)
         RETURNING g_time    #No.FUN-6A0081
END MAIN

FUNCTION i014_menu()
   WHILE TRUE
      #FUN-151021 wangjya
      IF g_flag ='1' THEN
         CALL i014_bp("G")
      END IF
      IF g_flag ='2' THEN
         CALL i014_bp2("G")
#      ELSE
#         CALL i014_bp("G")
      END IF
      IF g_flag ='3' THEN
         CALL i014_bp3("G")
      END IF
      #FUN-151021 wangjya

      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth()  THEN
               IF g_flag = '1' THEN
                  CALL i014_q()
               END IF
            END IF

         WHEN "ghri014_a"
            IF cl_chk_act_auth() THEN
               CALL i014_peizhi()
            END IF

         #FUN-151021 wangjya
         WHEN "q2"
            IF cl_chk_act_auth() THEN
               IF g_flag = '2' THEN
                  CALL i014_q2()
               END IF
            END IF
         #FUN-151021 wangjya
         #FUN-160105 WJY
         WHEN "q3"
            IF cl_chk_act_auth() THEN
               IF g_flag = '3' THEN
                  CALL i014_q3()
               END IF
            END IF
         #FUN-160105 WJY
         WHEN "before"
            IF cl_chk_act_auth() THEN
               LET g_flag='1'
               DISPLAY g_rec_b1 TO FORMONLY.cnt1
               DISPLAY g_sel_b1 TO FORMONLY.cnt2
            END IF
          WHEN "after"
            IF cl_chk_act_auth() THEN
               LET g_flag='2'
               DISPLAY g_rec_b2 TO FORMONLY.cnt1
               DISPLAY g_sel_b2 TO FORMONLY.cnt2
            END IF
          WHEN "all"
            IF cl_chk_act_auth() THEN
               LET g_flag='3'
               DISPLAY g_rec_b3 TO FORMONLY.cnt1
               DISPLAY g_sel_b3 TO FORMONLY.cnt2
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()

         WHEN "exporttoexcel"   #No.FUN-4B0020
            IF cl_chk_act_auth() THEN
              CASE g_flag
                WHEN "1"   CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrat_bf),'','')
                WHEN "2"   CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrat_af),'','')
                WHEN "3"   CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrat_all),'','')
              END CASE
            END IF

      END CASE
   END WHILE
END FUNCTION

FUNCTION i014_q()
     CALL i014_b_askkey()
END FUNCTION

FUNCTION i014_bp(p_ud)
DEFINE
    p_ud            LIKE type_file.chr1,
    l_ac_t          LIKE type_file.num5,
    l_n             LIKE type_file.num5,
    l_i             LIKE type_file.num5,
    l_lock_sw       LIKE type_file.chr1,
    p_cmd           LIKE type_file.chr1,
    l_allow_insert  LIKE type_file.chr1,
    l_allow_delete  LIKE type_file.chr1

    IF p_ud <> "G" OR g_action_choice = "detail" THEN
       RETURN
    END IF

#    IF s_shut(0) THEN RETURN END IF
#    CALL cl_opmsg('b')
#    LET g_action_choice = ""

    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')

 DIALOG ATTRIBUTES(UNBUFFERED)

    #before页签
    INPUT ARRAY g_hrat_bf  FROM s_hrat_bf.*
          ATTRIBUTE (COUNT=g_rec_b1,MAXCOUNT=g_rec_b1,  #UNBUFFERED,
                     INSERT ROW = FALSE,DELETE ROW=FALSE,APPEND ROW=TRUE)

    BEFORE INPUT
       CALL cl_set_act_visible("accept,cancel", FALSE)

    BEFORE ROW
        LET p_cmd=''
        LET l_ac = ARR_CURR()
        LET l_lock_sw = 'N'            #DEFAULT
        LET l_n  = ARR_COUNT()

     ON CHANGE sel
        LET g_sel_b1 = 0
        FOR l_i = 1 TO g_rec_b1
          IF g_hrat_bf[l_i].sel = 'Y' THEN
            LET g_sel_b1 = g_sel_b1 + 1
            #LET g_hrat_bft[g_sel_b1].*=g_hrat_bf[l_i].*
          END IF
        END FOR
        CALL g_hrat_bf.deleteElement(l_i)
        DISPLAY g_sel_b1 TO FORMONLY.cnt2
     END INPUT

     ON ACTION QUERY
         LET g_action_choice="query"
         EXIT DIALOG

      ON ACTION ghri014_a
         LET g_action_choice="ghri014_a"
         EXIT DIALOG

      ON ACTION sel_all
         LET g_action_choice="sel_all"
         CASE g_flag
            WHEN "1"
                LET g_sel_b1 = 0
                FOR l_i = 1 TO g_rec_b1
                  LET g_sel_b1 = g_sel_b1 + 1
                  LET g_hrat_bf[l_i].sel = 'Y'
                END FOR
                CALL g_hrat_bf.deleteElement(l_i)
                #LET g_hrat_bft.*=g_hrat_bf.*
                DISPLAY g_sel_b1 TO FORMONLY.cnt2
         END CASE


      ON ACTION sel_none
         LET g_action_choice="sel_none"
         CASE g_flag
            WHEN "1"
              LET g_sel_b1 = 0
              FOR l_i = 1 TO g_rec_b1
                 LET g_hrat_bf[l_i].sel = 'N'
                 #CALL g_hrat_bft.deleteElement(l_i)
              END FOR
              CALL g_hrat_bf.deleteElement(l_i)
              #CALL g_hrat_bft.deleteElement(l_i)
              DISPLAY g_sel_b1 TO FORMONLY.cnt2
         END CASE

      ON ACTION after
         LET g_flag = "2"
         EXIT DIALOG

      ON ACTION all
         LET g_flag = "3"
         EXIT DIALOG

      ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG


      ON ACTION cancel
         LET INT_FLAG=TRUE  		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DIALOG

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE  DIALOG

      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121


      ON ACTION exporttoexcel   #No.FUN-4B0020
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG
    END DIALOG
    CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION i014_b_askkey()
    CLEAR FORM
    CALL g_hrat_bf.clear()
    CALL g_hrat_af.clear()
    CALL g_hrat_all.clear()
    LET g_rec_b1=0
    LET g_sel_b1=0
    LET g_rec_b2=0
    LET g_sel_b2=0
    LET g_rec_b3=0
    LET g_sel_b3=0

  DIALOG ATTRIBUTE(UNBUFFERED)
    CONSTRUCT g_wc1 ON hrat01,hrat02,hrat06,hrat03,hrat04,hrat87,hrat88,hrat05,hrat07,hrat25
         FROM s_hrat_bf[1].hrat01,s_hrat_bf[1].hrat02,s_hrat_bf[1].hrat06,s_hrat_bf[1].hrat03,s_hrat_bf[1].hrat04,s_hrat_bf[1].hrat87,s_hrat_bf[1].hrat88,
              s_hrat_bf[1].hrat05,s_hrat_bf[1].hrat07,s_hrat_bf[1].hrat25

      BEFORE CONSTRUCT
         CALL cl_set_act_visible("accept,cancel", TRUE)
    END CONSTRUCT


#    CONSTRUCT g_wc2 ON hrat01,hrat02,hrat06,hrat03,hrat04,hrat05,hrat07,hrat25
#         FROM s_hrat_af[1].hrat01_1,s_hrat_af[1].hrat02_1,s_hrat_af[1].hrat06_1,s_hrat_af[1].hrat03_1,s_hrat_af[1].hrat04_1,
#              s_hrat_af[1].hrat05_1,s_hrat_af[1].hrat07_1,s_hrat_af[1].hrat25_1
#
#      BEFORE CONSTRUCT
#         CALL cl_set_act_visible("accept,cancel", TRUE)
#    END CONSTRUCT

#    CONSTRUCT g_wc3 ON hrat01,hrat02,hrat06,hrat03,hrat04,hrat05,hrat07,hrat25
#         FROM s_hrat_all[1].hrat01_2,s_hrat_all[1].hrat02_2,s_hrat_all[1].hrat06_2,s_hrat_all[1].hrat03_2,s_hrat_all[1].hrat04_2,
#              s_hrat_all[1].hrat05_2,s_hrat_all[1].hrat07_2,s_hrat_all[1].hrat25_2
#
#      BEFORE CONSTRUCT
#         CALL cl_set_act_visible("accept,cancel", TRUE)
#
#    END CONSTRUCT

      ON ACTION CONTROLP
         CASE
         	  WHEN INFIELD(hrat01)
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_hrat01"

               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO s_hrat_bf[1].hrat01
               NEXT FIELD hrat01
            #add by zhuzw 20140924 start
         	  WHEN INFIELD(hrat04)
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_hrao01"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO s_hrat_bf[1].hrat04
               NEXT FIELD hrat04
            #add by zhuzw 20140924 end
            WHEN INFIELD(hrat01_1)
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_hrat01"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO s_hrat_af[1].hrat01_1
               NEXT FIELD hrat01_1
            WHEN INFIELD(hrat01_2)
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_hrat01"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO s_hrat_all[1].hrat01_2
               NEXT FIELD hrat01_2
         OTHERWISE
              EXIT CASE
         END CASE

     ON ACTION before
        LET g_flag = "1"
        EXIT DIALOG

     ON ACTION after
        LET g_flag = "2"
        EXIT DIALOG

     ON ACTION all
        LET g_flag = "3"
        #EXIT DIALOG

    ON ACTION EXIT
       LET INT_FLAG = TRUE
       EXIT DIALOG

    ON ACTION accept
       EXIT DIALOG

    ON ACTION cancel
       LET INT_FLAG = TRUE
       EXIT DIALOG

     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DIALOG

      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121

      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121

      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121

    END DIALOG
    LET g_wc1 = g_wc1 CLIPPED,cl_get_extra_cond('hratuser', 'hratgrup') #FUN-980030
  #  LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('hratuser', 'hratgrup') #FUN-980030
  #  LET g_wc3 = g_wc3 CLIPPED,cl_get_extra_cond('hratuser', 'hratgrup') #FUN-980030

   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc1 = NULL
     # LET g_wc2 = NULL
     # LET g_wc3 = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --

  #  CALL i014_b_fill(g_wc1,g_wc2,g_wc3)
#    CALL i014_b_fill(g_wc1)
     CALL i014_b_fill(g_wc1)

END FUNCTION

#FUNCTION i014_b_fill(p_wc1,p_wc2,p_wc3)              #BODY FILL UP
FUNCTION i014_b_fill(p_wc1)
    DEFINE p_wc1           STRING
    DEFINE p_wc2           STRING
    DEFINE p_wc3           STRING

    #未配置资料
    LET g_sql = "SELECT 'N',hrat01,hrat02,hrat06,'',hrat03,hraa12,hrat04,hrao02,hrat87,'',hrat88,'',hrat05,hras04,hras06,'',hrat07,hrad03,hrat25,hratid ",
                   " FROM hraa_file,hrao_file,hrat_file,hras_file,hrad_file",
                   " WHERE ", p_wc1 CLIPPED,
                   " AND hratconf = 'Y' ",
                   " AND hrad01<>'003' ",
                   " AND (hrat06 is null or hrat06 = ' ') ",
                   " AND  hrat03=hraa01(+) ",
                   " AND  hrat19=hrad02(+) ",
                   " AND hrat04=hrao01(+) AND hrat05=hras01(+)  ",
                   " ORDER BY 1"

    PREPARE i014_pb1 FROM g_sql
    DECLARE hrat_curs1 CURSOR FOR i014_pb1

    CALL g_hrat_bf.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH hrat_curs1 INTO g_hrat_bf[g_cnt].*
        IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
        END IF
        #课别名称
        SELECT hrao02 INTO g_hrat_bf[g_cnt].hrat87_name FROM hrao_file
         WHERE hrao01= g_hrat_bf[g_cnt].hrat87
        #组别名称
        SELECT hrao02 INTO g_hrat_bf[g_cnt].hrat88_name FROM hrao_file
         WHERE hrao01= g_hrat_bf[g_cnt].hrat88

        #主管名称
        SELECT hrat02 INTO g_hrat_bf[g_cnt].mgname FROM hrat_file
         LEFT JOIN hrad_file ON hrad02=hrat19
         WHERE hrad01<>'003' AND hrat01= g_hrat_bf[g_cnt].hrat06

        #职级名称
        SELECT hrag07 INTO g_hrat_bf[g_cnt].hras06_0 FROM hrag_file
         WHERE hrag06=g_hrat_bf[g_cnt].hras06  and hrag01='205' and hrag03='2'

        IF cl_null(g_hrat_bf[g_cnt].hrat07) THEN LET g_hrat_bf[g_cnt].hrat07 = 'N' END IF

        LET g_cnt = g_cnt + 1
#        IF g_cnt > g_max_rec THEN
#           CALL cl_err( '', 9035, 0 )
#           EXIT FOREACH
#        END IF
    END FOREACH
    CALL g_hrat_bf.deleteElement(g_cnt)
    LET g_rec_b1 = g_cnt-1
    LET g_sel_b1 = 0
    #已配置资料
    LET g_sql = "SELECT 'N',hrat01,hrat02,hrat06,'',hrat03,hraa12,hrat04,hrao02,hrat87,'',hrat88,'',hrat05,hras04,hras06,'',hrat07,hrad03,hrat25,hratid ",
                   " FROM hraa_file,hrao_file,hrat_file,hras_file,hrad_file",
                   " WHERE ", p_wc1 CLIPPED,
                   " AND hratconf = 'Y' ",
                   #" AND hrat19='1001' ",
                   " AND hrat06 is not null  ",
                   " AND  hrat03=hraa01(+) ",
                   " AND  hrat19=hrad02(+) ",
                   " AND  hrad01<>'003' ",
                   " AND hrat04=hrao01(+) AND hrat05=hras01(+)  ",
                   " ORDER BY 1"
    PREPARE i014_pb12 FROM g_sql
    DECLARE hrat_curs12 CURSOR FOR i014_pb12

    CALL g_hrat_af.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH hrat_curs12 INTO g_hrat_af[g_cnt].*
        IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
        END IF
        #课别名称
        SELECT hrao02 INTO g_hrat_af[g_cnt].hrat87_name1 FROM hrao_file
         WHERE hrao01= g_hrat_af[g_cnt].hrat87_1
        #组别名称
        SELECT hrao02 INTO g_hrat_af[g_cnt].hrat88_name1 FROM hrao_file
         WHERE hrao01= g_hrat_af[g_cnt].hrat88_1

        #主管名称
        SELECT hrat02 INTO g_hrat_af[g_cnt].mgname_1 FROM hrat_file
         LEFT JOIN hrad_file ON hrad02=hrat19
         WHERE hrad01<>'003' AND
          hrat01= g_hrat_af[g_cnt].hrat06_1
        #职级名称
        SELECT hrag07 INTO g_hrat_af[g_cnt].hras06_1 FROM hrag_file
         WHERE hrag06=g_hrat_af[g_cnt].hras06_1  and hrag01='205' and hrag03='2'

        IF cl_null(g_hrat_af[g_cnt].hrat07_1) THEN LET g_hrat_af[g_cnt].hrat07_1 = 'N' END IF

        LET g_cnt = g_cnt + 1
#        IF g_cnt > g_max_rec THEN
#           CALL cl_err( '', 9035, 0 )
#           EXIT FOREACH
#        END IF
    END FOREACH
    CALL g_hrat_af.deleteElement(g_cnt)
    LET g_rec_b2 = g_cnt-1
    LET g_sel_b2 = 0
    #全部资料
    LET g_sql = "SELECT 'N',hrat01,hrat02,hrat06,'',hrat03,hraa12,hrat04,hrao02,hrat87,'',hrat88,'',hrat05,hras04,hras06,'',hrat07,hrad03,hrat25,hratid ",
                   " FROM hraa_file,hrao_file,hrat_file,hras_file,hrad_file",
                   " WHERE ", p_wc1 CLIPPED,
                   " AND hratconf = 'Y' ",
                   #" AND hrat19='1001' ",
                   #" AND (hrat06 is null or hrat06 = ' ') ",
                   " AND  hrat03=hraa01(+) ",
                   " AND  hrat19=hrad02(+) ",
                   " AND  hrad01<>'003' ",
                   " AND hrat04=hrao01(+) AND hrat05=hras01(+)  ",
                   " ORDER BY 1"

    PREPARE i014_pb3 FROM g_sql
    DECLARE hrat_curs3 CURSOR FOR i014_pb3

    CALL g_hrat_all.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH hrat_curs3 INTO g_hrat_all[g_cnt].*
        IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
        END IF
        #课别名称
        SELECT hrao02 INTO g_hrat_all[g_cnt].hrat87_name2 FROM hrao_file
         WHERE hrao01= g_hrat_all[g_cnt].hrat87_2
        #组别名称
        SELECT hrao02 INTO g_hrat_all[g_cnt].hrat88_name2 FROM hrao_file
         WHERE hrao01= g_hrat_all[g_cnt].hrat88_2

        #主管名称
        SELECT hrat02 INTO g_hrat_all[g_cnt].mgname_2 FROM hrat_file
         LEFT JOIN hrad_file ON hrad02=hrat19
         WHERE hrad01<>'003' AND
         hrat01= g_hrat_all[g_cnt].hrat06_2
        #职级名称
        SELECT hrag07 INTO g_hrat_all[g_cnt].hras06_2 FROM hrag_file
         WHERE hrag06=g_hrat_all[g_cnt].hras06_2  and hrag01='205' and hrag03='2'

        IF cl_null(g_hrat_all[g_cnt].hrat07_2) THEN LET g_hrat_all[g_cnt].hrat07_2 = 'N' END IF

        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
#           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_hrat_all.deleteElement(g_cnt)
    LET g_rec_b3 = g_cnt-1
    LET g_sel_b3 = 0
    DISPLAY g_rec_b1 TO FORMONLY.cnt1
    DISPLAY g_sel_b1 TO FORMONLY.cnt2
    MESSAGE ""
    CASE g_flag
      WHEN "1"
          DISPLAY g_rec_b1 TO FORMONLY.cnt1
          DISPLAY g_sel_b1 TO FORMONLY.cnt2
      WHEN "2"
          DISPLAY g_rec_b2 TO FORMONLY.cnt1
          DISPLAY g_sel_b2 TO FORMONLY.cnt2
      WHEN "3"
          DISPLAY g_rec_b3 TO FORMONLY.cnt1
          DISPLAY g_sel_b3 TO FORMONLY.cnt2
    END CASE
    LET g_cnt = 0
END FUNCTION
#归档功能相关逻辑
FUNCTION i014_peizhi()
   DEFINE   l_hrat01    LIKE hrat_file.hrat01    #直接主管工号
   DEFINE   l_hrat02    LIKE hrat_file.hrat02    #直接主管姓名
   DEFINE   l_cnt       LIKE type_file.num5
   DEFINE   l_i         LIKE type_file.num5

     #如果未选取任何资料则退出此函数
     IF g_flag IS NOT NULL OR g_flag='1' OR g_flag='2' OR g_flag='3' THEN
        CASE g_flag
           WHEN "1"
             IF g_sel_b1 = 0 THEN
               CALL cl_err('','-400',1)
               RETURN
             END IF
           WHEN "2"
             IF g_sel_b2 = 0 THEN
               CALL cl_err('','-400',1)
               RETURN
             END IF
           WHEN "3"
             IF g_sel_b3 = 0 THEN
               CALL cl_err('','-400',1)
               RETURN
             END IF
        END CASE
     ELSE
        CALL cl_err('','-400',1)
        RETURN
     END IF

     OPEN WINDOW i014_1_w AT 3,4 WITH FORM "ghr/42f/ghri014_1"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)

      CALL cl_ui_locale('ghri014_1')

     CALL cl_set_act_visible("accept,cancel", TRUE)
     INPUT l_hrat01  FROM  FORMONLY.hrat01

      AFTER FIELD hrat01
        IF NOT cl_null(l_hrat01) THEN
           SELECT COUNT(*) INTO l_cnt FROM hrat_file
             WHERE hrat01 = l_hrat01
               AND hratconf = 'Y'
           IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
           CASE
             WHEN l_cnt = 0                                 #该员工不存在
                CALL cl_err(l_hrat01,'ghr-047',0)
                NEXT FIELD hrat01
             WHEN l_cnt > 1                                 #该员工编号出现重复
                CALL cl_err(l_hrat01,'ghr-048',0)
                NEXT FIELD hrat01
             OTHERWISE
                SELECT hrat02 INTO  l_hrat02 FROM hrat_file
                 WHERE hrat01 = l_hrat01
                   AND hratconf = 'Y'
                DISPLAY l_hrat01 TO hrat01
                DISPLAY l_hrat02 TO pname
           END CASE
        END IF

      ON ACTION controlp
         CASE
          WHEN INFIELD(hrat01)
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_hrat02"
               CALL cl_create_qry() RETURNING l_hrat01
               SELECT hrat02 INTO l_hrat02 FROM hrat_file
                WHERE hrat01=l_hrat01
               DISPLAY l_hrat01 TO  hrat01
               DISPLAY l_hrat02 TO  pname
               NEXT FIELD hrat01
         END CASE

      ON ACTION EXIT
         LET INT_FLAG=TRUE
         EXIT INPUT

      ON ACTION controlg
        CALL cl_cmdask()


      ON ACTION cancel
         LET INT_FLAG=TRUE 		#MOD-570244	mars
         EXIT INPUT

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121

      END INPUT

      IF INT_FLAG THEN
        LET INT_FLAG = FALSE
        CLOSE WINDOW i014_1_w
        RETURN
      END IF
      IF NOT cl_confirm('ghr-709') THEN
         CLOSE WINDOW i014_1_w
         RETURN
      END IF

      #开始执行转正逻辑处理
      CASE g_flag
         WHEN "1"
            BEGIN WORK
            LET g_success ='Y'
            FOR l_i=1 TO g_rec_b1
              IF g_hrat_bf[l_i].sel = 'Y' THEN
                 OPEN  i014_bcl USING g_hrat_bf[l_i].hratid_0       #锁住资料
                 IF SQLCA.sqlcode THEN
                    CALL cl_err('lock hrat_file',SQLCA.sqlcode,1)
                    LET g_success = 'N'
                    CLOSE i014_bcl
                    EXIT FOR
                 END IF
                 #Step1.配置的直接主管不能是自己
                 IF g_hrat_bf[l_i].hrat01 = l_hrat01 THEN
                   CALL cl_err(l_hrat01,'ghr-046',1)
                   LET g_success = 'N'
                   CLOSE i014_bcl
                   EXIT FOR
                 END IF
                 #Step2.更新员工基本资料档状态
                 UPDATE hrat_file SET hrat06=l_hrat01
                  WHERE hratid=g_hrat_bf[l_i].hratid_0
                 IF SQLCA.sqlcode THEN
                   CALL cl_err('upd hrat06',SQLCA.sqlcode,1)
                   LET g_success = 'N'
                   CLOSE i014_bcl
                   EXIT FOR
                 END IF
                 CLOSE i014_bcl                             #解锁资料
              END IF
            END FOR
            IF g_success = 'Y' THEN
              COMMIT WORK
              CLOSE WINDOW i014_1_w
              CALL cl_err('','ghr-033',1)                   #show出执行结果
              CALL i014_b_fill(g_wc1)           #执行成功刷新数据
            ELSE
            	 ROLLBACK WORK
            	 CLOSE WINDOW i014_1_w
            	 CALL cl_err('','ghr-034',1)                   #show出执行结果
            END IF
         WHEN "2"
            BEGIN WORK
            LET g_success ='Y'
            FOR l_i=1 TO g_rec_b2
              IF g_hrat_af[l_i].sel1 = 'Y' THEN
                 OPEN  i014_bcl USING g_hrat_af[l_i].hratid_1       #锁住资料
                 IF SQLCA.sqlcode THEN
                    CALL cl_err('lock hrat_file',SQLCA.sqlcode,1)
                    LET g_success = 'N'
                    CLOSE i014_bcl
                    EXIT FOR
                 END IF
                 #Step1.配置的直接主管不能是自己
                 IF g_hrat_af[l_i].hrat01_1 = l_hrat01 THEN
                   CALL cl_err(l_hrat01,'ghr-046',1)
                   LET g_success = 'N'
                   CLOSE i014_bcl
                   EXIT FOR
                 END IF
                 #Step2.更新员工基本资料档状态
                 UPDATE hrat_file SET hrat06=l_hrat01
                  WHERE hratid=g_hrat_af[l_i].hratid_1
                 IF SQLCA.sqlcode THEN
                   CALL cl_err('upd hrat06',SQLCA.sqlcode,1)
                   LET g_success = 'N'
                   CLOSE i014_bcl
                   EXIT FOR
                 END IF
                 CLOSE i014_bcl                             #解锁资料
              END IF
            END FOR
            IF g_success = 'Y' THEN
              COMMIT WORK
              CLOSE WINDOW i014_1_w
              CALL cl_err('','ghr-033',1)                   #show出执行结果
              CALL i014_b_fill(g_wc1)           #执行成功刷新数据
            ELSE
            	 ROLLBACK WORK
            	 CLOSE WINDOW i014_1_w
            	 CALL cl_err('','ghr-034',1)                   #show出执行结果
            END IF
         WHEN "3"
            BEGIN WORK
            LET g_success ='Y'
            FOR l_i=1 TO g_rec_b3
              IF g_hrat_all[l_i].sel2 = 'Y' THEN
                 OPEN  i014_bcl USING g_hrat_all[l_i].hratid_2       #锁住资料
                 IF SQLCA.sqlcode THEN
                    CALL cl_err('lock hrat_file',SQLCA.sqlcode,1)
                    LET g_success = 'N'
                    CLOSE i014_bcl
                    EXIT FOR
                 END IF
                 #Step1.配置的直接主管不能是自己
                 IF g_hrat_all[l_i].hrat01_2 = l_hrat01 THEN
                   CALL cl_err(l_hrat01,'ghr-046',1)
                   LET g_success = 'N'
                   CLOSE i014_bcl
                   EXIT FOR
                 END IF
                 #Step2.更新员工基本资料档状态
                 UPDATE hrat_file SET hrat06=l_hrat01
                  WHERE hratid=g_hrat_all[l_i].hratid_2
                 IF SQLCA.sqlcode THEN
                   CALL cl_err('upd hrat06',SQLCA.sqlcode,1)
                   LET g_success = 'N'
                   CLOSE i014_bcl
                   EXIT FOR
                 END IF
                 CLOSE i014_bcl                             #解锁资料
              END IF
            END FOR
            IF g_success = 'Y' THEN
              COMMIT WORK
              CLOSE WINDOW i014_1_w
              CALL cl_err('','ghr-033',1)                   #show出执行结果
              CALL i014_b_fill(g_wc1)           #执行成功刷新数据
            ELSE
            	 ROLLBACK WORK
            	 CLOSE WINDOW i014_1_w
            	 CALL cl_err('','ghr-034',1)                   #show出执行结果
            END IF
      END CASE

END FUNCTION

#FUN-151021 wangjya
FUNCTION i014_q2()
     CALL i014_b2_askkey()
END FUNCTION

FUNCTION i014_bp2(p_ud)
DEFINE
    p_ud            LIKE type_file.chr1,
    l_ac_t          LIKE type_file.num5,
    l_n             LIKE type_file.num5,
    l_i             LIKE type_file.num5,
    l_lock_sw       LIKE type_file.chr1,
    p_cmd           LIKE type_file.chr1,
    l_allow_insert  LIKE type_file.chr1,
    l_allow_delete  LIKE type_file.chr1

    IF p_ud <> "G" OR g_action_choice = "detail" THEN
       RETURN
    END IF

#    IF s_shut(0) THEN RETURN END IF
#    CALL cl_opmsg('b')
#    LET g_action_choice = ""

    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')

    DIALOG ATTRIBUTES(UNBUFFERED)

    #after页签

    INPUT ARRAY g_hrat_af  FROM s_hrat_af.*
          ATTRIBUTE (COUNT=g_rec_b2,MAXCOUNT=g_rec_b2,  #UNBUFFERED,
                     INSERT ROW = FALSE,DELETE ROW=FALSE,APPEND ROW=TRUE)

    BEFORE INPUT
       CALL cl_set_act_visible("accept,cancel", FALSE)

    BEFORE ROW
        LET p_cmd=''
        LET l_ac = ARR_CURR()
        LET l_lock_sw = 'N'            #DEFAULT
        LET l_n  = ARR_COUNT()

      ON CHANGE sel1
        LET g_sel_b2 = 0
        FOR l_i = 1 TO g_rec_b2
          IF g_hrat_af[l_i].sel1 = 'Y' THEN
            LET g_sel_b2 = g_sel_b2 + 1
            #LET g_hrat_bft[g_sel_b2].*=g_hrat_bf[l_i].*
          END IF
        END FOR
        CALL g_hrat_af.deleteElement(l_i)
        DISPLAY g_sel_b2 TO FORMONLY.cnt2
     END INPUT

#     ON ACTION QUERY
#         LET g_action_choice="query"
#         EXIT DIALOG

    ON ACTION ghri014_a
       LET g_action_choice="ghri014_a"
       EXIT DIALOG

     #FUN-151021 wangjya
     ON ACTION q2
         LET g_action_choice="q2"
         EXIT DIALOG
      #FUN-151021 wangjya

      ON ACTION sel_all
         LET g_action_choice="sel_all"
         CASE g_flag
            WHEN "2"
                LET g_sel_b2 = 0
                FOR l_i = 1 TO g_rec_b2
                  LET g_sel_b2 = g_sel_b2 + 1
                  LET g_hrat_af[l_i].sel1 = 'Y'
                END FOR
                CALL g_hrat_af.deleteElement(l_i)
                #LET g_hrat_aft.*=g_hrat_af.*
                DISPLAY g_sel_b2 TO FORMONLY.cnt2
         END CASE


      ON ACTION sel_none
         LET g_action_choice="sel_none"
         CASE g_flag
            WHEN "2"
              LET g_sel_b2 = 0
              FOR l_i = 1 TO g_rec_b2
                 LET g_hrat_af[l_i].sel1 = 'N'
                 #CALL g_hrat_aft.deleteElement(l_i)
              END FOR
              CALL g_hrat_af.deleteElement(l_i)
              #CALL g_hrat_aft.deleteElement(l_i)
              DISPLAY g_sel_b2 TO FORMONLY.cnt2
         END CASE

      ON ACTION before
         LET g_flag = "1"
         EXIT DIALOG

      ON ACTION all
         LET g_flag = "3"
         EXIT DIALOG

      ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG


      ON ACTION cancel
         LET INT_FLAG=TRUE  		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DIALOG

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE  DIALOG

      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121


      ON ACTION exporttoexcel   #No.FUN-4B0020
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG
    END DIALOG
    CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION i014_b2_askkey()
    CLEAR FORM
    CALL g_hrat_bf.clear()
    CALL g_hrat_af.clear()
    CALL g_hrat_all.clear()
    LET g_rec_b1=0
    LET g_sel_b1=0
    LET g_rec_b2=0
    LET g_sel_b2=0
    LET g_rec_b3=0
    LET g_sel_b3=0

  DIALOG ATTRIBUTE(UNBUFFERED)
#    CONSTRUCT g_wc1 ON hrat01,hrat02,hrat06,hrat03,hrat04,hrat05,hrat07,hrat25
#         FROM s_hrat_bf[1].hrat01,s_hrat_bf[1].hrat02,s_hrat_bf[1].hrat06,s_hrat_bf[1].hrat03,s_hrat_bf[1].hrat04,
#              s_hrat_bf[1].hrat05,s_hrat_bf[1].hrat07,s_hrat_bf[1].hrat25
#
#      BEFORE CONSTRUCT
#         IF g_flag = "1" THEN
#            CALL cl_set_act_visible("accept,cancel", TRUE)
#         END IF
#    END CONSTRUCT


    CONSTRUCT g_wc2 ON hrat01,hrat02,hrat06,hrat03,hrat04,hrat05,hrat07,hrat25
         FROM s_hrat_af[1].hrat01_1,s_hrat_af[1].hrat02_1,s_hrat_af[1].hrat06_1,s_hrat_af[1].hrat03_1,s_hrat_af[1].hrat04_1,
              s_hrat_af[1].hrat05_1,s_hrat_af[1].hrat07_1,s_hrat_af[1].hrat25_1

      BEFORE CONSTRUCT
         CALL cl_set_act_visible("accept,cancel", TRUE)
    END CONSTRUCT

#    CONSTRUCT g_wc3 ON hrat01,hrat02,hrat06,hrat03,hrat04,hrat05,hrat07,hrat25
#         FROM s_hrat_all[1].hrat01_2,s_hrat_all[1].hrat02_2,s_hrat_all[1].hrat06_2,s_hrat_all[1].hrat03_2,s_hrat_all[1].hrat04_2,
#              s_hrat_all[1].hrat05_2,s_hrat_all[1].hrat07_2,s_hrat_all[1].hrat25_2
#
#      BEFORE CONSTRUCT
#         CALL cl_set_act_visible("accept,cancel", TRUE)
#
#    END CONSTRUCT

      ON ACTION CONTROLP
         CASE
#         	  WHEN INFIELD(hrat01)
#               CALL cl_init_qry_var()
#               LET g_qryparam.form  = "q_hrat01"
#               LET g_qryparam.state = "c"
#               CALL cl_create_qry() RETURNING g_qryparam.multiret
#               DISPLAY g_qryparam.multiret TO s_hrat_bf[1].hrat01
#               NEXT FIELD hrat01
#            #add by zhuzw 20140924 start
#         	  WHEN INFIELD(hrat04)
#               CALL cl_init_qry_var()
#               LET g_qryparam.form  = "q_hrao01"
#               LET g_qryparam.state = "c"
#               CALL cl_create_qry() RETURNING g_qryparam.multiret
#               DISPLAY g_qryparam.multiret TO s_hrat_bf[1].hrat04
#               NEXT FIELD hrat04
#            #add by zhuzw 20140924 end

            WHEN INFIELD(hrat01_1)
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_hrat01"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO s_hrat_af[1].hrat01_1
               NEXT FIELD hrat01_1

#            WHEN INFIELD(hrat01_2)
#               CALL cl_init_qry_var()
#               LET g_qryparam.form  = "q_hrat01"
#               LET g_qryparam.state = "c"
#               CALL cl_create_qry() RETURNING g_qryparam.multiret
#               DISPLAY g_qryparam.multiret TO s_hrat_all[1].hrat01_2
#               NEXT FIELD hrat01_2
         OTHERWISE
              EXIT CASE
         END CASE

     ON ACTION before
        LET g_flag = "1"
        EXIT DIALOG

#     ON ACTION after
#        LET g_flag = "2"
#        EXIT DIALOG

     ON ACTION all
        LET g_flag = "3"
        #EXIT DIALOG

    ON ACTION EXIT
       LET INT_FLAG = TRUE
       EXIT DIALOG

    ON ACTION accept
       EXIT DIALOG

    ON ACTION cancel
       LET INT_FLAG = TRUE
       EXIT DIALOG

     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DIALOG

      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121

      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121

      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121

    END DIALOG
#    LET g_wc1 = g_wc1 CLIPPED,cl_get_extra_cond('hratuser', 'hratgrup') #FUN-980030
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('hratuser', 'hratgrup') #FUN-980030
  #  LET g_wc3 = g_wc3 CLIPPED,cl_get_extra_cond('hratuser', 'hratgrup') #FUN-980030

   IF INT_FLAG THEN
      LET INT_FLAG = 0
#      LET g_wc1 = NULL
      LET g_wc2 = NULL
     # LET g_wc3 = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --

  #  CALL i014_b_fill(g_wc1,g_wc2,g_wc3)
#    CALL i014_b_fill(g_wc1)
     CALL i014_b2_fill(g_wc2)
END FUNCTION

FUNCTION i014_b2_fill(p_wc2)
    DEFINE p_wc1           STRING
    DEFINE p_wc2           STRING
    DEFINE p_wc3           STRING

       LET g_sql = "SELECT 'N',hrat01,hrat02,hrat06,'',hrat03,hraa12,hrat04,hrao02,hrat05,hras04,hras06,'',hrat07,hrad03,hrat25,hratid ",
                      " FROM hraa_file,hrao_file,hrat_file,hras_file,hrad_file",
                      " WHERE ", p_wc2 CLIPPED,
                      " AND hratconf = 'Y' ",
                      #" AND hrat19='1001' ",
                      " AND hrat06 is not null  ",
                      " AND  hrat03=hraa01(+) ",
                      " AND  hrat19=hrad02(+) ",
                      " AND  hrad01<>'003' ",
                      " AND hrat04=hrao01(+) AND hrat05=hras01(+)  ",
                      " ORDER BY 1"

    PREPARE i014_pb2 FROM g_sql
    DECLARE hrat_curs2 CURSOR FOR i014_pb2

    CALL g_hrat_af.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH hrat_curs2 INTO g_hrat_af[g_cnt].*
        IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
        END IF

        #主管名称
        SELECT hrat02 INTO g_hrat_af[g_cnt].mgname_1 FROM hrat_file
         LEFT JOIN hrad_file ON hrad02=hrat19
         WHERE hrad01<>'003' AND
          hrat01= g_hrat_af[g_cnt].hrat06_1
        #职级名称
        SELECT hrag07 INTO g_hrat_af[g_cnt].hras06_1 FROM hrag_file
         WHERE hrag06=g_hrat_af[g_cnt].hras06_1  and hrag01='205' and hrag03='2'

        IF cl_null(g_hrat_af[g_cnt].hrat07_1) THEN LET g_hrat_af[g_cnt].hrat07_1 = 'N' END IF

        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_hrat_af.deleteElement(g_cnt)
    LET g_rec_b2 = g_cnt-1
    LET g_sel_b2 = 0
    DISPLAY g_rec_b2 TO FORMONLY.cnt1
    DISPLAY g_sel_b2 TO FORMONLY.cnt2


    LET g_cnt = 0
END FUNCTION
#FUN-151021 wangjya

#FUN-160105 WJY
FUNCTION i014_q3()
    CALL i014_b3_askkey()
END FUNCTION

FUNCTION i014_bp3(p_ud)
DEFINE
    p_ud            LIKE type_file.chr1,
    l_ac_t          LIKE type_file.num5,
    l_n             LIKE type_file.num5,
    l_i             LIKE type_file.num5,
    l_lock_sw       LIKE type_file.chr1,
    p_cmd           LIKE type_file.chr1,
    l_allow_insert  LIKE type_file.chr1,
    l_allow_delete  LIKE type_file.chr1

    IF p_ud <> "G" OR g_action_choice = "detail" THEN
       RETURN
    END IF

#    IF s_shut(0) THEN RETURN END IF
#    CALL cl_opmsg('b')
#    LET g_action_choice = ""

    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')

    DIALOG ATTRIBUTES(UNBUFFERED)
    #all页签
    INPUT ARRAY g_hrat_all FROM s_hrat_all.*
          ATTRIBUTE (COUNT=g_rec_b3,MAXCOUNT=g_rec_b3,  #UNBUFFERED,
                     INSERT ROW = FALSE,DELETE ROW=FALSE,APPEND ROW=TRUE)

    BEFORE INPUT
       CALL cl_set_act_visible("accept,cancel", FALSE)

    BEFORE ROW
        LET p_cmd=''
        LET l_ac = ARR_CURR()
        LET l_lock_sw = 'N'            #DEFAULT
        LET l_n  = ARR_COUNT()

      ON CHANGE sel2
        LET g_sel_b3 = 0
        FOR l_i = 1 TO g_rec_b3
          IF g_hrat_all[l_i].sel2 = 'Y' THEN
            LET g_sel_b3 = g_sel_b3 + 1
            #LET g_hrat_allt[g_sel_b3].*=g_hrat_all[l_i].*
          END IF
        END FOR
        CALL g_hrat_all.deleteElement(l_i)
        DISPLAY g_sel_b3 TO FORMONLY.cnt2
     END INPUT

#     ON ACTION query
#         LET g_action_choice="query"
#         EXIT DIALOG

      ON ACTION ghri014_a
         LET g_action_choice="ghri014_a"
         EXIT DIALOG

      ON ACTION q3
         LET g_action_choice="q3"
         EXIT DIALOG

      ON ACTION sel_all
         LET g_action_choice="sel_all"
         CASE g_flag
            WHEN "3"
                LET g_sel_b3 = 0
                FOR l_i = 1 TO g_rec_b3
                  LET g_sel_b3 = g_sel_b3 + 1
                  LET g_hrat_all[l_i].sel2 = 'Y'
                END FOR
                CALL g_hrat_all.deleteElement(l_i)
                #LET g_hrat_allt.*=g_hrat_all.*
                DISPLAY g_sel_b3 TO FORMONLY.cnt2
         END CASE

      ON ACTION sel_none
         LET g_action_choice="sel_none"
         CASE g_flag
            WHEN "3"
              LET g_sel_b3 = 0
              FOR l_i = 1 TO g_rec_b3
                 LET g_hrat_all[l_i].sel2 = 'N'
                 #CALL g_hrat_allt.deleteElement(l_i)
              END FOR
              CALL g_hrat_all.deleteElement(l_i)
              #CALL g_hrat_allt.deleteElement(l_i)
              DISPLAY g_sel_b3 TO FORMONLY.cnt2
         END CASE

      ON ACTION before
         LET g_flag = "1"
         EXIT DIALOG

      ON ACTION after
         LET g_flag = "2"
         EXIT DIALOG

      ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG


      ON ACTION cancel
         LET INT_FLAG=TRUE  		 #MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DIALOG

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE  DIALOG

      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121


      ON ACTION exporttoexcel   #No.FUN-4B0020
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG
    END DIALOG
    CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION i014_b3_askkey()
    CLEAR FORM
    CALL g_hrat_bf.clear()
    CALL g_hrat_af.clear()
    CALL g_hrat_all.clear()
    LET g_rec_b1=0
    LET g_sel_b1=0
    LET g_rec_b2=0
    LET g_sel_b2=0
    LET g_rec_b3=0
    LET g_sel_b3=0

  DIALOG ATTRIBUTE(UNBUFFERED)

    CONSTRUCT g_wc3 ON hrat01,hrat02,hrat06,hrat03,hrat04,hrat05,hrat07,hrat25
         FROM s_hrat_all[1].hrat01_2,s_hrat_all[1].hrat02_2,s_hrat_all[1].hrat06_2,s_hrat_all[1].hrat03_2,s_hrat_all[1].hrat04_2,
              s_hrat_all[1].hrat05_2,s_hrat_all[1].hrat07_2,s_hrat_all[1].hrat25_2

      BEFORE CONSTRUCT
         CALL cl_set_act_visible("accept,cancel", TRUE)

    END CONSTRUCT

      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(hrat01_2)
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_hrat01"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO s_hrat_all[1].hrat01_2
               NEXT FIELD hrat01_2
         OTHERWISE
              EXIT CASE
         END CASE

     ON ACTION before
        LET g_flag = "1"
        EXIT DIALOG

     ON ACTION after
        LET g_flag = "2"
        EXIT DIALOG

#     ON ACTION all
         LET g_action_choice="after"
         LET g_flag = "2"
         DISPLAY g_rec_b2 TO FORMONLY.cnt1
         DISPLAY g_sel_b2 TO FORMONLY.cnt2

    ON ACTION EXIT
       LET INT_FLAG = TRUE
       EXIT DIALOG

    ON ACTION accept
       EXIT DIALOG

    ON ACTION cancel
       LET INT_FLAG = TRUE
       EXIT DIALOG

     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DIALOG

      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121

      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121

      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121

    END DIALOG
#    LET g_wc1 = g_wc1 CLIPPED,cl_get_extra_cond('hratuser', 'hratgrup') #FUN-980030
#    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('hratuser', 'hratgrup') #FUN-980030
    LET g_wc3 = g_wc3 CLIPPED,cl_get_extra_cond('hratuser', 'hratgrup') #FUN-980030

   IF INT_FLAG THEN
      LET INT_FLAG = 0
#      LET g_wc1 = NULL
      LET g_wc2 = NULL
     # LET g_wc3 = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --

  #  CALL i014_b_fill(g_wc1,g_wc2,g_wc3)
#    CALL i014_b_fill(g_wc1)
     CALL i014_b3_fill(g_wc2)
END FUNCTION

FUNCTION i014_b3_fill(p_wc2)
    DEFINE p_wc1           STRING
    DEFINE p_wc2           STRING
    DEFINE p_wc3           STRING

    #全部资料
    LET g_sql = "SELECT 'N',hrat01,hrat02,hrat06,'',hrat03,hraa12,hrat04,hrao02,hrat87,'',hrat88,'',hrat05,hras04,hras06,'',hrat07,hrad03,hrat25,hratid ",
                   " FROM hraa_file,hrao_file,hrat_file,hras_file,hrad_file",
                   " WHERE ", p_wc1 CLIPPED,
                   " AND hratconf = 'Y' ",
                   #" AND hrat19='1001' ",
                   #" AND (hrat06 is null or hrat06 = ' ') ",
                   " AND  hrat03=hraa01(+) ",
                   " AND  hrat19=hrad02(+) ",
                   " AND  hrad01<>'003' ",
                   " AND hrat04=hrao01(+) AND hrat05=hras01(+)  ",
                   " ORDER BY 1"

    PREPARE i014_pb3_t FROM g_sql
    DECLARE hrat_curs3_t CURSOR FOR i014_pb3_t

    CALL g_hrat_all.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH hrat_curs3_t INTO g_hrat_all[g_cnt].*
        IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
        END IF
        #课别名称
        SELECT hrao02 INTO g_hrat_all[g_cnt].hrat87_name2 FROM hrao_file
         WHERE hrao01= g_hrat_all[g_cnt].hrat87_2
        #组别名称
        SELECT hrao02 INTO g_hrat_all[g_cnt].hrat88_name2 FROM hrao_file
         WHERE hrao01= g_hrat_all[g_cnt].hrat88_2

        #主管名称
        SELECT hrat02 INTO g_hrat_all[g_cnt].mgname_2 FROM hrat_file
         LEFT JOIN hrad_file ON hrad02=hrat19
         WHERE hrad01<>'003' AND
         hrat01= g_hrat_all[g_cnt].hrat06_2
        #职级名称
        SELECT hrag07 INTO g_hrat_all[g_cnt].hras06_2 FROM hrag_file
         WHERE hrag06=g_hrat_all[g_cnt].hras06_2  and hrag01='205' and hrag03='2'

        IF cl_null(g_hrat_all[g_cnt].hrat07_2) THEN LET g_hrat_all[g_cnt].hrat07_2 = 'N' END IF

        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
#           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_hrat_all.deleteElement(g_cnt)
    LET g_rec_b3 = g_cnt-1
    LET g_sel_b3 = 0
    DISPLAY g_rec_b3 TO FORMONLY.cnt1
    DISPLAY g_sel_b3 TO FORMONLY.cnt2

    LET g_cnt = 0
END FUNCTION
#FUN-160105 WJY