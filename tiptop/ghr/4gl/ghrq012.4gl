# Prog. Version..: '5.25.04-11.09.15(00010)'     #
#
# Pattern name...: ghrq012.4gl
# Descriptions...: 查询人员排班明细资料
# Date & Author..: 13/06/19 By Jiangxt

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE
    g_cch       DYNAMIC ARRAY OF RECORD
	    ghrca02    LIKE hrca_file.hrca02,    #人员对象类型
      ghrat01    LIKE hrat_file.hrat01,   #对象编码
      ghrat02    LIKE hrat_file.hrat02,   #对象名称
      ghrca04    LIKE hrca_file.hrca04,   #班次编号
      ghrbo03    LIKE hrbo_file.hrbo03,   #班次名称
      gdate      LIKE type_file.dat,      #日期
      ghrcp06    LIKE hrcp_file.hrcp06,    #补充时间
      autorank   LIKE type_file.chr1,         #智能配班
      rankgrup   LIKE hrbz_file.hrbz02,       #候选班次组编码
      restday    LIKE type_file.chr1,         #休息日
      daytype    LIKE hrbo_file.hrbo02,       #日期类型
      atttype    LIKE hrbo_file.hrbo02       #考勤方式
       
                END RECORD
DEFINE g_rec_b   LIKE type_file.num5
DEFINE g_cnt     LIKE type_file.num10
DEFINE g_sql,g_wc     STRING
DEFINE g_bdate   LIKE type_file.dat
DEFINE g_edate   LIKE type_file.dat
DEFINE g_hrca02  LIKE hrca_file.hrca02
DEFINE g_str     VARCHAR(10000)
DEFINE g_flag    LIKE type_file.chr10
DEFINE g_sch    DYNAMIC ARRAY OF RECORD
       sch       STRING,
       sch1      LIKE type_file.dat,
       sch2      LIKE type_file.chr100
                END RECORD
DEFINE g_att    DYNAMIC ARRAY OF RECORD
                 sch   STRING,
                 sch1  STRING,
                 sch2  STRING
                END RECORD
DEFINE g_head   RECORD
       cb1       LIKE type_file.num5,
       cb2       LIKE type_file.num5,
       cb_name   LIKE type_file.chr100
               END RECORD
MAIN

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
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0146

    OPEN WINDOW q012_w AT 3,2
         WITH FORM "ghr/42f/ghrq012"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN

    CALL cl_ui_init()
    CALL q012_cs()
    CALL q012_menu()
    CLOSE WINDOW q012_w
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
END MAIN

FUNCTION q012_cs()
DEFINE lc_qbe_sn    LIKE gbm_file.gbm01

   CLEAR FORM
   CALL cl_set_head_visible("","YES")

   INPUT g_bdate,g_edate,g_hrca02,g_str WITHOUT DEFAULTS FROM bdate,edate,hrca02,hrat01
       BEFORE INPUT
          CALL cl_qbe_display_condition(lc_qbe_sn)
          LET g_bdate=g_today
          LET g_edate=g_today
          LET g_hrca02='1'
          DISPLAY g_hrca02 TO hrca02
          DISPLAY g_bdate TO bdate
          DISPLAY g_edate TO edate

       ON ACTION CONTROLP
          CASE
            WHEN INFIELD(hrat01)
              CALL cl_init_qry_var()
              LET g_qryparam.state = "c"
              CASE g_hrca02
                WHEN '1'
                  LET g_qryparam.form  = "q_hrat01"
                WHEN '2'
                  LET g_qryparam.form  = "q_hrao01"
                WHEN '3'
                  LET g_qryparam.form  = "q_hraa01"
                WHEN '4'
                  LET g_qryparam.form  = "q_hrcb"
                WHEN '5'
                  LET g_qryparam.form  = "q_hrao01_1_1"
                  LET g_qryparam.arg2 = '4'
                WHEN '6'
                  LET g_qryparam.form  = "q_hrao01_1_1"
                  LET g_qryparam.arg2 = '3'
                WHEN '7'
                  LET g_qryparam.form  = "q_hrao01_1_1"
                  LET g_qryparam.arg2 = '2'  
                OTHERWISE
                  NEXT FIELD hrca02
              END CASE
              CALL cl_create_qry() RETURNING g_str
              DISPLAY g_str TO hrat01
              NEXT FIELD hrat01
            OTHERWISE
              EXIT CASE
          END CASE

       ON ACTION CONTROLR
          CALL cl_show_req_fields()
       ON ACTION CONTROLG
          CALL cl_cmdask()
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
       ON ACTION about
          CALL cl_about()
       ON ACTION help
          CALL cl_show_help()
   END INPUT


   CALL q012_show()
END FUNCTION

FUNCTION q012_menu()

   WHILE TRUE
      IF g_flag="p2" THEN
         CALL q012_bp2("G")
      ELSE
         CALL q012_bp1("G")
      END IF
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q012_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "cb_next"
            IF NOT cl_null(g_head.cb_name) THEN
               CALL q012_cb(+1)
            END IF
         WHEN "cb_pre"
            IF NOT cl_null(g_head.cb_name) THEN
               CALL q012_cb(-1)
            END IF
         WHEN "controlg"
            CALL cl_cmdask()
#         WHEN "exporttoexcel"
#            CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_cch),'','')
          WHEN "exporttoexcel"   # 141016
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_cch),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION

FUNCTION q012_q()

    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL q012_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       CLEAR FORM
       CALL g_cch.clear()
       RETURN
    END IF
END FUNCTION

FUNCTION q012_show()
DEFINE l_mm,l_nn LIKE type_file.num5

    CALL cl_show_fld_cont()
    CALL q012_b_fill()
    DISPLAY g_rec_b TO cnt
    IF g_str NOT MATCHES '*|*' AND g_hrca02!='4' THEN
       LET l_mm=YEAR(g_today)
       LET l_nn=MONTH(g_today)
       CALL q012_sch_fill(l_mm,l_nn)
       LET g_head.cb1 = l_mm
       LET g_head.cb2 = l_nn
       LET g_head.cb_name = l_mm||'年'||l_nn||'月'
       DISPLAY g_head.cb_name TO cb_name
    ELSE
      LET g_head.cb1=''
      LET g_head.cb2=''
      LET g_head.cb_name=''
      CALL g_sch.clear()
      CALL g_att.clear()
    END IF
END FUNCTION

FUNCTION q012_b_fill()              #BODY FILL UP
DEFINE tok            base.StringTokenizer
DEFINE l_hrat01       LIKE hrat_file.hrat01
DEFINE l_date         LIKE type_file.dat
DEFINE l_num          LIKE type_file.num10
DEFINE l_hrca05       LIKE hrca_file.hrca05
DEFINE l_hrca06       LIKE hrca_file.hrca06
DEFINE l_hrca11       LIKE hrca_file.hrca11
DEFINE l_hrca08       LIKE hrca_file.hrca08
DEFINE l_hrca09       LIKE hrca_file.hrca09
DEFINE l_hrca10       LIKE hrca_file.hrca10
DEFINE l_hrbk05       LIKE hrbk_file.hrbk05
DEFINE l_hrcb01       LIKE hrcb_file.hrcb01
DEFINE icorpcode      LIKE hraa_file.hraa01       #公司编码
DEFINE l_wc           STRING
    CALL cl_get_hrzxa(g_user) RETURNING l_wc #160830 add by nihuan
    LET l_wc = cl_replace_str(l_wc,"hrat04","A.hrat04")
    
    LET g_cnt = 1
    LET g_rec_b = 0
    CALL g_cch.clear()
    CREATE TEMP TABLE q012_tmp(
       ghrca02   LIKE hrca_file.hrca02,
       ghrat01   LIKE hrat_file.hrat01,
       ghrat02   LIKE hrat_file.hrat02,
       ghrca04   LIKE hrca_file.hrca04,
       ghrbo03   LIKE hrbo_file.hrbo03,
       gdate     LIKE type_file.dat,
       ghrcp06   LIKE hrcp_file.hrcp06,
       ghrca05   LIKE hrca_file.hrca05,   #轮班编码
       ghrca06   LIKE hrca_file.hrca06,   #轮班开始班次
       ghrca11   LIKE hrca_file.hrca06,   #规则开始日期
       ghrca08   LIKE hrca_file.hrca08,   #假日跳过
       ghrca09   LIKE hrca_file.hrca09,   #节日跳过
       ghrca10   LIKE hrca_file.hrca10);  #节假日班次编码
    DELETE FROM q012_tmp
    
    LET tok = base.StringTokenizer.create(g_str,"|")
    WHILE tok.hasMoreTokens()
       LET l_hrat01 = tok.nextToken()
       FOR l_num=g_bdate TO g_edate
           LET l_date=l_num
              LET g_cch[g_cnt].ghrca02 =g_hrca02     #人员对象类型
              LET g_cch[g_cnt].gdate = l_date       #日期
           CASE g_hrca02
              WHEN '1'
#                  SELECT HRAT01,HRAT02,CASE WHEN hrcp07 = 'Y' THEN hrcp04 ELSE
#                         NVL(D.HRDQ06, NVL(E.HRDQ06, NVL(F.HRDQ06, NVL(G.HRDQ06,NVL(H.HRDQ06,NVL(I.HRDQ06,J.HRDQ06)))))) END,
#                         CASE WHEN hrcp07 = 'Y' THEN 'N' ELSE NVL(D.HRDQ08, NVL(E.HRDQ08, NVL(F.HRDQ08, NVL(G.HRDQ08,NVL(H.HRDQ08,NVL(I.HRDQ08,J.HRDQ08)))))) END,
#                         NVL(D.HRDQ09, NVL(E.HRDQ09, NVL(F.HRDQ09, NVL(G.HRDQ09,NVL(H.HRDQ09,NVL(I.HRDQ09,J.HRDQ09)))))),
#                         NVL(D.HRDQUD02, NVL(E.HRDQUD02, NVL(F.HRDQUD02, NVL(G.HRDQUD02,NVL(H.HRDQUD02,NVL(I.HRDQUD02,J.HRDQUD02)))))),
#                         NVL(D.HRDQ12, NVL(E.HRDQ12, NVL(F.HRDQ12, NVL(G.HRDQ12,NVL(H.HRDQ12,NVL(I.HRDQ12,J.HRDQ12)))))),HRBN02,HRAT03
#                    INTO g_cch[g_cnt].ghrat01,g_cch[g_cnt].ghrat02,g_cch[g_cnt].ghrca04, g_cch[g_cnt].autorank, g_cch[g_cnt].rankgrup,g_cch[g_cnt].restday,g_cch[g_cnt].daytype,g_cch[g_cnt].atttype,icorpcode
#                    FROM HRAT_FILE A
#                    LEFT JOIN HRCP_FILE B ON B.HRCP02 = A.HRATID AND B.HRCP03 = l_date
#                    LEFT JOIN HRCB_FILE C ON C.HRCB05 = A.HRATID AND l_date BETWEEN C.HRCB06 AND C.HRCB07
#                    LEFT JOIN HRDQ_FILE D ON D.HRDQ03 = A.HRATID AND D.HRDQ05 = l_date AND D.HRDQ02 = 1        #/*个人排班*/
#                    LEFT JOIN HRDQ_FILE E ON E.HRDQ03 = C.HRCB01 AND E.HRDQ05 = l_date AND E.HRDQ02 = 4        #/*群组排班*/
#                    LEFT JOIN HRDQ_FILE F ON F.HRDQ03 = A.HRAT88 AND F.HRDQ05 = l_date AND F.HRDQ02 = 7        #/*组别排班*/
#                    LEFT JOIN HRDQ_FILE G ON G.HRDQ03 = A.HRAT87 AND G.HRDQ05 = l_date AND G.HRDQ02 = 6        #/*科别排班*/
#                    LEFT JOIN HRDQ_FILE H ON H.HRDQ03 = A.HRAT04 AND H.HRDQ05 = l_date AND H.HRDQ02 = 2        #/*部门排班*/
#                    LEFT JOIN HRDQ_FILE I ON I.HRDQ03 = A.HRAT94 AND I.HRDQ05 = l_date AND I.HRDQ02 = 5        #/*中心排班*/
#                    LEFT JOIN HRDQ_FILE J ON J.HRDQ03 = A.HRAT03 AND J.HRDQ05 = l_date AND J.HRDQ02 = 3        #/*公司排班*/
#                    LEFT JOIN hrbn_file ON hrbn01=hrcp02 AND HRCP03 BETWEEN hrbn04 AND hrbn05
#                   WHERE A.HRAT01 = l_hrat01;
                   
                   LET g_sql="SELECT HRAT01,HRAT02,CASE WHEN hrcp07 = 'Y' THEN hrcp04 ELSE
                         NVL(D.HRDQ06, NVL(E.HRDQ06, NVL(F.HRDQ06, NVL(G.HRDQ06,NVL(H.HRDQ06,NVL(I.HRDQ06,J.HRDQ06)))))) END,
                         CASE WHEN hrcp07 = 'Y' THEN 'N' ELSE NVL(D.HRDQ08, NVL(E.HRDQ08, NVL(F.HRDQ08, NVL(G.HRDQ08,NVL(H.HRDQ08,NVL(I.HRDQ08,J.HRDQ08)))))) END,
                         NVL(D.HRDQ09, NVL(E.HRDQ09, NVL(F.HRDQ09, NVL(G.HRDQ09,NVL(H.HRDQ09,NVL(I.HRDQ09,J.HRDQ09)))))),
                         NVL(D.HRDQUD02, NVL(E.HRDQUD02, NVL(F.HRDQUD02, NVL(G.HRDQUD02,NVL(H.HRDQUD02,NVL(I.HRDQUD02,J.HRDQUD02)))))),
                         NVL(D.HRDQ12, NVL(E.HRDQ12, NVL(F.HRDQ12, NVL(G.HRDQ12,NVL(H.HRDQ12,NVL(I.HRDQ12,J.HRDQ12)))))),HRBN02,HRAT03
                    FROM HRAT_FILE A
                    LEFT JOIN HRCP_FILE B ON B.HRCP02 = A.HRATID AND B.HRCP03 = '",l_date,"'
                    LEFT JOIN HRCB_FILE C ON C.HRCB05 = A.HRATID AND '",l_date,"' BETWEEN C.HRCB06 AND C.HRCB07
                    LEFT JOIN HRDQ_FILE D ON D.HRDQ03 = A.HRATID AND D.HRDQ05 = '",l_date,"' AND D.HRDQ02 = 1        /*个人排班*/
                    LEFT JOIN HRDQ_FILE E ON E.HRDQ03 = C.HRCB01 AND E.HRDQ05 = '",l_date,"' AND E.HRDQ02 = 4        /*群组排班*/
                    LEFT JOIN HRDQ_FILE F ON F.HRDQ03 = A.HRAT88 AND F.HRDQ05 = '",l_date,"' AND F.HRDQ02 = 7        /*组别排班*/
                    LEFT JOIN HRDQ_FILE G ON G.HRDQ03 = A.HRAT87 AND G.HRDQ05 = '",l_date,"' AND G.HRDQ02 = 6        /*科别排班*/
                    LEFT JOIN HRDQ_FILE H ON H.HRDQ03 = A.HRAT04 AND H.HRDQ05 = '",l_date,"' AND H.HRDQ02 = 2        /*部门排班*/
                    LEFT JOIN HRDQ_FILE I ON I.HRDQ03 = A.HRAT94 AND I.HRDQ05 = '",l_date,"' AND I.HRDQ02 = 5        /*中心排班*/
                    LEFT JOIN HRDQ_FILE J ON J.HRDQ03 = A.HRAT03 AND J.HRDQ05 = '",l_date,"' AND J.HRDQ02 = 3        /*公司排班*/
                    LEFT JOIN hrbn_file ON hrbn01=A.HRATID AND '",l_date,"' BETWEEN hrbn04 AND hrbn05
                   WHERE A.HRAT01 ='",l_hrat01,"' and ",l_wc,""
                   PREPARE q012_p_n FROM g_sql
                   EXECUTE q012_p_n INTO g_cch[g_cnt].ghrat01,g_cch[g_cnt].ghrat02,g_cch[g_cnt].ghrca04, g_cch[g_cnt].autorank, g_cch[g_cnt].rankgrup,g_cch[g_cnt].restday,g_cch[g_cnt].daytype,g_cch[g_cnt].atttype,icorpcode
                 
                  IF NOT cl_null(g_cch[g_cnt].ghrca04) THEN 
                    SELECT hrbo03 INTO g_cch[g_cnt].ghrbo03 FROM hrbo_file WHERE hrbo02=g_cch[g_cnt].ghrca04
                  END IF 
                  LET g_cnt = g_cnt + 1
                LET g_sql="INSERT INTO q012_tmp ",
                         "SELECT '',hrat01,hrat02,hrcp04,hrbo03,hrcp03,hrcp06,'','','','','','' ",
                         "  FROM hrcp_file ",
                         "  LEFT JOIN hrat_file ON hratid = hrcp02",
                         "  LEFT JOIN hrbo_file ON hrbo02 = hrcp04",
#                         " WHERE hrcp03 = to_date('",l_date,"','yy/mm/dd')",
#                         "   AND hrcp03 = to_date('",l_date,"','yy/mm/dd')",
#                         "   AND hrcp02 = '",l_hrat01,"'"
                          "   WHERE hrcp03 between to_date('",l_date,"', 'yy/mm/dd') and to_date('",g_edate,"', 'yy/mm/dd') ",
                          "   AND hrat01 = '",l_hrat01,"'"
                PREPARE q012_p0 FROM g_sql
                EXECUTE q012_p0
                IF SQLCA.SQLCODE OR SQLCA.sqlerrd[3]=0 THEN
                   LET g_sql="INSERT INTO q012_tmp ",
                            "SELECT '',hrat01,hrat02,hrdq06,hrbo03,hrdq05,'','','','','','','' ",
                            "  FROM hrdq_file ",
                            "  LEFT JOIN hrat_file ON hratId = hrdq03",
                            "  LEFT JOIN hrbo_file ON hrbo02 = hrdq06",
#                            " WHERE hrdq05 = to_date('",l_date,"','yy/mm/dd')",
#                            "   AND hrdq05 = to_date('",g_edate,"','yy/mm/dd')",
                            "   WHERE hrdq05 between to_date('",l_date,"', 'yy/mm/dd') and to_date('",g_edate,"', 'yy/mm/dd') ",
                            "   AND hrat01 = '",l_hrat01,"'",
                            "   AND hrdq02 = '1'"
                   PREPARE q012_p2 FROM g_sql
                   EXECUTE q012_p2
                END IF
                IF SQLCA.SQLCODE OR SQLCA.sqlerrd[3]=0 THEN
                  SELECT hrcb01 INTO l_hrcb01 FROM hrcb_file WHERE l_date BETWEEN hrcb06 AND hrcb07 AND hrcb05 = l_hrat01
                   LET g_sql="INSERT INTO q012_tmp ",
                            "SELECT '',hrat01,hrat02,hrdq06,hrbo03,hrdq05,'','','','','','','' ",
                            "  FROM hrdq_file ",
                            "  LEFT JOIN hrcb_file ON hrcb01 = hrdq03 AND hrdq05 BETWEEN hrcb06 AND hrcb07",
                            "  LEFT JOIN hrat_file ON hratId = hrcb05",
                            "  LEFT JOIN hrbo_file ON hrbo02 = hrdq06",
#                            " WHERE hrdq05 = to_date('",l_date,"','yy/mm/dd')",
#                            "   AND hrdq05 = to_date('",g_edate,"','yy/mm/dd')",
                            "   WHERE hrdq05 between to_date('",l_date,"', 'yy/mm/dd') and to_date('",g_edate,"', 'yy/mm/dd') ",
                            "   AND hrat01 = '",l_hrat01,"'",
                            "   AND hrdq02 = '4'"
                   PREPARE q012_p1 FROM g_sql
                   EXECUTE q012_p1
                END IF
                IF SQLCA.SQLCODE OR SQLCA.sqlerrd[3]=0 THEN
                   LET g_sql="INSERT INTO q012_tmp ",
                            "SELECT '',hrat01,hrat02,hrdq06,hrbo03,hrdq05,'','','','','','','' ",
                            "  FROM hrdq_file ",
                            "  LEFT JOIN hrat_file ON hrat04 = hrdq03",
                            "  LEFT JOIN hrbo_file ON hrbo02 = hrdq06",
#                            " WHERE hrdq05 = to_date('",l_date,"','yy/mm/dd')",
#                            "   AND hrdq05 = to_date('",g_edate,"','yy/mm/dd')",
                            "   WHERE hrdq05 between to_date('",l_date,"', 'yy/mm/dd') and to_date('",g_edate,"', 'yy/mm/dd') ",
                            "   AND hrat01 = '",l_hrat01,"'",
                            "   AND hrdq02 = '2'"
                   PREPARE q012_p3 FROM g_sql
                   EXECUTE q012_p3
                END IF
                IF SQLCA.SQLCODE OR SQLCA.sqlerrd[3]=0 THEN
                   LET g_sql="INSERT INTO q012_tmp ",
                            "SELECT '',hrat01,hrat02,hrdq06,hrbo03,hrdq05,'','','','','','','' ",
                            "  FROM hrdq_file ",
                            "  LEFT JOIN hrat_file ON hrat03 = hrdq03",
                            "  LEFT JOIN hrbo_file ON hrbo02 = hrdq06",
#                            " WHERE hrdq05 = to_date('",l_date,"','yy/mm/dd')",
#                            "   AND hrdq05 = to_date('",g_edate,"','yy/mm/dd')",
                            "   WHERE hrdq05 between to_date('",l_date,"', 'yy/mm/dd') and to_date('",g_edate,"', 'yy/mm/dd') ",
                            "   AND hrat01 = '",l_hrat01,"'",
                            "   AND hrdq02 = '3'"
                   PREPARE q012_p4 FROM g_sql
                   EXECUTE q012_p4
                END IF
              WHEN '2'
                SELECT HRAO01,HRAO02,
                         NVL(F.HRDQ06, G.HRDQ06),
                         NVL(F.HRDQ08, G.HRDQ08),
                         NVL(F.HRDQ09, G.HRDQ09),
                         NVL(F.HRDQUD02, G.HRDQUD02),
                         NVL(F.HRDQ12, G.HRDQ12)
                    INTO g_cch[g_cnt].ghrat01,g_cch[g_cnt].ghrat02,g_cch[g_cnt].ghrca04, g_cch[g_cnt].autorank, g_cch[g_cnt].rankgrup,g_cch[g_cnt].restday,g_cch[g_cnt].daytype
                    FROM HRAO_FILE A
                    LEFT JOIN HRDQ_FILE F ON F.HRDQ03 = A.HRAO01 AND F.HRDQ05 = l_date AND F.HRDQ02 = 2        #/*部门排班*/
                    LEFT JOIN HRDQ_FILE G ON G.HRDQ03 = A.HRAO00 AND G.HRDQ05 = l_date AND G.HRDQ02 = 3        #/*公司排班*/
                   WHERE A.HRAO01 =l_hrat01
                  IF NOT cl_null(g_cch[g_cnt].ghrca04) THEN 
                    SELECT hrbo03 INTO g_cch[g_cnt].ghrbo03 FROM hrbo_file WHERE hrbo02=g_cch[g_cnt].ghrca04
                  END IF
                LET g_sql="INSERT INTO q012_tmp ",
                            "SELECT '',hrao01,hrao02,hrdq06,hrbo03,hrdq05,'','','','','','','' ",
                            "  FROM hrdq_file ",
                            "  LEFT JOIN hrao_file ON hrao01 = hrdq03",
                            "  LEFT JOIN hrbo_file ON hrbo02 = hrdq06",
#                            " WHERE hrdq05 = to_date('",l_date,"','yy/mm/dd')",
#                            "   AND hrdq05 = to_date('",g_edate,"','yy/mm/dd')",
                            "   WHERE hrdq05 between to_date('",l_date,"', 'yy/mm/dd') and to_date('",g_edate,"', 'yy/mm/dd') ",
                            "   AND hrao01 = '",l_hrat01,"'",
                            "   AND hrdq02 = '2'"
                PREPARE q012_p5 FROM g_sql
                EXECUTE q012_p5
                IF SQLCA.SQLCODE OR SQLCA.sqlerrd[3]=0 THEN
                   LET g_sql="INSERT INTO q012_tmp ",
                            "SELECT '',hrao01,hrao02,hrdq06,hrbo03,hrdq05,'','','','','','','' ",
                            "  FROM hrdq_file ",
                            "  LEFT JOIN hrao_file ON hrao00 = hrdq03",
                            "  LEFT JOIN hrbo_file ON hrbo02 = hrdq06",
#                            " WHERE hrdq05 = to_date('",l_date,"','yy/mm/dd')",
#                            "   AND hrdq05 = to_date('",g_edate,"','yy/mm/dd')",
                            "   WHERE hrdq05 between to_date('",l_date,"', 'yy/mm/dd') and to_date('",g_edate,"', 'yy/mm/dd') ",
                            "   AND hrao01 = '",l_hrat01,"'",
                            "   AND hrdq02 = '3'"
                   PREPARE q012_p6 FROM g_sql
                   EXECUTE q012_p6
                END IF
              WHEN '3'
                 SELECT HRAA01,HRAA02,
                         G.HRDQ06,
                         G.HRDQ08,
                         G.HRDQ09,
                         G.HRDQUD02,
                         G.HRDQ12
                   INTO g_cch[g_cnt].ghrat01,g_cch[g_cnt].ghrat02,g_cch[g_cnt].ghrca04, g_cch[g_cnt].autorank, g_cch[g_cnt].rankgrup,g_cch[g_cnt].restday,g_cch[g_cnt].daytype
                    FROM HRAA_FILE A
                    LEFT JOIN HRDQ_FILE G ON G.HRDQ03 = A.HRAA01 AND G.HRDQ05 = l_date AND G.HRDQ02 = 3        #/*公司排班*/
                   WHERE A.HRAA01 =l_hrat01
                LET g_sql="INSERT INTO q012_tmp ",
                            "SELECT '',hraa01,hraa02,hrdq06,hrbo03,hrdq05,'','','','','','','' ",
                            "  FROM hrdq_file ",
                            "  LEFT JOIN hraa_file ON hraa01 = hrdq03",
                            "  LEFT JOIN hrbo_file ON hrbo02 = hrdq06",
#                            " WHERE hrdq05 = to_date('",l_date,"','yy/mm/dd')",
#                            "   AND hrdq05 = to_date('",g_edate,"','yy/mm/dd')",
                            "   WHERE hrdq05 between to_date('",l_date,"', 'yy/mm/dd') and to_date('",g_edate,"', 'yy/mm/dd') ",
                            "   AND hraa01 = '",l_hrat01,"'",
                            "   AND hrdq02 = '3'"
                PREPARE q012_p7 FROM g_sql
                EXECUTE q012_p7
             WHEN '4'
                LET g_sql="INSERT INTO q012_tmp ",
                            "SELECT '',hrcb01,hrcb02,hrdq06,hrbo03,hrdq05,'','','','','','','' ",
                            "  FROM hrdq_file ",
                            "  LEFT JOIN hrcb_file ON hrcb01 = hrdq03",
                            "  LEFT JOIN hrbo_file ON hrbo02 = hrdq06",
#                            " WHERE hrdq05 = to_date('",l_date,"','yy/mm/dd')",
#                            "   AND hrdq05 = to_date('",g_edate,"','yy/mm/dd')",
                            "   WHERE hrdq05 between to_date('",l_date,"', 'yy/mm/dd') and to_date('",g_edate,"', 'yy/mm/dd') ",
                            "   AND hrcb01 = '",l_hrat01,"'",
                            "   AND hrdq02 = '4'"
                PREPARE q012_p8 FROM g_sql
                EXECUTE q012_p8
           END CASE
           LET g_sql=" UPDATE q012_tmp SET ghrca02='",g_hrca02,"', ",  #"gdate=to_date('",l_date,"','yy/mm/dd') ",
                     "  gdate between to_date('",l_date,"', 'yy/mm/dd') and to_date('",g_edate,"', 'yy/mm/dd')",
                     "  WHERE ghrca02 IS NULL"
           PREPARE q012_pp FROM g_sql
           EXECUTE q012_pp
       END FOR
    END WHILE

#    LET g_sql=" SELECT * FROM q012_tmp ORDER BY ghrat01,gdate"
    IF g_hrca02 =4 THEN 
    LET g_sql=" SELECT DISTINCT ghrca02,ghrat01,ghrat02,ghrca04,ghrbo03,gdate,ghrcp06,",
              "   ghrca05,ghrca06,ghrca11,ghrca08,ghrca09,ghrca10 FROM q012_tmp ",
              "  ORDER BY ghrat01,gdate"

    PREPARE q012_p FROM g_sql
    DECLARE q012_c CURSOR FOR q012_p
    FOREACH q012_c INTO g_cch[g_cnt].*,l_hrca05,l_hrca06,l_hrca11,l_hrca08,l_hrca09,l_hrca10
       IF cl_null(g_cch[g_cnt].ghrca04) THEN
          CALL q012_get_hrca04(l_hrca05,l_hrca06,l_hrca11,g_cch[g_cnt].gdate) RETURNING g_cch[g_cnt].ghrca04
       END IF
       SELECT hrbk05 INTO l_hrbk05  FROM hrbk_file
       WHERE  hrbk03=g_cch[g_cnt].gdate
       IF (l_hrbk05='002' AND l_hrca08='Y')
       OR (l_hrbk05='003' AND l_hrca09='Y') THEN
          LET g_cch[g_cnt].ghrca04=l_hrca10
       END IF
       SELECT hrbo03 INTO g_cch[g_cnt].ghrbo03 FROM hrbo_file WHERE hrbo02=g_cch[g_cnt].ghrca04

       IF SQLCA.sqlcode THEN
          CONTINUE FOREACH
       END IF
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
     END IF 
    LET g_rec_b=g_cnt #-1
END FUNCTION

FUNCTION q012_bp1(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_cch TO s_cch.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

      BEFORE DISPLAY
         CALL cl_navigator_setting(1,1)

      BEFORE ROW
         CALL cl_show_fld_cont()

      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY

      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON ACTION p2
         LET g_flag="p2"
         EXIT DISPLAY

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY

      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY

      ON ACTION about
         CALL cl_about()

      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION q012_bp2(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_sch TO s_sch.*

      BEFORE DISPLAY
         CALL dialog.setArrayAttributes("s_sch",g_att)

      BEFORE ROW
         CALL cl_show_fld_cont()

      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON ACTION p1
         LET g_flag="p1"
         EXIT DISPLAY

      ON ACTION cb_next
         LET g_action_choice="cb_next"
         EXIT DISPLAY

      ON ACTION cb_pre
         LET g_action_choice="cb_pre"
         EXIT DISPLAY

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY

      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY

      ON ACTION about
         CALL cl_about()
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION q012_sch_fill(p_year,p_month)
  DEFINE  p_year  LIKE type_file.num5
  DEFINE  p_month LIKE type_file.num5
  DEFINE  l_hrbk01  LIKE hrbk_file.hrbk01
  DEFINE  l_hrbk03  LIKE hrbk_file.hrbk03
  DEFINE  l_hrbk04  LIKE hrbk_file.hrbk04
  DEFINE  l_idx     LIKE type_file.num5
  DEFINE  l_first   LIKE type_file.num5
  DEFINE  l_last    LIKE type_file.num5
  DEFINE  l_n       LIKE type_file.num5
  DEFINE  l_enter   LIKE type_file.chr1

    CALL g_sch.clear()
    CALL g_att.clear()
    LET l_idx = 0
    LET l_enter = 'N'
    CASE g_hrca02
       WHEN '1' SELECT hrat03 INTO l_hrbk01 FROM hrat_file WHERE hrat01=g_str
       WHEN '2' SELECT hrao00 INTO l_hrbk01 FROM hrao_file WHERE hrao01=g_str
       WHEN '3' LET l_hrbk01=g_str
       OTHERWISE RETURN
    END CASE
    LET g_sql = "SELECT hrbk03,hrbk04 FROM hrbk_file",
                " WHERE hrbk01 = '",l_hrbk01,"' ",
                "   AND YEAR(hrbk03) = ",p_year,
                "   AND MONTH(hrbk03) = ",p_month,
                " ORDER BY hrbk03 "
    PREPARE q012_date_p FROM g_sql
    DECLARE q012_date_c CURSOR FOR q012_date_p
    FOREACH q012_date_c INTO l_hrbk03,l_hrbk04
       CASE l_hrbk04
          WHEN '7'  CALL q012_get_date(l_hrbk01,l_hrbk03) RETURNING g_sch[7*l_idx+1].sch,g_sch[7*l_idx+1].sch1,g_sch[7*l_idx+1].sch2
          WHEN '1'  CALL q012_get_date(l_hrbk01,l_hrbk03) RETURNING g_sch[7*l_idx+2].sch,g_sch[7*l_idx+2].sch1,g_sch[7*l_idx+2].sch2
          WHEN '2'  CALL q012_get_date(l_hrbk01,l_hrbk03) RETURNING g_sch[7*l_idx+3].sch,g_sch[7*l_idx+3].sch1,g_sch[7*l_idx+3].sch2
          WHEN '3'  CALL q012_get_date(l_hrbk01,l_hrbk03) RETURNING g_sch[7*l_idx+4].sch,g_sch[7*l_idx+4].sch1,g_sch[7*l_idx+4].sch2
          WHEN '4'  CALL q012_get_date(l_hrbk01,l_hrbk03) RETURNING g_sch[7*l_idx+5].sch,g_sch[7*l_idx+5].sch1,g_sch[7*l_idx+5].sch2
          WHEN '5'  CALL q012_get_date(l_hrbk01,l_hrbk03) RETURNING g_sch[7*l_idx+6].sch,g_sch[7*l_idx+6].sch1,g_sch[7*l_idx+6].sch2
          WHEN '6'  CALL q012_get_date(l_hrbk01,l_hrbk03) RETURNING g_sch[7*l_idx+7].sch,g_sch[7*l_idx+7].sch1,g_sch[7*l_idx+7].sch2
          LET l_idx = l_idx + 1
       END CASE
       LET l_enter = 'Y'
    END FOREACH

    IF l_enter = 'N' THEN
       FOR l_n = 1 TO 42
          LET g_sch[l_n].sch = ' '
       END FOR
       RETURN
    END IF
    FOR l_n = 1 TO 42
       IF NOT cl_null(g_sch[1].sch) THEN LET l_first = 1 EXIT FOR END IF
       IF cl_null(g_sch[l_n].sch) AND NOT cl_null(g_sch[l_n+1].sch) THEN
       	  LET l_first = l_n+1
       	  EXIT FOR
       END IF
    END FOR
    FOR l_n = 42 TO 1 STEP -1
       IF NOT cl_null(g_sch[42].sch) THEN LET l_last = 42 EXIT FOR END IF
       IF cl_null(g_sch[l_n].sch) AND NOT cl_null(g_sch[l_n-1].sch) THEN
       	  LET l_last = l_n-1
       	  EXIT FOR
       END IF
    END FOR
    FOR l_n = l_first-1 TO 1 STEP -1
        LET l_hrbk03 = g_sch[l_first].sch1 - (l_first-l_n)
        CALL q012_get_date(l_hrbk01,l_hrbk03) RETURNING g_sch[l_n].sch,g_sch[l_n].sch1,g_sch[l_n].sch2
    END FOR

    FOR l_n = l_last+1 TO 42
         LET l_hrbk03 = g_sch[l_last].sch1 + l_n - l_last
         CALL q012_get_date(l_hrbk01,l_hrbk03) RETURNING g_sch[l_n].sch,g_sch[l_n].sch1,g_sch[l_n].sch2
    END FOR

    FOR l_n = 1 TO 42
        IF MONTH(g_sch[l_n].sch1) != p_month THEN
           LET g_att[l_n].sch = 'gray'
            CONTINUE FOR
        END IF
        CASE g_sch[l_n].sch2
           WHEN '001'
              LET g_att[l_n].sch = ""
           WHEN '002'
              LET g_att[l_n].sch = "yellow reverse"
           WHEN '003'
              LET g_att[l_n].sch = "red reverse"
           OTHERWISE
              LET g_att[l_n].sch = ""
        END CASE
    END FOR

END FUNCTION

FUNCTION q012_get_date(p_hrbk01,p_hrbk03)
  DEFINE p_hrbk01  LIKE hrbk_file.hrbk01
  DEFINE p_hrbk03  LIKE hrbk_file.hrbk03
  DEFINE l_hrbk    RECORD LIKE hrbk_file.*
  DEFINE l_day     LIKE type_file.num5
  DEFINE l_str     STRING
  DEFINE l_hrbo02  LIKE hrbo_file.hrbo02
  DEFINE l_hrbo03  LIKE hrbo_file.hrbo03
  DEFINE l_hrcp06  LIKE hrcp_file.hrcp06
  DEFINE l_hrca05  LIKE hrca_file.hrca05
  DEFINE l_hrca06  LIKE hrca_file.hrca06
  DEFINE l_hrca11  LIKE hrca_file.hrca11

   INITIALIZE l_hrbk.* TO NULL
   LET l_hrcp06=''
   LET l_hrbo02=''
   LET l_hrbo03=''
   SELECT * INTO l_hrbk.* FROM hrbk_file
    WHERE hrbk01 = p_hrbk01
      AND hrbk03 = p_hrbk03
   LET l_day = DAY(l_hrbk.hrbk03)
   LET l_str = l_day USING '#####'
   CASE g_hrca02
      WHEN '1'
        SELECT hrcp04,hrcp06 INTO l_hrbo02,l_hrcp06 FROM hrat_file,hrcp_file
         WHERE hratid = hrcp02
           AND hrcp03 = p_hrbk03
           AND hrat01 = g_str
        IF STATUS=100 THEN
           SELECT hrdq06,hrbo03,'',hrdq05 INTO l_hrbo02,l_hrca05,l_hrca06,l_hrca11
             FROM hrdq_file
             LEFT JOIN hrat_file ON hratId = hrdq03
             LEFT JOIN hrbo_file ON hrbo02 = hrdq06
            WHERE hrdq05 = p_hrbk03
              AND hrdq05 = p_hrbk03
              AND hrat01 = g_str
              AND hrdq02 = '1'
           IF cl_null(l_hrbo02) THEN
	          CALL q012_get_hrca04(l_hrca05,l_hrca06,l_hrca11,p_hrbk03) RETURNING l_hrbo02
           END IF
        END IF
        IF STATUS=100 THEN
           SELECT hrdq06,hrbo03,'',hrdq05 INTO l_hrbo02,l_hrca05,l_hrca06,l_hrca11
             FROM hrdq_file
             LEFT JOIN hrbo_file ON hrbo02 = hrdq06
            WHERE hrdq05 = p_hrbk03
              AND hrdq05 = p_hrbk03
              AND hrdq03 = g_str
              AND hrdq02 = '4'
           IF cl_null(l_hrbo02) THEN
	          CALL q012_get_hrca04(l_hrca05,l_hrca06,l_hrca11,p_hrbk03) RETURNING l_hrbo02
           END IF
        END IF
        IF STATUS=100 THEN
           SELECT hrdq06,hrbo03,'',hrdq05 INTO l_hrbo02,l_hrca05,l_hrca06,l_hrca11
             FROM hrdq_file
             LEFT JOIN hrbo_file ON hrbo02 = hrdq06
            WHERE hrdq05 = p_hrbk03
              AND hrdq05 = p_hrbk03
              AND hrdq03 = g_str
              AND hrdq02 = '2'
           IF cl_null(l_hrbo02) THEN
	          CALL q012_get_hrca04(l_hrca05,l_hrca06,l_hrca11,p_hrbk03) RETURNING l_hrbo02
           END IF
        END IF
        IF STATUS=100 THEN
           SELECT hrdq06,hrbo03,'',hrdq05 INTO l_hrbo02,l_hrca05,l_hrca06,l_hrca11
             FROM hrdq_file
             LEFT JOIN hrbo_file ON hrbo02 = hrdq06
            WHERE hrdq05 = p_hrbk03
              AND hrdq05 = p_hrbk03
              AND hrdq03 = g_str
              AND hrdq02 = '3'
          IF cl_null(l_hrbo02) THEN
             CALL q012_get_hrca04(l_hrca05,l_hrca06,l_hrca11,p_hrbk03) RETURNING l_hrbo02
          END IF
        END IF
      WHEN '2'
           SELECT hrdq06,hrbo03,'',hrdq05 INTO l_hrbo02,l_hrca05,l_hrca06,l_hrca11
             FROM hrdq_file
             LEFT JOIN hrbo_file ON hrbo02 = hrdq06
            WHERE hrdq05 = p_hrbk03
              AND hrdq05 = p_hrbk03
              AND hrdq03 = g_str
              AND hrdq02 = '2'
        IF cl_null(l_hrbo02) THEN
           CALL q012_get_hrca04(l_hrca05,l_hrca06,l_hrca11,p_hrbk03) RETURNING l_hrbo02
        END IF
        IF STATUS=100 THEN
           SELECT hrdq06,hrbo03,'',hrdq05 INTO l_hrbo02,l_hrca05,l_hrca06,l_hrca11
             FROM hrdq_file
             LEFT JOIN hrbo_file ON hrbo02 = hrdq06
            WHERE hrdq05 = p_hrbk03
              AND hrdq05 = p_hrbk03
              AND hrdq03 = g_str
              AND hrdq02 = '3'
           IF cl_null(l_hrbo02) THEN
	          CALL q012_get_hrca04(l_hrca05,l_hrca06,l_hrca11,p_hrbk03) RETURNING l_hrbo02
           END IF
        END IF
      WHEN '3'
           SELECT hrdq06,hrbo03,'',hrdq05 INTO l_hrbo02,l_hrca05,l_hrca06,l_hrca11
             FROM hrdq_file
             LEFT JOIN hrbo_file ON hrbo02 = hrdq06
            WHERE hrdq05 = p_hrbk03
              AND hrdq05 = p_hrbk03
              AND hrdq03 = g_str
              AND hrdq02 = '3'
	    IF cl_null(l_hrbo02) THEN
           CALL q012_get_hrca04(l_hrca05,l_hrca06,l_hrca11,p_hrbk03) RETURNING l_hrbo02
        END IF
      WHEN '4'
           SELECT hrdq06,hrbo03,'',hrdq05 INTO l_hrbo02,l_hrca05,l_hrca06,l_hrca11
             FROM hrdq_file
             LEFT JOIN hrbo_file ON hrbo02 = hrdq06
            WHERE hrdq05 = p_hrbk03
              AND hrdq05 = p_hrbk03
              AND hrdq03 = g_str
              AND hrdq02 = '4'
	    IF cl_null(l_hrbo02) THEN
           CALL q012_get_hrca04(l_hrca05,l_hrca06,l_hrca11,p_hrbk03) RETURNING l_hrbo02
        END IF
      END CASE
      SELECT hrbo03 INTO l_hrbo03 FROM hrbo_file WHERE hrbo02=l_hrbo02
      IF NOT cl_null(l_hrbo03) THEN
         LET l_str=l_str||'\n'||l_hrbo03
      END IF
      IF NOT cl_null(l_hrcp06) THEN
         LET l_str=l_str||'\n'||l_hrcp06
      END IF
   RETURN l_str,l_hrbk.hrbk03,l_hrbk.hrbk05
END FUNCTION

FUNCTION q012_cb(p_step)
 DEFINE p_step   LIKE  type_file.num5
 DEFINE l_year   LIKE  type_file.num5
 DEFINE l_month  LIKE  type_file.num5

   LET g_head.cb1 = g_head.cb1
   LET g_head.cb2 = g_head.cb2 + p_step
   LET l_year = g_head.cb1+g_head.cb2/12
   LET l_month = g_head.cb2 MOD 12
   IF l_month=0 THEN
      LET l_year = l_year-1
      LET g_head.cb1 = l_year
      LET l_month = 12
      LET g_head.cb2 = l_month
   END IF
   LET g_head.cb_name = l_year||'年'||l_month||'月'
   DISPLAY g_head.cb_name TO cb_name
   CALL q012_sch_fill(l_year,l_month)
END FUNCTION

FUNCTION q012_get_hrca04(p_hrca05,p_hrca06,p_hrca11,p_hrdq05)
DEFINE p_hrdq05  LIKE hrdq_file.hrdq05
DEFINE p_hrca06  LIKE hrca_file.hrca06
DEFINE p_hrca11  LIKE hrca_file.hrca11
DEFINE p_hrca05  LIKE hrca_file.hrca05
DEFINE l_hrbp05  LIKE hrbp_file.hrbp05
DEFINE p_hrdq06  LIKE hrdq_file.hrdq06
DEFINE p_hrdq09  LIKE hrdq_file.hrdq09
DEFINE l_hrbpa01 LIKE hrbpa_file.hrbpa01
DEFINE l_minus   LIKE type_file.num5
DEFINE l_count   LIKE type_file.num5
DEFINE l_i       LIKE type_file.num5

    SELECT hrbp05 INTO l_hrbp05 FROM hrbp_file WHERE hrbp02=p_hrca05
    IF l_hrbp05='1' THEN
       SELECT count(*) INTO l_count FROM hrbpa_file WHERE hrbpa05=p_hrca05
       SELECT hrbpa01 INTO l_hrbpa01 FROM hrbpa_file WHERE hrbpa05=p_hrca05 AND hrbpa02=p_hrca06
       LET l_minus=p_hrdq05-p_hrca11
       SELECT MOD(l_minus,l_count) INTO l_i FROM dual
       LET l_hrbpa01=l_hrbpa01+l_i
       SELECT MOD(l_hrbpa01,l_count) INTO l_i FROM dual
       IF l_i=0 THEN
          LET l_i=l_count
       END IF
       SELECT hrbpa02 INTO p_hrdq06 FROM hrbpa_file WHERE hrbpa05=p_hrca05 AND hrbpa01=l_i
    ELSE
       SELECT count(*) INTO l_count FROM hrbpa_file WHERE hrbpa05=p_hrca05
       SELECT hrbpa01 INTO l_hrbpa01 FROM hrbpa_file WHERE hrbpa05=p_hrca05 AND hrbpa02=p_hrca06
       LET l_minus=p_hrdq05-p_hrca11
       SELECT MOD(l_minus,l_count) INTO l_i FROM dual
       LET l_hrbpa01=l_hrbpa01+l_i
       SELECT MOD(l_hrbpa01,l_count) INTO l_i FROM dual
       IF l_i=0 THEN
          LET l_i=l_count
       END IF
       SELECT hrbpa02 INTO p_hrdq09
         FROM hrbpa_file WHERE hrbpa05=p_hrca05 AND hrbpa01=l_i
       SELECT hrbza02 INTO p_hrdq06 FROM hrbza_file
        WHERE hrbza05=p_hrdq09 AND hrbza01=1
    END IF

    RETURN p_hrdq06
END FUNCTION
