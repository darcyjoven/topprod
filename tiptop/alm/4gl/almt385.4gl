# Prog. Version..: '5.30.06-13.04.09(00004)'     #
#
# Pattern name...: almt385.4gl
# Descriptions...: 商戶終止申請作業
# Date & Author..: NO.FUN-BA0118 11/11/02 By nanbing
# Modify.........: No.CHI-C30107 12/06/11 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No.FUN-C80006 12/08/06 By xumeimei更改費用的計算寫法
# Modify.........: No.FUN-CB0076 12/12/06 By xumeimei 添加GR打印功能
# Modify.........: No.CHI-D20015 13/04/02 By chenjing 統一確認和取消確認時確認人員和確認日期的寫法

DATABASE ds
GLOBALS "../../config/top.global"

DEFINE   g_lje     RECORD LIKE lje_file.*      
DEFINE   g_lje_t   RECORD LIKE lje_file.*   
DEFINE   g_ljg     DYNAMIC ARRAY OF RECORD
                   ljg02      LIKE ljg_file.ljg02, 
                   ljg03      LIKE ljg_file.ljg03,
                   oaj02      LIKE oaj_file.oaj02,
                   oaj05      LIKE oaj_file.oaj05,    
                   ljg04      LIKE ljg_file.ljg04
                   END RECORD
DEFINE   g_ljg_t  RECORD
                   ljg02      LIKE ljg_file.ljg02, 
                   ljg03      LIKE ljg_file.ljg03, 
                   oaj02      LIKE oaj_file.oaj02,
                   oaj05      LIKE oaj_file.oaj05,                       
                   ljg04      LIKE ljg_file.ljg04
                   END RECORD
DEFINE   g_ljh    DYNAMIC ARRAY OF RECORD
                   ljh02      LIKE ljh_file.ljh02,    
                   ljh03      LIKE ljh_file.ljh03, 
                   oaj02      LIKE oaj_file.oaj02,
                   oaj05      LIKE oaj_file.oaj05,                       
                   ljh04      LIKE ljh_file.ljh04
                   END RECORD
DEFINE   g_ljh_t   RECORD
                   ljh02      LIKE ljh_file.ljh02,    
                   ljh03      LIKE ljh_file.ljh03, 
                   oaj02      LIKE oaj_file.oaj02,
                   oaj05      LIKE oaj_file.oaj05,                       
                   ljh04      LIKE ljh_file.ljh04
                   END RECORD                   
DEFINE   g_ljf     DYNAMIC ARRAY OF RECORD
                   ljf02      LIKE ljf_file.ljf02, 
                   ljf03      LIKE ljf_file.ljf03,
                   oaj02      LIKE oaj_file.oaj02,
                   oaj05      LIKE oaj_file.oaj05,    
                   ljf04      LIKE ljf_file.ljf04,
                   ljf05      LIKE ljf_file.ljf05,
                   ljf06      LIKE ljf_file.ljf06
                   END RECORD
DEFINE   g_ljf_t   RECORD
                   ljf02      LIKE ljf_file.ljf02, 
                   ljf03      LIKE ljf_file.ljf03,
                   oaj02      LIKE oaj_file.oaj02,
                   oaj05      LIKE oaj_file.oaj05,    
                   ljf04      LIKE ljf_file.ljf04,
                   ljf05      LIKE ljf_file.ljf05,
                   ljf06      LIKE ljf_file.ljf06
                   END RECORD                   
DEFINE   g_rec_b1  LIKE type_file.num5
DEFINE   g_rec_b2  LIKE type_file.num5
DEFINE   g_rec_b3  LIKE type_file.num5
DEFINE   g_wc,g_wc2,g_wc3       STRING
DEFINE   g_sql                STRING
DEFINE   g_forupd_sql        STRING
DEFINE   g_chr                LIKE type_file.chr1     
DEFINE   g_cnt                LIKE type_file.num10    
DEFINE   g_i                  LIKE type_file.num5     
DEFINE   g_msg                LIKE ze_file.ze03       
DEFINE   g_before_input_done  LIKE type_file.num5
DEFINE   g_row_count          LIKE type_file.num10
DEFINE   g_curs_index         LIKE type_file.num10
DEFINE   g_jump               LIKE type_file.num10
DEFINE   g_no_ask             LIKE type_file.num5  
DEFINE   g_confirm            LIKE type_file.chr1
DEFINE   g_void               LIKE type_file.chr1    
DEFINE   g_t1                 LIKE oay_file.oayslip
DEFINE   li_result            LIKE type_file.num5
DEFINE   g_lje01_t            LIKE lje_file.lje01
DEFINE   g_flag_b             LIKE type_file.chr1
DEFINE   l_ac1,l_ac2,l_ac     LIKE type_file.num5
DEFINE   g_time               LIKE lje_file.ljecont
DEFINE   g_lla04              LIKE lla_file.lla04
#FUN-CB0076----add---str
DEFINE   l_table        STRING
DEFINE   l_table1       STRING
DEFINE   l_table2       STRING
DEFINE   l_table3       STRING
TYPE     sr1_t          RECORD
         ljeplant       LIKE lje_file.ljeplant,
         lje01          LIKE lje_file.lje01,
         lje02          LIKE lje_file.lje02,
         lje04          LIKE lje_file.lje04,
         lje05          LIKE lje_file.lje05,
         lje06          LIKE lje_file.lje06,
         lje07          LIKE lje_file.lje07,
         lje10          LIKE lje_file.lje10,
         lje11          LIKE lje_file.lje11,
         lje12          LIKE lje_file.lje12,
         lje13          LIKE lje_file.lje13,
         lje14          LIKE lje_file.lje14,
         lje15          LIKE lje_file.lje15,
         lje16          LIKE lje_file.lje16,
         lje17          LIKE lje_file.lje17,
         lje18          LIKE lje_file.lje18,
         lje19          LIKE lje_file.lje19,
         lje20          LIKE lje_file.lje20,
         lje21          LIKE lje_file.lje21,
         lje22          LIKE lje_file.lje22,
         lje23          LIKE lje_file.lje23,
         lje26          LIKE lje_file.lje26,
         sign_type      LIKE type_file.chr1,
         sign_img       LIKE type_file.blob,
         sign_show      LIKE type_file.chr1,
         sign_str       LIKE type_file.chr1000,
         rtz13          LIKE rtz_file.rtz13,
         lne05          LIKE lne_file.lne05,
         gen02          LIKE gen_file.gen02,
         lmf13          LIKE lmf_file.lmf13,
         lnt60          LIKE lnt_file.lnt60,
         lnt10          LIKE lnt_file.lnt10,
         lnt33          LIKE lnt_file.lnt33
                        END RECORD
TYPE     sr2_t          RECORD
         ljg02          LIKE ljg_file.ljg02, 
         ljg03          LIKE ljg_file.ljg03,
         oaj02          LIKE oaj_file.oaj02,
         oaj05          LIKE oaj_file.oaj05,    
         ljg04          LIKE ljg_file.ljg04
                        END RECORD
TYPE     sr3_t          RECORD
         ljh02          LIKE ljh_file.ljh02,    
         ljh03          LIKE ljh_file.ljh03, 
         oaj02          LIKE oaj_file.oaj02,
         oaj05          LIKE oaj_file.oaj05,                       
         ljh04          LIKE ljh_file.ljh04
                        END RECORD
TYPE     sr4_t          RECORD
         ljf02          LIKE ljf_file.ljf02, 
         ljf03          LIKE ljf_file.ljf03,
         oaj02          LIKE oaj_file.oaj02,
         oaj05          LIKE oaj_file.oaj05,    
         ljf04          LIKE ljf_file.ljf04,
         ljf05          LIKE ljf_file.ljf05,
         ljf06          LIKE ljf_file.ljf06
                        END RECORD
#FUN-CB0076----add---end
MAIN 
 
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ALM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
   #FUN-CB0076----add---str
   LET g_pdate = g_today
   LET g_sql ="ljeplant.lje_file.ljeplant,",
              "lje01.lje_file.lje01,",
              "lje02.lje_file.lje02,",
              "lje04.lje_file.lje04,",
              "lje05.lje_file.lje05,",
              "lje06.lje_file.lje06,",
              "lje07.lje_file.lje07,",
              "lje10.lje_file.lje10,",
              "lje11.lje_file.lje11,",
              "lje12.lje_file.lje12,",
              "lje13.lje_file.lje13,",
              "lje14.lje_file.lje14,",
              "lje15.lje_file.lje15,",
              "lje16.lje_file.lje16,",
              "lje17.lje_file.lje17,",
              "lje18.lje_file.lje18,",
              "lje19.lje_file.lje19,",
              "lje20.lje_file.lje20,",
              "lje21.lje_file.lje21,",
              "lje22.lje_file.lje22,",
              "lje23.lje_file.lje23,",
              "lje26.lje_file.lje26,",
              "sign_type.type_file.chr1,",
              "sign_img.type_file.blob,",
              "sign_show.type_file.chr1,",
              "sign_str.type_file.chr1000,",
              "rtz13.rtz_file.rtz13,",
              "lne05.lne_file.lne05,",
              "gen02.gen_file.gen02,",
              "lmf13.lmf_file.lmf13,",
              "lnt60.lnt_file.lnt60,",
              "lnt10.lnt_file.lnt10,",
              "lnt33.lnt_file.lnt33"
   LET l_table = cl_prt_temptable('almt385',g_sql) CLIPPED
   IF l_table = -1 THEN
      CALL cl_used(g_prog, g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3)
      EXIT PROGRAM
   END IF
   LET g_sql ="ljg02.ljg_file.ljg02,", 
              "ljg03.ljg_file.ljg03,",
              "oaj02.oaj_file.oaj02,",
              "oaj05.oaj_file.oaj05,",  
              "ljg04.ljg_file.ljg04"
   LET l_table1 = cl_prt_temptable('almt3851',g_sql) CLIPPED
   IF l_table1 = -1 THEN
      CALL cl_used(g_prog, g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3)
      EXIT PROGRAM
   END IF
   LET g_sql ="ljh02.ljh_file.ljh02,",    
              "ljh03.ljh_file.ljh03,",
              "oaj02.oaj_file.oaj02,",
              "oaj05.oaj_file.oaj05,",                       
              "ljh04.ljh_file.ljh04"
   LET l_table2 = cl_prt_temptable('almt3852',g_sql) CLIPPED
   IF l_table2 = -1 THEN
      CALL cl_used(g_prog, g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3)
      EXIT PROGRAM
   END IF
   LET g_sql ="ljf02.ljf_file.ljf02,", 
              "ljf03.ljf_file.ljf03,",
              "oaj02.oaj_file.oaj02,",
              "oaj05.oaj_file.oaj05,",  
              "ljf04.ljf_file.ljf04,",
              "ljf05.ljf_file.ljf05,",
              "ljf06.ljf_file.ljf06"
   LET l_table3 = cl_prt_temptable('almt3853',g_sql) CLIPPED
   IF l_table3 = -1 THEN
      CALL cl_used(g_prog, g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3)
      EXIT PROGRAM
   END IF
   #FUN-CB0076------add-----end 
   LET g_forupd_sql= " SELECT * FROM lje_file WHERE lje01 = ? FOR UPDATE  "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t385_cl CURSOR FROM g_forupd_sql
 
   OPEN WINDOW t385_w  WITH FORM "alm/42f/almt385"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
   SELECT lla04 INTO g_lla04 FROM lla_file
    WHERE llastore = g_plant
   CALL t385_menu()
 
   CLOSE WINDOW t385_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
   CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3)    #FUN-CB0076 add
END MAIN
FUNCTION t385_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01
   CLEAR FORM
   CALL g_ljg.clear()
   CALL g_ljh.clear()
   LET g_action_choice=" " 
   CALL cl_set_head_visible("","YES")
   INITIALIZE g_lje.* TO NULL
   DIALOG ATTRIBUTES(UNBUFFERED) 
      CONSTRUCT BY NAME g_wc ON
                lje01,lje02,lje03,ljeplant,ljelegal,lje04,lje05,lje06,lje07,lje08,
                lje09,lje10,lje11,lje12,lje13,lje14,lje18,lje19,lje20,lje21,
                lje15,lje16,lje17,lje22,lje23,lje24,ljemksg,lje25,ljeconf,ljeconu,ljecond,
                lje26,ljeuser,ljegrup,ljeoriu,ljemodu,ljedate,ljeorig,ljeacti,ljecrat     
      
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
      
         ON ACTION controlp
            CASE
            
               WHEN INFIELD(lje01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_lje01"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lje01
                  NEXT FIELD lje01
            
               WHEN INFIELD(ljeplant)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_ljeplant"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ljeplant
                  NEXT FIELD ljeplant
               WHEN INFIELD(ljelegal)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_ljelegal"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ljelegal
                  NEXT FIELD ljelegal                  
               WHEN INFIELD(lje04)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_lje04"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lje04
                  NEXT FIELD lje04
               WHEN INFIELD(lje05)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_lje05"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lje05
                  NEXT FIELD lje05
               WHEN INFIELD(lje06)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_lje06"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lje06
                  NEXT FIELD lje06                  
               WHEN INFIELD(lje07)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_lje07"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lje07
                  NEXT FIELD lje07 
               WHEN INFIELD(lje08)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_lje08"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lje08
                  NEXT FIELD lje08    
                
               WHEN INFIELD(lje21)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_lje21"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lje21
                  NEXT FIELD lje21
 
               WHEN INFIELD(lje23)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_lje23"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lje23
                  NEXT FIELD lje23  
               WHEN INFIELD(lje24)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_lje24"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lje24
                  NEXT FIELD lje24     
                    
               WHEN INFIELD(ljeconu)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_ljeconu"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ljeconu
                  NEXT FIELD ljeconu   
               OTHERWISE EXIT CASE
            END CASE
      END CONSTRUCT
      CONSTRUCT g_wc2 ON ljg02,ljg03,ljg04
         FROM s_ljg[1].ljg02,s_ljg[1].ljg03,s_ljg[1].ljg04
                
         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
         ON ACTION controlp
            CASE 
               WHEN INFIELD(ljg03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_ljg03"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ljg03
                  NEXT FIELD ljg03
               OTHERWISE EXIT CASE
            END CASE
      
       END CONSTRUCT

       CONSTRUCT g_wc3 ON ljh02,ljh03,ljh04
          FROM s_ljh[1].ljh02,s_ljh[1].ljh03,s_ljh[1].ljh04
             
          BEFORE CONSTRUCT
             CALL cl_qbe_display_condition(lc_qbe_sn)
          ON ACTION controlp
             CASE 
                WHEN INFIELD(ljh03)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form = "q_ljh03"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ljh03
                   NEXT FIELD ljh03
                   OTHERWISE EXIT CASE
             END CASE
      
       END CONSTRUCT
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE DIALOG
       ON ACTION about
          CALL cl_about()
     
       ON ACTION HELP
          CALL cl_show_help()
     
       ON ACTION controlg
          CALL cl_cmdask()
       ON ACTION EXIT
          LET g_action_choice="exit"
          EXIT DIALOG
       ON ACTION accept
          ACCEPT DIALOG
       ON ACTION cancel
          LET INT_FLAG = 1
          EXIT DIALOG     
       ON ACTION qbe_select
          CALL cl_qbe_list() RETURNING lc_qbe_sn
          CALL cl_qbe_display_condition(lc_qbe_sn)
 
   END DIALOG
      IF INT_FLAG THEN
         RETURN
      END IF
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond('ljeuser', 'ljegrup') 
      LET g_wc = g_wc CLIPPED," AND ljeplant IN ",g_auth 
      IF g_wc2 = " 1=1" AND g_wc3 = " 1=1" THEN
         LET g_sql = "SELECT lje01 FROM lje_file ",
                     " WHERE ", g_wc CLIPPED,
                     " ORDER BY lje01"
      END IF 
      IF g_wc2 <> " 1=1" AND g_wc3 = " 1=1" THEN  
         LET g_sql = "SELECT UNIQUE lje01 ",
                     " FROM lje_file, ljg_file ",
                     " WHERE lje01 = ljg01",
                     "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                     " ORDER BY lje01"
      END IF                
      IF g_wc3 <> " 1=1" AND g_wc2 = " 1=1" THEN
         LET g_sql = "SELECT UNIQUE lje01 ",
                     " FROM lje_file, ljh_file ",
                     " WHERE lje01 = ljh01",
                     "   AND ", g_wc CLIPPED, " AND ",g_wc3 CLIPPED,
                     " ORDER BY lje01"                         
      END IF 
      IF g_wc3 <> " 1=1" AND g_wc2 <> " 1=1" THEN
         LET g_sql = "SELECT UNIQUE lje01 ",
                     " FROM lje_file, ljg_file, ljh_file ",
                     " WHERE lje01 = ljg01 AND lje01 = ljh01 AND ljg01 = ljh01",
                     "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED, " AND ",g_wc3 CLIPPED,
                     " ORDER BY lje01"     
      END IF

   PREPARE t385_prepare FROM g_sql
   DECLARE t385_cs
      SCROLL CURSOR WITH HOLD FOR t385_prepare
   IF g_wc2 = " 1=1" AND g_wc3 = " 1=1" THEN
      LET g_sql="SELECT COUNT(*) FROM lje_file WHERE ",g_wc CLIPPED
   ELSE
      IF g_wc2 <> " 1=1" AND g_wc3 = " 1=1" THEN  
         LET g_sql="SELECT COUNT(DISTINCT lje01)",
                   " FROM lje_file ,ljg_file WHERE ",
                   " ljg01=lje01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
      END IF
      IF g_wc3 <> " 1=1" AND g_wc2 = " 1=1" THEN  
         LET g_sql="SELECT COUNT(DISTINCT lje01)",
                   " FROM lje_file,ljh_file WHERE ",
                   " ljh01=lje01 AND ",g_wc CLIPPED," AND ",g_wc3 CLIPPED
      END IF
      IF g_wc3 <> " 1=1" AND g_wc2 <> " 1=1" THEN
         LET g_sql = "SELECT COUNT(DISTINCT lje01)",
                     " FROM lje_file, ljg_file, ljh_file ",
                     " WHERE lje01 = ljg01 AND lje01 = ljh01 AND ljg01 = ljh01",
                     "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED, " AND ",g_wc3 CLIPPED,
                     " ORDER BY lje01"     
      END IF      
   END IF
   PREPARE t385_precount FROM g_sql
   DECLARE t385_count CURSOR FOR t385_precount

END FUNCTION
 
FUNCTION t385_menu()

   WHILE TRUE
      CALL t385_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t385_a()
            END IF

         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t385_q()
            END IF

         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t385_r()
            END IF

         #FUN-CB0076------add----str
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL t385_out()
            END IF
         #FUN-CB0076------add----end
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL t385_x()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t385_u()
            END IF
         WHEN "fund"
            IF cl_chk_act_auth() THEN
               CALL t385_end("f")
            END IF
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t385_confirm()
            END IF

         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t385_undoconfirm()
            END IF
         WHEN "help"
            CALL cl_show_help()

         WHEN "exit"
            EXIT WHILE

         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"   
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ljg),base.TypeInfo.create(g_ljh),'')
            END IF   
         WHEN "related_document"
              IF cl_chk_act_auth() THEN
                 IF g_lje.lje01 IS NOT NULL THEN
                 LET g_doc.column1 = "lje01"
                 LET g_doc.value1 = g_lje.lje01
                 CALL cl_doc()
               END IF
         END IF

      END CASE
   END WHILE
END FUNCTION

FUNCTION t385_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DIALOG ATTRIBUTES(UNBUFFERED)
      DISPLAY ARRAY g_ljg TO s_ljg.* ATTRIBUTE(COUNT=g_rec_b1)

        BEFORE DISPLAY
          CALL cl_navigator_setting( g_curs_index, g_row_count )

        BEFORE ROW
          LET l_ac1 = ARR_CURR()
           DISPLAY g_rec_b1 TO FORMONLY.cn1
          CALL cl_show_fld_cont()
      END DISPLAY  

      DISPLAY ARRAY g_ljh TO s_ljh.* ATTRIBUTE(COUNT=g_rec_b2)

        BEFORE DISPLAY
          CALL cl_navigator_setting( g_curs_index, g_row_count )

        BEFORE ROW
          LET l_ac2 = ARR_CURR()
           DISPLAY g_rec_b2 TO FORMONLY.cn1
          CALL cl_show_fld_cont()          
      END DISPLAY  

      ON ACTION INSERT
         LET g_action_choice="insert"
         EXIT DIALOG

      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG 

      ON ACTION DELETE
         LET g_action_choice="delete"
         EXIT DIALOG 
      
      #FUN-CB0076------add-----str
      ON ACTION OUTPUT
         LET g_action_choice="output"
         EXIT DIALOG 
      #FUN-CB0076------add-----end   
      ON ACTION MODIFY
         LET g_action_choice="modify"
         EXIT DIALOG
      ON ACTION FIRST
         CALL t385_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG 

      ON ACTION PREVIOUS
         CALL t385_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG 

      ON ACTION jump
         CALL t385_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG 

      ON ACTION NEXT
         CALL t385_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG 

      ON ACTION LAST
         CALL t385_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG 

      ON ACTION fund
         LET g_action_choice="fund"
         EXIT DIALOG 
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DIALOG 

      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DIALOG 

      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DIALOG 
    #  ON ACTION change_export
    #     LET g_action_choice="change_export"
    #     EXIT DIALOG 
      ON ACTION exporttoexcel 
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG 

      ON ACTION HELP
         LET g_action_choice="help"
         EXIT DIALOG 

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()

      ON ACTION EXIT
         LET g_action_choice="exit"
         EXIT DIALOG 

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG 


      ON ACTION CANCEL
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DIALOG 

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG 

      ON ACTION about
         CALL cl_about()


      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")

      ON ACTION related_document
         LET g_action_choice="related_document"
         EXIT DIALOG 
   END DIALOG 
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
FUNCTION t385_a()
DEFINE li_result   LIKE type_file.num5
DEFINE l_n         LIKE type_file.num5
 
   IF s_shut(0) THEN RETURN END IF
   MESSAGE ""
   CLEAR FORM
 
   CALL g_ljg.clear()
   CALL g_ljh.clear()
   INITIALIZE g_lje.* LIKE lje_file.*
   LET g_lje01_t = NULL
   LET g_lje_t.* = g_lje.*
   CALL cl_opmsg('a')
   WHILE TRUE
       LET g_lje.lje02 = g_today
       LET g_lje.ljeplant = g_plant
       LET g_lje.ljelegal = g_legal
       LET g_lje.ljeconf = 'N'
       LET g_lje.lje23 = g_user
       LET g_lje.lje24 = g_grup
       LET g_lje.lje25 = '0'
       LET g_lje.ljeuser = g_user
       LET g_lje.ljeoriu = g_user 
       LET g_lje.ljeorig = g_grup 
       LET g_lje.ljegrup = g_grup
       LET g_lje.ljemodu = ''
       LET g_lje.ljemksg = 'N'
       LET g_lje.ljedate = g_today 
       LET g_lje.ljeacti = 'Y'
       LET g_lje.ljecrat = g_today
       CALL t385_i("a")
       IF INT_FLAG THEN
           LET INT_FLAG = 0
           CALL cl_err('',9001,0)
           CLEAR FORM
           CALL g_ljg.clear()
           CALL g_ljh.clear()
           EXIT WHILE
       END IF
       IF g_lje.lje01 IS NULL OR g_lje.ljeplant IS NULL THEN
          CONTINUE WHILE
       END IF
       BEGIN WORK
       CALL s_auto_assign_no("alm",g_lje.lje01,g_today,"P8","lje_file","lje01","","","")
          RETURNING li_result,g_lje.lje01
       IF (NOT li_result) THEN                                                                           
           CONTINUE WHILE                                                                     
       END IF
       DISPLAY BY NAME g_lje.lje01
       
       INSERT INTO lje_file VALUES(g_lje.*)     
       IF SQLCA.SQLCODE OR SQLCA.sqlerrd[3]=0 THEN
          CALL cl_err3("ins","lje_file",g_lje.lje01,"",SQLCA.SQLCODE,"","",1)
          ROLLBACK WORK
          CONTINUE WHILE
       ELSE
          COMMIT WORK
       END IF
       LET g_rec_b1=0
       LET g_rec_b2=0
       CALL t385_end("a")
       CALL t385_delall()
       EXIT WHILE
   END WHILE
END FUNCTION
FUNCTION t385_end(p_cmd)
DEFINE l_n   LIKE type_file.num5,
       p_cmd LIKE type_file.chr1
   IF cl_null(g_lje.lje01) OR cl_null(g_lje.ljeplant) THEN
      CALL cl_err('',-400,1)
      RETURN
   END IF
   IF s_shut(0) THEN RETURN END IF
   
   IF g_lje.ljeplant <> g_plant THEN
         CALL cl_err('','alm-708',0)
         RETURN
   END IF
   LET g_success = 'Y'
   BEGIN WORK
   CALL s_showmsg_init()
   OPEN t385_cl USING g_lje.lje01
   IF STATUS THEN
      #CALL cl_err("OPEN t385_cl:",STATUS,0)
      LET g_success = 'N'
      CALL s_errmsg('','','OPEN t385_cl:',STATUS,1)
      CLOSE t385_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t385_cl INTO g_lje.*
   IF SQLCA.sqlcode THEN
      #CALL cl_err(g_lje.lje01,SQLCA.sqlcode,0)
      LET g_success = 'N'
      CALL s_errmsg('lje01',g_lje.lje01,'',SQLCA.sqlcode,1)
      CLOSE t385_cl
      ROLLBACK WORK
      RETURN
   END IF
   IF p_cmd = 'f' THEN 
      LET g_lje_t.lje14 = g_lje.lje14
   END IF    
   IF p_cmd = 'u' AND g_lje_t.lje14 <> g_lje.lje14 THEN 
      DELETE FROM ljf_file WHERE ljf01 = g_lje.lje01 AND ljfplant = g_plant
   END IF 
   IF p_cmd = 'a' OR (p_cmd = 'u' AND g_lje_t.lje14 <> g_lje.lje14) THEN    
      CALL t385_insljf() 
   END IF 
   OPEN WINDOW t385_w1 WITH FORM "alm/42f/almt385_1"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_locale("almt385_1")
  
   CALL t385_ljf_fill()
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ljf TO s_ljf.* ATTRIBUTE(COUNT=g_rec_b3)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         IF g_lje.ljeconf <> 'Y' THEN  
            EXIT DISPLAY 
         END IF
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()
      ON ACTION ACCEPT 
         CONTINUE DISPLAY 
         
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
   IF g_lje.ljeconf <> 'Y' THEN
      CALL t385_choose()
      IF g_success = 'N' THEN 
         ROLLBACK WORK 
      END IF
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CALL t385_delall()
         #CALL cl_err('',9001,0)
         CLOSE WINDOW t385_w1
         #CLEAR FORM
         CLOSE t385_cl
         COMMIT WORK
      ELSE
         CLOSE WINDOW t385_w1
         #填充已付款和應扣款
         DELETE FROM ljg_file WHERE ljg01 = g_lje.lje01 AND ljgplant = g_plant
         DELETE FROM ljh_file WHERE ljh01 = g_lje.lje01 AND ljhplant = g_plant
         CALL t385_b_data1() 
         CALL t385_b_data2()   
         CALL t385_b1_fill(" 1=1")
         CALL t385_b2_fill(" 1=1")
         CLOSE t385_cl
         IF g_success = 'Y' THEN 
            COMMIT  WORK 
         ELSE    
            CALL s_showmsg()
            CALL cl_err('','abm-019',0)
            ROLLBACK WORK 
         END IF    
      END IF 
   ELSE
      CLOSE WINDOW t385_w1
      CLOSE t385_cl

   END IF    
 
   CALL t385_sum()
   
END FUNCTION 
FUNCTION t385_insljf()
DEFINE l_lnv DYNAMIC ARRAY OF RECORD
          lnv04  LIKE lnv_file.lnv04,
          lnv18  LIKE lnv_file.lnv18
          END RECORD 
DEFINE l_lit DYNAMIC ARRAY OF RECORD
          lit04  LIKE lit_file.lit04,
          lit05  LIKE lit_file.lit05
          END RECORD 
DEFINE l_lnw DYNAMIC ARRAY OF RECORD
          lnw03  LIKE lnw_file.lnw03
          END RECORD         
DEFINE l_liu08   LIKE liu_file.liu08,  
       l_cnt   LIKE type_file.num5,
       l_sql   STRING

    #查找标准费用表中，此合同费用结束日期大于终止结算日的费用编号，方案编号 
    LET l_sql = "SELECT DISTINCT lnv04,lnv18 FROM lnv_file ",
                " WHERE lnv01 = '",g_lje.lje04,"'",
                "   AND lnvplant='",g_lje.ljeplant,"' ",
              # "   AND lnv17 >= '",g_lje.lje14,"' ",
                " ORDER BY lnv04"
    PREPARE t385_1_prepare FROM l_sql                     #預備一下
    DECLARE lnv_cs CURSOR FOR t385_1_prepare
    LET l_cnt = 1
    FOREACH lnv_cs INTO l_lnv[l_cnt].*
        IF SQLCA.sqlcode THEN
           #CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
           LET g_success = 'N'
           CALL s_errmsg('','','FOREACH:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        LET l_liu08 = ''
       #SELECT liu08 INTO l_liu08 FROM liu_file
       # WHERE liu04 = l_lnv[l_cnt].lnv04
       #   AND liu01 = g_lje.lje04
       #IF l_liu08 = '0' THEN 
           INSERT INTO ljf_file(ljf01,ljf02,ljf03,ljf04,ljf05,ljf06,ljfplant,ljflegal)
             VALUES (g_lje.lje01,l_cnt,l_lnv[l_cnt].lnv04,l_lnv[l_cnt].lnv18,'1','N',g_plant,g_legal)
           IF SQLCA.SQLCODE OR SQLCA.sqlerrd[3]=0 THEN
              #CALL cl_err3("ins","ljf_file",g_lje.lje01,"",SQLCA.SQLCODE,"","",1)
              CALL s_errmsg('','','ins ljf_file',SQLCA.sqlcode,1)
              LET g_success = 'N'
           ELSE
              LET l_cnt = l_cnt + 1
           END IF
       #END IF 
        
    END FOREACH
    #查找优惠费用表中，此合同，优惠结束日期大于终止结算日的费用编号，优惠单号
    LET l_sql = "SELECT lit04,lit05 FROM lit_file ",
                " WHERE lit01 = '",g_lje.lje04,"'",
                "   AND litplant='",g_lje.ljeplant,"' ",
              # "   AND lit07 >= '",g_lje.lje14,"' ",
                " ORDER BY lit04"
    PREPARE t385_2_prepare FROM l_sql                     #預備一下
    DECLARE lit_cs CURSOR FOR t385_2_prepare
    FOREACH lit_cs INTO l_lit[l_cnt].*
        IF SQLCA.sqlcode THEN
           #CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
           LET g_success = 'N'
           CALL s_errmsg('','','FOREACH:',SQLCA.sqlcode,1)
        END IF
        LET l_liu08 = ''
       #SELECT liu08 INTO l_liu08 FROM liu_file
       # WHERE liu04 = l_lit[l_cnt].lit04
       #   AND liu01 = g_lje.lje04
       #IF l_liu08 = '0' THEN 
           INSERT INTO ljf_file(ljf01,ljf02,ljf03,ljf04,ljf05,ljf06,ljfplant,ljflegal)
             VALUES (g_lje.lje01,l_cnt,l_lit[l_cnt].lit04,l_lit[l_cnt].lit05,'2','N',g_plant,g_legal)
           IF SQLCA.SQLCODE OR SQLCA.sqlerrd[3]=0 THEN
              #CALL cl_err3("ins","ljf_file",g_lje.lje01,"",SQLCA.SQLCODE,"","",1)
               CALL s_errmsg('','','ins ljf_file',SQLCA.sqlcode,1)
              LET g_success = 'N'
           ELSE
              LET l_cnt = l_cnt + 1
           END IF   
       #END IF      
    END FOREACH  
   #查询其他费用表中，此合同，费用结束日期大于终止结算日的费用编号 
    LET l_sql = "SELECT lnw03 FROM lnw_file ",
                " WHERE lnw01 = '",g_lje.lje04,"'",
                "   AND lnwplant ='",g_lje.ljeplant,"' ",
              # "   AND lnw09 >= '",g_lje.lje14,"' ",
                " ORDER BY lnw03"
    PREPARE t385_3_prepare FROM l_sql                     #預備一下
    DECLARE lnw_cs CURSOR FOR t385_3_prepare
    FOREACH lnw_cs INTO l_lnw[l_cnt].*
        IF SQLCA.sqlcode THEN
           #CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
           LET g_success = 'N'
           CALL s_errmsg('','','FOREACH:',SQLCA.sqlcode,1)
        END IF
       #LET l_liu08 = ''
       #SELECT liu08 INTO l_liu08 FROM liu_file
       # WHERE liu04 = l_lnw[l_cnt].lnw03
       #   AND liu01 = g_lje.lje04
       #IF l_liu08 = '0' THEN 
           INSERT INTO ljf_file(ljf01,ljf02,ljf03,ljf04,ljf05,ljf06,ljfplant,ljflegal)
             VALUES (g_lje.lje01,l_cnt,l_lnw[l_cnt].lnw03,'','1','N',g_plant,g_legal)
           IF SQLCA.SQLCODE OR SQLCA.sqlerrd[3]=0 THEN
              #CALL cl_err3("ins","ljf_file",g_lje.lje01,"",SQLCA.SQLCODE,"","",1)
               CALL s_errmsg('','','ins ljf_file',SQLCA.sqlcode,1)
              LET g_success = 'N'
           ELSE
              LET l_cnt = l_cnt + 1
           END IF   
       #END IF      
    END FOREACH
END FUNCTION 

FUNCTION t385_ljf_fill()
DEFINE p_wc2            STRING
    LET g_sql = "SELECT ljf02 ,ljf03 ,'','',ljf04,ljf05,ljf06 ",   
                " FROM ljf_file",
                " WHERE ljf01 = '", g_lje.lje01,"'"
                
    PREPARE t385_ljf_pb FROM g_sql
    DECLARE t385_ljf_curs CURSOR FOR t385_ljf_pb
 
    CALL g_ljf.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH t385_ljf_curs INTO g_ljf[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN
           #CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
           LET g_success = 'N'
           CALL s_errmsg('','','FOREACH:',SQLCA.sqlcode,1)
           EXIT FOREACH 
       END IF
       SELECT oaj02,oaj05 INTO g_ljf[g_cnt].oaj02,g_ljf[g_cnt].oaj05
         FROM oaj_file
        WHERE oaj01 = g_ljf[g_cnt].ljf03 
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
       LET g_success = 'N'
           CALL s_errmsg('','','','9035',1)
           #CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
       END IF
    END FOREACH
    CALL g_ljf.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b3 = g_cnt-1  
    LET g_cnt = 0
END FUNCTION   

FUNCTION t385_choose()
 DEFINE l_ac_t          LIKE type_file.num5,                    
        l_n             LIKE type_file.num5,                     
        l_lock_sw       LIKE type_file.chr1,                     
        p_cmd           LIKE type_file.chr1,                     
        l_allow_insert  LIKE type_file.chr1,               
        l_allow_delete  LIKE type_file.chr1        
 DEFINE l_liu08         LIKE liu_file.liu08
  

    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete') 
    LET g_forupd_sql = "SELECT ljf02,ljf03,'','',ljf04,ljf05,ljf06 ",  
                      "  FROM ljf_file WHERE ljf01='",g_lje.lje01,"' ",
                      "  AND  ljf02 = ?  FOR UPDATE "
    LET g_forupd_sql=cl_forupd_sql(g_forupd_sql)

    DECLARE t385_bcl CURSOR FROM g_forupd_sql      
    INPUT ARRAY g_ljf WITHOUT DEFAULTS FROM s_ljf.*
          ATTRIBUTE (COUNT=g_rec_b3,MAXCOUNT=g_max_rec,UNBUFFERED,
                     INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert) 
 
       BEFORE INPUT
          IF g_rec_b3 != 0 THEN
             CALL fgl_set_arr_curr(l_ac)
          END IF
       BEFORE ROW
          LET p_cmd='' 
          LET l_ac = ARR_CURR()
          LET l_lock_sw = 'N'           
          LET l_n  = ARR_COUNT()
          IF g_rec_b3>=l_ac THEN
            # BEGIN WORK
             LET p_cmd='u'                                  
            
             LET g_ljf_t.* = g_ljf[l_ac].*  
             OPEN t385_bcl USING g_ljf_t.ljf02
             IF STATUS THEN
                LET g_success = 'N'
                CALL s_errmsg('','','OPEN t385_bcl:',STATUS,1)
                #CALL cl_err("OPEN t385_bcl:", STATUS, 1)
                LET l_lock_sw = "Y"
             ELSE 
                FETCH t385_bcl INTO g_ljf[l_ac].* 
                IF SQLCA.sqlcode THEN
                   CALL s_errmsg('',g_ljf_t.ljf02,'',SQLCA.sqlcode,1)
                   CALL cl_err(g_ljf_t.ljf02,SQLCA.sqlcode,1)
                   LET l_lock_sw = "Y"
                END IF
                SELECT oaj02,oaj05 INTO g_ljf[l_ac].oaj02,g_ljf[l_ac].oaj05
                  FROM oaj_file
                 WHERE oaj01 = g_ljf[l_ac].ljf03 
             END IF
          END IF

       ON CHANGE ljf06
          IF NOT cl_null(g_ljf[l_ac].ljf06) THEN
             #所有的优惠都可以选择回收或者不回收
             IF g_ljf[l_ac].ljf05 = '2' THEN

             END IF
             #收付实现制的标准费用不可以退，必需要大于等于终止结算日lje14的才可以退
             IF g_ljf[l_ac].ljf05 = '1' AND g_ljf[l_ac].ljf06 = 'Y' THEN
                LET g_cnt = 0
                IF NOT cl_null(g_ljf[l_ac].ljf04) THEN
                   SELECT COUNT(*) INTO g_cnt FROM liv_file
                    WHERE liv01 = g_lje.lje04
                      AND liv07 = g_ljf[l_ac].ljf04
                      AND liv04 >= g_lje.lje14
                      AND liv08 = '1'
                ELSE
                   SELECT COUNT(*) INTO g_cnt FROM liv_file
                    WHERE liv01 = g_lje.lje04
                      AND liv07 IS NULL
                      AND liv04 >= g_lje.lje14
                      AND liv08 = '1'
                END IF
                IF g_cnt <= 0 THEN
                   CALL cl_err('','alm1380',1)
                   LET g_ljf[l_ac].ljf06 = 'N'
                   NEXT FIELD ljf06
                END IF
                LET l_liu08 = ''
                SELECT liu08 INTO l_liu08 FROM liu_file
                 WHERE liu04 = g_ljf[l_ac].ljf03
                   AND liu01 = g_lje.lje04
                IF l_liu08 = '1' THEN
                   CALL cl_err('','alm1380',1)
                   LET g_ljf[l_ac].ljf06 = 'N'
                   NEXT FIELD ljf06
                END IF
             END IF
          END IF

       ON ROW CHANGE
          IF INT_FLAG THEN                 #新增程式段
             CALL cl_err('',9001,0)
             LET g_ljf[l_ac].* = g_ljf_t.*
             CLOSE t385_bcl
             LET g_success = 'N'
            # ROLLBACK WORK
             EXIT INPUT
           END IF
           IF l_lock_sw="Y" THEN
              CALL cl_err(g_ljf_t.ljf02,-263,0)
              LET g_ljf[l_ac].* = g_ljf_t.*
           ELSE
              UPDATE ljf_file SET ljf02 = g_ljf[l_ac].ljf02,
                                  ljf03 = g_ljf[l_ac].ljf03,
                                  ljf04 = g_ljf[l_ac].ljf04,
                                  ljf05 = g_ljf[l_ac].ljf05,
                                  ljf06 = g_ljf[l_ac].ljf06
               WHERE ljf01 = g_lje.lje01
                 AND ljf02 = g_ljf_t.ljf02
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 #CALL cl_err3("upd","ljf_file", g_lje.lje04,g_ljf_t.ljf02,'',SQLCA.sqlcode,"",1)  
               #  ROLLBACK WORK
                 CALL s_errmsg('','','upd ljf_file',SQLCA.sqlcode,1)
                 LET g_success = 'N'      
                 LET g_ljf[l_ac].* = g_ljf_t.*
              END IF
           END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()            
           LET l_ac_t = l_ac               
 
           IF INT_FLAG THEN               
              #CALL cl_err('',9001,0)
              IF p_cmd='u' THEN
                 LET g_ljf[l_ac].* = g_ljf_t.*
              END IF
              CLOSE t385_bcl
              LET g_success = 'N'            
             # ROLLBACK WORK             
              EXIT INPUT
           END IF
           CLOSE t385_bcl            
 
          ON ACTION CONTROLR
             CALL cl_show_req_fields()
  
          ON ACTION CONTROLG
             CALL cl_cmdask()
 
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE INPUT
 
          ON ACTION about        
             CALL cl_about()     
 
          ON ACTION HELP        
             CALL cl_show_help()  
                 
       END INPUT  
 
END FUNCTION
FUNCTION t385_b_data1()
DEFINE  l_liw  DYNAMIC ARRAY OF RECORD 
        liw04    LIKE liw_file.liw04,
        liw14    LIKE liw_file.liw14
        END RECORD
DEFINE  l_sql        STRING ,
        l_cnt        LIKE type_file.num5, 
        l_sum1       LIKE liw_file.liw14
        #抓取合同账单中的费用编号和已收金额
    LET l_sql = "SELECT liw04,SUM(liw14) FROM liw_file",
                " WHERE liw01 = '",g_lje.lje04,"'",
                "   AND liwplant='",g_lje.ljeplant,"' ",
                "  GROUP BY liw04",
                "  ORDER BY liw04"
              #  "   AND lnv17 >= '",g_today,"' "
    PREPARE t385_liw_prepare FROM l_sql                     #預備一下
    DECLARE liw_cs CURSOR FOR t385_liw_prepare
    LET l_cnt = 1
    LET g_success = 'Y'
    FOREACH liw_cs INTO l_liw[l_cnt].*  
        IF SQLCA.sqlcode THEN
           LET g_success = 'N'
           CALL s_errmsg('','','FOREACH:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        IF cl_null(l_liw[l_cnt].liw14) THEN 
           LET l_liw[l_cnt].liw14 = 0 
        END IF
        CALL cl_digcut(l_liw[l_cnt].liw14,g_lla04) RETURNING l_liw[l_cnt].liw14 
        INSERT INTO ljg_file(ljg01,ljg02,ljg03,ljg04,ljgplant,ljglegal)
          VALUES (g_lje.lje01,l_cnt,l_liw[l_cnt].liw04,l_liw[l_cnt].liw14,g_plant,g_legal)
        IF SQLCA.SQLCODE OR SQLCA.sqlerrd[3]=0 THEN
           #CALL cl_err3("ins","ljg_file",g_lje.lje01,"",SQLCA.SQLCODE,"","",1)
           CALL s_errmsg('','','ins ljg_file',SQLCA.sqlcode,1)
           LET g_success = 'N'
        ELSE
           LET l_cnt = l_cnt + 1
        END IF        
    END FOREACH
   
END FUNCTION     
FUNCTION t385_b_data2()
DEFINE  l_ljf  DYNAMIC ARRAY OF RECORD
          ljf04      LIKE ljf_file.ljf04,
          ljf05      LIKE ljf_file.ljf05,
          ljf06      LIKE ljf_file.ljf06
        END RECORD        
DEFINE  l_sql        STRING ,
        l_cnt        LIKE type_file.num5, 
        l_n          LIKE type_file.num5, 
        l_lij06      LIKE lij_file.lij06,
        l_lnv16      LIKE lnv_file.lnv16,
        l_lnv17      LIKE lnv_file.lnv17,
        l_lnw08      LIKE lnw_file.lnw08,
        l_lnw09      LIKE lnw_file.lnw09,
        l_lit07      LIKE lit_file.lit07,
        l_lit06      LIKE lit_file.lit06,
        l_liv05      LIKE liv_file.liv05,#费用编号
        l_liv06      LIKE liv_file.liv06,#应收金额
        l_liv062     LIKE liv_file.liv06,
        l_liv063     LIKE liv_file.liv06,
        l_sum2       LIKE liv_file.liv06,
        l_ljh04      LIKE ljh_file.ljh04,
        g_ljh04      LIKE ljh_file.ljh04

    #根据日核算中的费用编号，应收费用 汇总应扣款单身
    #LET l_sql = "SELECT liv05, SUM(liv06) ",    #FUN-C80006 mark
    LET l_sql = "SELECT liv05,SUM(CASE liv08 WHEN '2' THEN liv06*(-1) ELSE liv06 END) ",      #FUN-C80006 add
                "  FROM liv_file ",
                " WHERE liv01 = '",g_lje.lje04,"' ",
                " GROUP BY liv05 ",
                " ORDER BY liv05 "
                
    PREPARE t385_liv_prepare1 FROM l_sql                     #預備一下
    DECLARE liv_cs1 CURSOR FOR t385_liv_prepare1      
    LET l_sum2= 0
    LET l_n = 1    
    FOREACH liv_cs1 INTO l_liv05,l_liv06 
        IF SQLCA.sqlcode THEN
           LET g_success = 'N'
           CALL s_errmsg('','','FOREACH:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        #如果费用编号存在于退场终止条款中        
        LET l_sql = "SELECT ljf04,ljf05,ljf06 ",
                    "  FROM ljf_file ",
                    " WHERE ljf01 = '",g_lje.lje01,"' ",
                    "   AND ljf03 = '",l_liv05,"' "
        PREPARE t385_ljf_prepare2 FROM l_sql                     #預備一下
        DECLARE ljf_cs2 CURSOR FOR t385_ljf_prepare2    
        LET l_cnt = 1
        LET g_ljh04 = 0 
        FOREACH ljf_cs2 INTO l_ljf[l_cnt].*  
           IF SQLCA.sqlcode THEN
              LET g_success = 'N'
              CALL s_errmsg('','','FOREACH:',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF
           #如果优惠不回收是 ‘N’ 则汇总终止日到费用结束日期的费用
           #用 总的费用 - 汇总的费用 得到从开始日到终止结算日的费用 
           IF l_ljf[l_cnt].ljf06 = 'N' THEN 
              IF l_ljf[l_cnt].ljf05 = '2' THEN  
                 SELECT SUM(liv06) INTO l_ljh04 FROM liv_file
                  WHERE liv05 = l_liv05
                    AND liv01 = g_lje.lje04
                   #AND (liv04 > g_lje.lje14 ) 
                    AND liv08 = '2'
                    AND liv07 = l_ljf[l_cnt].ljf04
                 IF cl_null(l_ljh04) THEN 
                    LET l_ljh04 = 0
                 END IF 
                 #LET l_liv06 = l_liv06 - l_ljh04                  #FUN-C80006 mark
                 LET l_liv06 = l_liv06 + l_ljh04                   #FUN-C80006 add
              END IF 
           ELSE 
              #如果 费用退 为 ‘Y’ 则汇总终止日到费用结束日期的费用
              #用 总的费用 - 汇总的费用 得到从开始日到终止结算日的费用  
              IF l_ljf[l_cnt].ljf05 = '1' THEN  
                 #l_lij06 = 'Y' 表示费用为标准费用，否则为其他费用
                 SELECT lij06 INTO l_lij06 FROM lij_file,lnt_file 
                  WHERE lij01 = lnt71
                    AND lnt01 = g_lje.lje04
                    AND lij02 = l_liv05
                 IF l_lij06 = 'Y' THEN  
                    #汇总日核算中终止结算日到费用结束日期的费用   
                    SELECT SUM(liv06) INTO l_ljh04 FROM liv_file
                     WHERE liv05 = l_liv05
                       AND liv01 = g_lje.lje04
                       AND liv07 = l_ljf[l_cnt].ljf04
                       AND liv04 > g_lje.lje14
                       AND liv08 = '1'
                    IF cl_null(l_ljh04) THEN 
                       LET l_ljh04 = 0
                    END IF 
                    LET l_liv06 = l_liv06 - l_ljh04
                 ELSE 
                    #汇总日核算中终止结算日到费用结束日期的费用      
                    SELECT SUM(liv06) INTO l_ljh04 FROM liv_file
                     WHERE liv05 = l_liv05
                       AND liv01 = g_lje.lje04
                       AND liv04 > g_lje.lje14
                       AND liv08 = '1'
                    IF cl_null(l_ljh04) THEN 
                       LET l_ljh04 = 0
                    END IF
                    LET l_liv06 = l_liv06 - l_ljh04
                 END IF 
              END IF    
 
           END IF 
        END FOREACH         
        INSERT INTO ljh_file(ljh01,ljh02,ljh03,ljh04,ljhplant,ljhlegal)
          VALUES (g_lje.lje01,l_n,l_liv05,l_liv06,g_plant,g_legal)
        IF SQLCA.SQLCODE OR SQLCA.sqlerrd[3]=0 THEN
           #CALL cl_err3("ins","ljh_file",g_lje.lje01,"",SQLCA.SQLCODE,"","",1)
           CALL s_errmsg('','','ins ljh_file',SQLCA.sqlcode,1)
           LET g_success = 'N'
        ELSE
           LET l_n = l_n + 1
        END IF
    END FOREACH 

END FUNCTION 
FUNCTION t385_sum()
DEFINE  l_sum    LIKE ljg_file.ljg04,
        l_sum2   LIKE ljh_file.ljh04
DEFINE l_cnt1      LIKE type_file.num5
DEFINE l_cnt2      LIKE type_file.num5 
   LET l_cnt1 = 0
   LET l_cnt2 = 0 
   SELECT COUNT(*) INTO l_cnt1 FROM ljg_file                                                                                   
       WHERE ljg01=g_lje.lje01 AND ljgplant = g_plant
   SELECT COUNT(*) INTO l_cnt2 FROM ljh_file                                                                                   
       WHERE ljh01=g_lje.lje01 AND ljhplant = g_plant    
   IF l_cnt1 <> 0 AND l_cnt2 <> 0 THEN        
      SELECT SUM(ljg04) INTO l_sum FROM ljg_file
       WHERE ljg01 = g_lje.lje01
      SELECT SUM(ljh04) INTO l_sum2 FROM ljh_file
       WHERE ljh01 = g_lje.lje01
      LET g_lje.lje16 = l_sum  #原付款总额
      LET g_lje.lje17 = l_sum2 #应扣款总额
      LET g_lje.lje22 = l_sum - l_sum2  #应退款总额
      IF NOT cl_null(g_lje.lje20) THEN 
         CASE g_lje.lje18   
            WHEN '1'  LET g_lje.lje22 = g_lje.lje22 - g_lje.lje20 #违约方为甲方，减去违约金额
            WHEN '2'  LET g_lje.lje22 = g_lje.lje22 + g_lje.lje20 #违约方为乙方，加上违约金额
         END CASE 
      END IF     
      UPDATE lje_file SET lje15 = g_lje.lje15,
                          lje16 = g_lje.lje16,
                          lje17 = g_lje.lje17,
                          lje22 = g_lje.lje22
       WHERE lje01 = g_lje.lje01
      IF SQLCA.SQLCODE OR SQLCA.sqlerrd[3]=0 THEN
         CALL cl_err3("upd","lje_file",g_lje.lje01,"",STATUS,"","",1)
      ELSE 
         DISPLAY BY NAME g_lje.lje16,g_lje.lje17,g_lje.lje22   
      END IF 
   END IF      
END FUNCTION 
FUNCTION t385_u()
 
   IF s_shut(0) THEN RETURN END IF
   IF g_lje.lje01 IS NULL OR g_lje.ljeplant IS NULL THEN 
      CALL cl_err('',-400,2) RETURN 
   END IF
   SELECT * INTO g_lje.* FROM lje_file WHERE lje01 = g_lje.lje01
 
   IF g_lje.ljeconf='Y' THEN CALL cl_err('','9022',0) RETURN END IF   
   IF g_lje.ljeacti = 'N' THEN                                                                                                      
      CALL cl_err('','mfg1000',0)                                                                                                   
      RETURN                                                                                                                        
   END IF
   IF g_lje.ljeplant <> g_plant THEN
      CALL cl_err('','alm1023',0)
      RETURN
   END IF  
   LET g_success = 'Y'
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_lje01_t = g_lje.lje01
   LET g_lje_t.* = g_lje.*
   BEGIN WORK
   OPEN t385_cl USING g_lje.lje01
   FETCH t385_cl INTO g_lje.*
   IF SQLCA.SQLCODE THEN
      CALL cl_err(g_lje.lje01,SQLCA.SQLCODE,0)
      CLOSE t385_cl 
      ROLLBACK WORK 
      RETURN
   END IF
   CALL t385_show()
   WHILE TRUE
      LET g_lje01_t = g_lje.lje01
      LET g_lje.ljemodu=g_user
      LET g_lje.ljedate=g_today
      CALL t385_i("u")
      IF INT_FLAG THEN
          LET INT_FLAG = 0
          LET g_lje.*=g_lje_t.*
          CALL t385_show()
          CALL cl_err('','9001',0)
          EXIT WHILE
      END IF
      UPDATE lje_file SET lje_file.* = g_lje.* WHERE lje01 = g_lje.lje01 
      IF SQLCA.SQLCODE THEN
         LET g_success = 'N'
         CALL cl_err3("upd","lje_file",g_lje.lje01,"",SQLCA.SQLCODE,"","",1)  
         CONTINUE WHILE
      END IF
      IF g_lje.lje14 <> g_lje_t.lje14 THEN 
         IF cl_confirm('alm1446') THEN
            CALL t385_end("u")
            CALL t385_delall() 
         END IF
      END IF     
      EXIT WHILE
   END WHILE
   CLOSE t385_cl
   IF g_success = 'N' THEN 
     ROLLBACK WORK 
   ELSE   
      COMMIT WORK
   END IF    
END FUNCTION
 
FUNCTION t385_i(p_cmd)
DEFINE p_cmd        LIKE type_file.chr1,
       l_n          LIKE type_file.num5,
       li_result    LIKE type_file.num5,
       l_gen03      LIKE gen_file.gen03
   DISPLAY BY NAME
                g_lje.lje01,g_lje.lje02,g_lje.lje03,g_lje.ljeplant,g_lje.ljelegal,
                g_lje.lje04,g_lje.lje05,g_lje.lje06,g_lje.lje07,g_lje.lje08,g_lje.lje09,
                g_lje.lje10,g_lje.lje11,g_lje.lje12,g_lje.lje13,g_lje.lje14,g_lje.lje15,
                g_lje.lje16,g_lje.lje17,g_lje.lje18,g_lje.lje19,g_lje.lje20,g_lje.lje21,
                g_lje.lje22,g_lje.lje23,g_lje.lje24,g_lje.ljemksg,g_lje.lje25,g_lje.ljeconf,
                g_lje.ljeconu,g_lje.ljecond,g_lje.lje26,g_lje.ljeuser,g_lje.ljegrup,g_lje.ljeoriu,
                g_lje.ljemodu,g_lje.ljedate,g_lje.ljeorig,g_lje.ljeacti,g_lje.ljecrat        
      
   
   CALL t385_desc()
   INPUT BY NAME g_lje.lje01,g_lje.lje02,g_lje.lje03,g_lje.lje04,g_lje.lje14,g_lje.lje18,
                 g_lje.lje19,g_lje.lje20,g_lje.lje21,g_lje.lje22,g_lje.lje23,g_lje.lje24,
                 g_lje.lje26  WITHOUT DEFAULTS
 
       BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL t385_set_entry(p_cmd)
           CALL t385_set_no_entry(p_cmd)
           IF  cl_null(g_lje.lje19) THEN
              CALL cl_set_comp_entry("lje20",TRUE)
           ELSE
              CALL cl_set_comp_entry("lje20",FALSE)  
           END IF  
           IF NOT cl_null(g_lje.lje20) THEN
              CALL cl_set_comp_required("lje21",TRUE)
           ELSE
              CALL cl_set_comp_required("lje21",FALSE)  
           END IF              
           LET g_before_input_done = TRUE
           CALL cl_set_docno_format("lje01")
       AFTER FIELD lje01
           IF NOT cl_null(g_lje.lje01) THEN
              IF (p_cmd='a') OR (p_cmd='u' AND g_lje.lje01!=g_lje_t.lje01) THEN
                 CALL s_check_no("alm",g_lje.lje01,g_lje01_t,"P8","lje_file","lje01","")  
                    RETURNING li_result,g_lje.lje01
                 IF (NOT li_result) THEN                                                            
                    LET g_lje.lje01=g_lje_t.lje01                                                                 
                    NEXT FIELD lje01                                                                                      
                 END IF
                 LET g_t1=s_get_doc_no(g_lje.lje01)
                 SELECT oayapr INTO g_lje.ljemksg FROM oay_file WHERE oayslip = g_t1 
                 DISPLAY BY NAME g_lje.ljemksg
              END IF
           END IF
       AFTER FIELD lje02 
         IF NOT cl_null(g_lje.lje02) THEN
            CALL t385_lje02()
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               LET g_lje.lje02 = g_lje_t.lje02
               DISPLAY BY NAME g_lje.lje02
               NEXT FIELD lje02
            END IF
         END IF      
             
       AFTER FIELD lje04
          IF NOT cl_null(g_lje.lje04) THEN 
             CALL t385_lje04(p_cmd)
             IF NOT cl_null(g_errno) THEN
                CALL cl_err('',g_errno,0)
                NEXT FIELD lje04
             END IF                 
          END IF 
          IF NOT cl_null(g_lje.lje14) THEN 
             CALL t385_lje14()
             IF NOT cl_null(g_errno) THEN
                CALL cl_err('',g_errno,0)
                NEXT FIELD lje14
             END IF 
          END IF
          IF NOT cl_null(g_lje.lje19) THEN 
             CALL t385_lje19() 
          END IF    
       AFTER FIELD lje14
          IF NOT cl_null(g_lje.lje14) THEN
             IF g_lje.lje14 < g_today THEN 
                CALL cl_err('','alm1158',0)
                NEXT FIELD lje14
             END IF    
             IF  NOT cl_null(g_lje.lje04) THEN 
                CALL t385_lje14()
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err('',g_errno,0)
                   NEXT FIELD lje14
                END IF 
             END IF    
          END IF  
       ON CHANGE lje18
          CALL  t385_sum()   
       AFTER FIELD  lje19
          IF NOT cl_null(g_lje.lje19) THEN 
             IF g_lje.lje19 < 0 OR g_lje.lje19 >100 THEN
                CALL cl_err('','aec-002',0)
                NEXT FIELD lje19
             ELSE
                CALL t385_lje19()   
             END IF 
          ELSE
             CALL cl_set_comp_entry("lje20",TRUE)
           #  CALL cl_set_comp_required("lje21",FALSE) 
          END IF   
          CALL t385_sum() 
       AFTER FIELD  lje20
          IF NOT cl_null(g_lje.lje20) THEN 
             IF g_lje.lje20 <= 0 THEN 
                CALL cl_err('','alm-342',0)
                NEXT FIELD lje20
             END IF
             CALL cl_set_comp_required("lje21",TRUE)
          ELSE
             CALL cl_set_comp_required("lje21",FALSE)  
          END IF
          CALL t385_sum()    
       AFTER FIELD lje21
          IF NOT cl_null(g_lje.lje21) THEN 
             CALL t385_lje21(p_cmd)
             IF NOT cl_null(g_errno) THEN
                CALL cl_err('',g_errno,0)
                NEXT FIELD lje21
             END IF
          END IF           
       AFTER FIELD lje23
          IF NOT cl_null(g_lje.lje23) THEN 
             CALL t385_lje23(p_cmd)
             IF NOT cl_null(g_errno) THEN
                CALL cl_err('',g_errno,0)
                NEXT FIELD lje23
             END IF
          END IF
       AFTER FIELD lje24
          IF NOT cl_null(g_lje.lje24) THEN 
             CALL t385_lje24(p_cmd)
             IF NOT cl_null(g_errno) THEN
                CALL cl_err('',g_errno,0)
                NEXT FIELD lje24
             END IF
          END IF           
       ON ACTION controlp
          CASE 
             WHEN INFIELD(lje01)
                LET g_t1=s_get_doc_no(g_lje.lje01)
                CALL q_oay(FALSE,FALSE,g_t1,'P8','ALM') RETURNING g_t1  
                LET g_lje.lje01=g_t1               
                DISPLAY BY NAME g_lje.lje01       
                NEXT FIELD lje01  
             WHEN INFIELD(lje04) 
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_lnt"
                LET g_qryparam.default1 = g_lje.lje04
                LET g_qryparam.where = " lnt18 >= '",g_today,"' "  
                CALL cl_create_qry() RETURNING g_lje.lje04
                DISPLAY BY NAME g_lje.lje04
                CALL t385_lje04(p_cmd)
             WHEN INFIELD(lje21) 
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_oaj4"
                LET g_qryparam.default1 = g_lje.lje21
                CALL cl_create_qry() RETURNING g_lje.lje21
                DISPLAY BY NAME g_lje.lje21
                CALL t385_lje21(p_cmd)  
             WHEN INFIELD(lje23) 
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_gen"
                LET g_qryparam.default1 = g_lje.lje23                
                CALL cl_create_qry() RETURNING g_lje.lje23
                DISPLAY BY NAME g_lje.lje23
                CALL t385_lje23(p_cmd)
             WHEN INFIELD(lje24) 
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_gem"
                LET g_qryparam.default1 = g_lje.lje24
                CALL cl_create_qry() RETURNING g_lje.lje24
                DISPLAY BY NAME g_lje.lje24
                CALL t385_lje24(p_cmd)                    
                
          END CASE
       ON ACTION CONTROLR
          CALL cl_show_req_fields()
 
       ON ACTION CONTROLG
          CALL cl_cmdask()
 
       ON ACTION CONTROLF
          CALL cl_set_focus_form(ui.Interface.getRootNode()) 
               RETURNING g_fld_name,g_frm_name
          CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
       ON ACTION about 
          CALL cl_about()
 
       ON ACTION HELP
          CALL cl_show_help()
 
       AFTER INPUT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             EXIT INPUT
          END IF
   END INPUT
END FUNCTION
FUNCTION t385_lje02()
DEFINE l_sma53  LIKE sma_file.sma53 
   LET g_errno = ''
    SELECT sma53 INTO l_sma53 FROM sma_file
   IF l_sma53 > g_lje.lje02 THEN 
      LET g_errno = 'alm1203'
   END IF   
END FUNCTION     
FUNCTION  t385_lje04(p_cmd)
DEFINE p_cmd    LIKE type_file.chr1,
       l_n      LIKE type_file.num5,
       l_cnt1   LIKE type_file.num5,
       l_cnt2   LIKE type_file.num5,
       l_lnt26  LIKE lnt_file.lnt26,#確認碼
       l_lnt17  LIKE lnt_file.lnt17,#租賃期限起日
       l_lnt18  LIKE lnt_file.lnt18,#租賃期限止日
       l_lntacti  LIKE lnt_file.lntacti,#有效碼
       l_lnt06  LIKE lnt_file.lnt06,#攤位編號
       l_lnt04  LIKE lnt_file.lnt04,#商戶編號
       l_lnt33  LIKE lnt_file.lnt33,#經營小類
       l_lnt30  LIKE lnt_file.lnt30,#主品牌
       l_lnt11  LIKE lnt_file.lnt11,#建築面積
       l_lnt61  LIKE lnt_file.lnt61,#測量面積
       l_lnt10  LIKE lnt_file.lnt10,#經營面積
       l_lnt21  LIKE lnt_file.lnt21,#計租期限起日
       l_lnt22  LIKE lnt_file.lnt22,#計租期限止日
       l_lnt69  LIKE lnt_file.lnt69 #合同總額

              
   LET g_errno = ''
   IF g_lje_t.lje04 <> g_lje.lje04 THEN 
      SELECT COUNT(*) INTO l_cnt1 FROM ljg_file                                                                                   
       WHERE ljg01=g_lje.lje01 AND ljgplant = g_plant
      SELECT COUNT(*) INTO l_cnt2 FROM ljh_file                                                                                   
       WHERE ljh01=g_lje.lje01 AND ljhplant = g_plant    
      IF l_cnt1>0 AND l_cnt2>0 THEN
         LET g_errno = 'alm1447'
         RETURN 
      END IF 
   END IF     
   SELECT COUNT(*) INTO l_n FROM lje_file 
    WHERE lje04 = g_lje.lje04
      AND lje01 <> g_lje.lje01
   IF l_n > 0 THEN 
      LET g_errno = 'alm1342'
      RETURN 
   END IF    
   SELECT lnt26,lnt17,lnt18,lntacti INTO l_lnt26,l_lnt17,l_lnt18,l_lntacti
     FROM lnt_file WHERE lnt01 = g_lje.lje04
   CASE 
      WHEN SQLCA.sqlcode = 100   LET g_errno = 'alm-132'
      WHEN l_lnt26 <> 'Y'        LET g_errno = 'alm1041'
      WHEN l_lnt18 < g_today     LET g_errno = 'alm-483'
      WHEN l_lntacti = 'N'       LET g_errno = 'aec-090'
   END CASE
     
   IF cl_null(g_errno) OR p_cmd = 'd' THEN 
      SELECT lnt06,lnt04,lnt33,lnt30,lnt11,lnt61,lnt10,lnt21,lnt22,lnt69
        INTO l_lnt06,l_lnt04,l_lnt33,l_lnt30,l_lnt11,l_lnt61,l_lnt10,l_lnt21,l_lnt22,l_lnt69
        FROM lnt_file WHERE lnt01 = g_lje.lje04
      LET g_lje.lje05 = l_lnt06
      LET g_lje.lje06 = l_lnt04      
      LET g_lje.lje07 = l_lnt33
      LET g_lje.lje08 = l_lnt30
      LET g_lje.lje09 = l_lnt11
      LET g_lje.lje10 = l_lnt61
      LET g_lje.lje11 = l_lnt10
      LET g_lje.lje12 = l_lnt21
      LET g_lje.lje13 = l_lnt22
      LET g_lje.lje15 = l_lnt69
      DISPLAY BY NAME g_lje.lje05,g_lje.lje06,g_lje.lje07,g_lje.lje08,g_lje.lje09,
                      g_lje.lje10,g_lje.lje11,g_lje.lje12,g_lje.lje13,g_lje.lje15
      CALL t385_desc() 
   END IF     
END FUNCTION
FUNCTION  t385_lje14()
DEFINE l_lnt21  LIKE lnt_file.lnt21,#計租期限起日
       l_lnt22  LIKE lnt_file.lnt22#計租期限止日
   LET g_errno = ''  
   IF g_lje.lje14 < g_today THEN 
      LET g_errno = 'alm1158'
      RETURN 
   END IF    
   SELECT lnt21,lnt22 INTO l_lnt21,l_lnt22 FROM lnt_file 
    WHERE lnt01 = g_lje.lje04
   IF g_lje.lje14 > l_lnt22 OR g_lje.lje14 < l_lnt21 THEN 
      LET g_errno = 'alm1158'
   END IF    
END FUNCTION 
FUNCTION t385_lje19()
DEFINE l_liv06  LIKE liv_file.liv06  
   #IF NOT cl_null(g_lje.lje20) THEN 
      #LET g_lje.lje20 = ''
     # DISPLAY BY NAME g_lje.lje20
     # CALL cl_set_comp_entry("lje20",FALSE)
   #END IF    
   IF NOT cl_null(g_lje.lje12) AND NOT cl_null(g_lje.lje13) THEN   
      LET g_lje.lje20 = ''
      DISPLAY BY NAME g_lje.lje20
      CALL cl_set_comp_entry("lje20",FALSE)
      SELECT SUM(liv06) INTO l_liv06 FROM liv_file
       WHERE liv01 = g_lje.lje04
         AND (liv04 BETWEEN g_lje.lje12 AND g_lje.lje13)
         AND liv05 IN (SELECT oaj01 FROM oaj_file 
                        WHERE oaj05 = '02')
      IF l_liv06 = 0 THEN 
         LET g_lje.lje20 = 0
      ELSE    
         LET g_lje.lje20 = l_liv06 * g_lje.lje19 /100  
      END IF    
      CALL cl_digcut(g_lje.lje20,g_lla04) RETURNING g_lje.lje20
      DISPLAY BY NAME g_lje.lje20
      #LET g_lje.lje20 = cl_digcut(g_lje.lje20,g_lla04)  
      IF NOT cl_null(g_lje.lje20) THEN
         CALL cl_set_comp_required("lje21",TRUE)
      ELSE
         CALL cl_set_comp_required("lje21",FALSE)  
      END IF
   END IF                   
END FUNCTION 
FUNCTION t385_lje21(p_cmd)
DEFINE  p_cmd     LIKE type_file.chr1,
        l_oaj02   LIKE oaj_file.oaj02,#費用名稱
        l_oajacti LIKE oaj_file.oajacti
    LET g_errno = ''      
    SELECT oaj02,oajacti 
      INTO l_oaj02,l_oajacti
      FROM oaj_file
     WHERE oaj01 = g_lje.lje21
   CASE 
      WHEN SQLCA.sqlcode = 100   LET g_errno = 'axm-360'
      WHEN l_oajacti = 'N'       LET g_errno = 'alm1044'
      OTHERWISE
           LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   IF p_cmd = 'd' OR cl_null(g_errno) THEN
      DISPLAY l_oaj02 TO FORMONLY.oaj02   
   END IF  
END FUNCTION 
FUNCTION t385_lje23(p_cmd)
DEFINE p_cmd     LIKE type_file.chr1,
       l_gen02   LIKE gen_file.gen02,#員工姓名
       l_gen03   LIKE gen_file.gen03,#所屬部門
       l_genacti LIKE gen_file.genacti,
       l_gem02   LIKE gem_file.gem02,
       l_gemacti  LIKE gem_file.gemacti
   LET g_errno = ''  
   SELECT gen02,gen03,genacti INTO l_gen02,l_gen03,l_genacti
     FROM gen_file
    WHERE gen01 = g_lje.lje23
   CASE 
      WHEN SQLCA.sqlcode = 100   LET g_errno = 'art-241'
      WHEN l_genacti = 'N'       LET g_errno = 'alm1151'
      OTHERWISE
           LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   IF p_cmd = 'd' OR cl_null(g_errno) THEN
      DISPLAY l_gen02 TO FORMONLY.gen02   
      SELECT gem02,gemacti INTO l_gem02,l_gemacti
        FROM gem_file
       WHERE gem01 = l_gen03
       LET g_lje.lje24 = l_gen03
       DISPLAY l_gem02 TO FORMONLY.gem02   
   END IF 
END FUNCTION 
FUNCTION t385_lje24(p_cmd)
DEFINE p_cmd     LIKE type_file.chr1,
       l_gem02   LIKE gem_file.gem02,
       l_gemacti  LIKE gem_file.gemacti,
       l_n     LIKE type_file.num5
   LET g_errno = ''  
   SELECT gem02,gemacti INTO l_gem02,l_gemacti
     FROM gem_file
    WHERE gem01 = g_lje.lje24
   CASE 
      WHEN SQLCA.sqlcode = 100   LET g_errno = 'asf-624'
      WHEN l_gemacti = 'N'       LET g_errno = 'asf-624'
      OTHERWISE
           LET g_errno=SQLCA.sqlcode USING '------'
   END CASE    
   IF p_cmd = 'd' OR cl_null(g_errno) THEN
      DISPLAY l_gem02 TO FORMONLY.gem02   
   END IF    
END FUNCTION 
FUNCTION t385_q()
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_lje.* TO NULL
   CALL cl_opmsg('q')
   MESSAGE ""
   DISPLAY '   ' TO FORMONLY.cnt    
   CALL t385_cs()
   IF INT_FLAG OR g_action_choice="exit" THEN
      LET INT_FLAG = 0
      CLEAR FORM 
      INITIALIZE g_lje.* TO NULL
      CALL g_ljg.clear()
      CALL g_ljh.clear()
      LET g_wc2 = NULL
      LET g_wc3 = NULL
      LET g_lje01_t = NULL
      LET g_wc = NULL
      RETURN
   END IF
 
   MESSAGE " SEARCHING ! "
   OPEN t385_cs
   IF SQLCA.SQLCODE THEN
      CALL cl_err('',SQLCA.SQLCODE,0)
      INITIALIZE g_lje.* TO NULL
   ELSE
      OPEN t385_count
      FETCH t385_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL t385_fetch('F')
   END IF
   MESSAGE ""
END FUNCTION
FUNCTION t385_r()

   IF s_shut(0) THEN
      RETURN
   END IF

   IF g_lje.lje01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
   IF g_lje.ljeconf = 'Y' THEN
      CALL cl_err('','9023',0)
      RETURN
   END IF
   IF g_lje.ljeplant <> g_plant THEN
      CALL cl_err('','alm1023',0)
      RETURN
   END IF 

   SELECT * INTO g_lje.* FROM lje_file
    WHERE lje01=g_lje.lje01
   BEGIN WORK

   OPEN t385_cl USING g_lje.lje01
   IF STATUS THEN
      CALL cl_err("OPEN t385_cl:", STATUS, 1)
      CLOSE t385_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH t385_cl INTO g_lje.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lje.lje01,SQLCA.sqlcode,0)
      ROLLBACK WORK
      RETURN
   END IF

   CALL t385_show()

   IF cl_delh(0,0) THEN
       INITIALIZE g_doc.* TO NULL
       LET g_doc.column1 = "lje01"
       LET g_doc.value1 = g_lje.lje01
       CALL cl_del_doc()
      DELETE FROM lje_file WHERE lje01 = g_lje.lje01
      DELETE FROM ljf_file WHERE ljf01 = g_lje.lje01
      DELETE FROM ljg_file WHERE ljg01 = g_lje.lje01
      DELETE FROM ljh_file WHERE ljh01 = g_lje.lje01
      CLEAR FORM
      CALL g_ljg.clear()
      CALL g_ljh.clear()
      OPEN t385_count
      FETCH t385_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN t385_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL t385_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET g_no_ask = TRUE
         CALL t385_fetch('/')
      END IF
   END IF

   CLOSE t385_cl
   COMMIT WORK
   CALL cl_flow_notify(g_lje.lje01,'D')
END FUNCTION 
FUNCTION t385_x()

   IF s_shut(0) THEN
      RETURN
   END IF

   IF g_lje.lje01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
   IF g_lje.ljeplant <> g_plant THEN
      CALL cl_err('','alm1023',0)
      RETURN
   END IF 
   IF g_lje.ljeconf = 'Y' THEN 
      CALL cl_err('','9023',0)
      RETURN
   END IF 
   BEGIN WORK

   OPEN t385_cl USING g_lje.lje01
   IF STATUS THEN
      CALL cl_err("OPEN t385_cl:", STATUS, 1)
      CLOSE t385_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH t385_cl INTO g_lje.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lje.lje01,SQLCA.sqlcode,0)
      ROLLBACK WORK
      RETURN
   END IF

   LET g_success = 'Y'

   CALL t385_show()

   IF cl_exp(0,0,g_lje.ljeacti) THEN
      IF g_lje.ljeacti='Y' THEN
         LET g_lje.ljeacti='N'
      ELSE
         LET g_lje.ljeacti='Y'
      END IF

      UPDATE lje_file SET ljeacti=g_lje.ljeacti,
                          ljemodu=g_user,
                          ljedate=g_today
       WHERE lje01=g_lje.lje01
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","lje_file",g_lje.lje01,"",SQLCA.sqlcode,"","",1)
      END IF
   END IF

   CLOSE t385_cl

   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_lje.lje01,'V')
   ELSE
      ROLLBACK WORK
   END IF

   LET g_lje.ljemodu = g_user
   LET g_lje.ljedate=g_today
   DISPLAY BY NAME g_lje.ljeacti,g_lje.ljemodu,
                   g_lje.ljedate
   CALL cl_set_field_pic(g_lje.ljeconf,g_lje.lje25,"","","",g_lje.ljeacti)
END FUNCTION

FUNCTION t385_fetch(p_flag)
DEFINE   p_flag   LIKE type_file.chr1
   CASE p_flag
      WHEN 'N' FETCH NEXT     t385_cs INTO g_lje.lje01
      WHEN 'P' FETCH PREVIOUS t385_cs INTO g_lje.lje01
      WHEN 'F' FETCH FIRST    t385_cs INTO g_lje.lje01
      WHEN 'L' FETCH LAST     t385_cs INTO g_lje.lje01
      WHEN '/'
         IF (NOT g_no_ask) THEN
             CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
             LET INT_FLAG = 0
             PROMPT g_msg CLIPPED,': ' FOR g_jump
                ON IDLE g_idle_seconds
                   CALL cl_on_idle()
 
                ON ACTION about
                   CALL cl_about()
            
                ON ACTION HELP
                   CALL cl_show_help()
            
                ON ACTION controlg
                   CALL cl_cmdask()
 
             END PROMPT
             IF INT_FLAG THEN
                LET INT_FLAG = 0
                EXIT CASE
             END IF
         END IF
         FETCH ABSOLUTE g_jump t385_cs INTO g_lje.lje01
         LET g_no_ask = FALSE
   END CASE
 
   IF SQLCA.SQLCODE THEN
      CALL cl_err(g_lje.lje01,SQLCA.SQLCODE,0) 
      INITIALIZE g_lje.* TO NULL
      CALL g_ljg.clear()
      CALL g_ljh.clear()
      RETURN
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting( g_curs_index, g_row_count )
      DISPLAY g_curs_index TO FORMONLY.idx
   END IF
   SELECT * INTO g_lje.* FROM lje_file WHERE  lje01 = g_lje.lje01
   IF SQLCA.SQLCODE THEN
      INITIALIZE g_lje.* TO NULL
      CALL g_ljg.clear()
      CALL g_ljh.clear()
      CALL cl_err3("sel","lje_file",g_lje.lje01,"",SQLCA.SQLCODE,"","",1)  
      RETURN
   END IF
   
   CALL t385_show()
END FUNCTION
 
FUNCTION t385_show()
  
   DISPLAY BY NAME
                g_lje.lje01,g_lje.lje02,g_lje.lje03,g_lje.ljeplant,g_lje.ljelegal,
                g_lje.lje04,g_lje.lje05,g_lje.lje06,g_lje.lje07,g_lje.lje08,g_lje.lje09,
                g_lje.lje10,g_lje.lje11,g_lje.lje12,g_lje.lje13,g_lje.lje14,g_lje.lje15,
                g_lje.lje16,g_lje.lje17,g_lje.lje18,g_lje.lje19,g_lje.lje20,g_lje.lje21,
                g_lje.lje22,g_lje.lje23,g_lje.lje24,g_lje.ljemksg,g_lje.lje25,g_lje.ljeconf,
                g_lje.ljeconu,g_lje.ljecond,g_lje.lje26,g_lje.ljeuser,g_lje.ljegrup,g_lje.ljeoriu,
                g_lje.ljemodu,g_lje.ljedate,g_lje.ljeorig,g_lje.ljeacti,g_lje.ljecrat        
         
   CALL t385_desc()
   CALL cl_set_field_pic(g_lje.ljeconf,g_lje.lje25,"","","",g_lje.ljeacti)      
   CALL cl_show_fld_cont()
   CALL t385_b1_fill(g_wc2)
   CALL t385_b2_fill(g_wc3)
END FUNCTION
FUNCTION t385_b1_fill(p_wc2)
DEFINE p_wc2            STRING
    LET g_sql = "SELECT ljg02 ,ljg03 ,'','',ljg04 ",   
                " FROM ljg_file",
                " WHERE ljg01 = '", g_lje.lje01,"'"
                
                
    IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED," ORDER BY ljg03"
    END IF
    PREPARE t385_pb FROM g_sql
    DECLARE t385_curs CURSOR FOR t385_pb
 
    CALL g_ljg.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH t385_curs INTO g_ljg[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
       END IF
       SELECT oaj02,oaj05 INTO g_ljg[g_cnt].oaj02,g_ljg[g_cnt].oaj05
         FROM oaj_file
        WHERE oaj01 = g_ljg[g_cnt].ljg03 
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
       END IF
    END FOREACH
    CALL g_ljg.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b1 = g_cnt-1  
    DISPLAY g_rec_b1 TO FORMONLY.cn1
    LET g_cnt = 0
END FUNCTION                      
FUNCTION t385_b2_fill(p_wc2)
DEFINE p_wc2            STRING
    LET g_sql = "SELECT ljh02 ,ljh03 ,'','',ljh04 ",   
                " FROM ljh_file",
                " WHERE ljh01 = '", g_lje.lje01,"'"
                
                
    IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED, " ORDER BY ljh03"
    END IF
    PREPARE t385_pb1 FROM g_sql
    DECLARE t385_curs1 CURSOR FOR t385_pb1
 
    CALL g_ljh.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH t385_curs1 INTO g_ljh[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
       END IF
       SELECT oaj02,oaj05 INTO g_ljh[g_cnt].oaj02,g_ljh[g_cnt].oaj05
         FROM oaj_file
        WHERE oaj01 = g_ljh[g_cnt].ljh03 
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
       END IF
    END FOREACH
    CALL g_ljh.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b2 = g_cnt-1  
  #  DISPLAY g_rec_b2 TO FORMONLY.cn1
    LET g_cnt = 0
END FUNCTION                      
FUNCTION t385_desc()
DEFINE l_rtz13    LIKE rtz_file.rtz13
DEFINE l_azt02    LIKE azt_file.azt02
DEFINE l_lne05    LIKE lne_file.lne05
DEFINE l_gen02    LIKE gen_file.gen02
DEFINE l_oba02    LIKE oba_file.oba02
DEFINE l_tqa02    LIKE tqa_file.tqa02
DEFINE l_oaj02    LIKE oaj_file.oaj02
DEFINE l_gem02    LIKE gem_file.gem02
DEFINE l_gen02_1  LIKE gen_file.gen02
   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = g_lje.lje23
   DISPLAY l_gen02 TO FORMONLY.gen02  
   SELECT rtz13 INTO l_rtz13 FROM rtz_file WHERE rtz01 = g_lje.ljeplant
   DISPLAY l_rtz13 TO FORMONLY.rtz13
   SELECT azt02 INTO l_azt02 FROM azt_file WHERE azt01 = g_lje.ljelegal
   DISPLAY l_azt02 TO FORMONLY.azt02
   SELECT oba02 INTO l_oba02 FROM oba_file WHERE oba01 = g_lje.lje07
   DISPLAY l_oba02  TO FORMONLY.oba02
   SELECT tqa02 INTO l_tqa02  FROM tqa_file 
    WHERE tqa01 = g_lje.lje08 AND tqa03 = '2'
   DISPLAY l_tqa02  TO FORMONLY.tqa02
   SELECT lne05 INTO l_lne05 FROM lne_file WHERE lne01 = g_lje.lje06
   DISPLAY l_lne05 TO lne05
   SELECT oaj02 INTO l_oaj02 FROM oaj_file WHERE oaj01 = g_lje.lje21
   DISPLAY l_oaj02  TO FORMONLY.oaj02
   SELECT gen02 INTO l_gen02_1 FROM gen_file WHERE gen01 = g_lje.ljeconu
   DISPLAY l_gen02_1 TO FORMONLY.gen02_1
   SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01 = g_lje.lje24
   DISPLAY l_gem02 TO FORMONLY.gem02
END FUNCTION 

FUNCTION t385_confirm()                       #審核
DEFINE l_gen02_1  LIKE gen_file.gen02
   IF cl_null(g_lje.lje01) THEN
        CALL cl_err('','-400',0)
        RETURN
   END IF
#CHI-C30107 --------- add ---------- begin
   IF g_lje.ljeplant <> g_plant THEN
        CALL cl_err('','alm1023',0)
        RETURN
   END IF

   IF g_lje.ljeacti='N' THEN
        CALL cl_err('','alm-048',0)
        RETURN
   END IF

   IF g_lje.ljeconf='Y' THEN
        CALL cl_err('','9023',0)
        RETURN
   END IF
   IF NOT cl_confirm('alm-006') THEN
        RETURN
   END IF
#CHI-C30107 --------- add ---------- end
   SELECT * INTO g_lje.* FROM lje_file WHERE lje01=g_lje.lje01
   IF g_lje.ljeplant <> g_plant THEN
        CALL cl_err('','alm1023',0)
        RETURN
   END IF
    
   IF g_lje.ljeacti='N' THEN
        CALL cl_err('','alm-048',0)
        RETURN
   END IF
 
   IF g_lje.ljeconf='Y' THEN
        CALL cl_err('','9023',0)
        RETURN
   END IF
   #
   IF NOT cl_null(g_errno) THEN 
      CALL cl_err('',g_errno,0)
      RETURN 
   END IF    
#CHI-C30107 --------- mark -------- begin
#  IF NOT cl_confirm('alm-006') THEN
#       RETURN
#  END IF
#CHI-C30107 --------- mark -------- end

   BEGIN WORK
   LET g_success = 'Y'

   OPEN t385_cl USING g_lje.lje01
   IF STATUS THEN
      CALL cl_err("OPEN t385_cl:", STATUS, 1)
      CLOSE t385_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH t385_cl INTO g_lje.*
      IF SQLCA.sqlcode THEN
      CALL cl_err(g_lje.lje01,SQLCA.sqlcode,0)
      CLOSE t385_cl
      ROLLBACK WORK
      RETURN
   END IF
   LET g_time = TIME 
   UPDATE lje_file
      SET ljeconf = 'Y',
          ljeconu = g_user,
          ljecond = g_today,
          ljecont = g_time,
          ljemodu = g_user,
          ljedate = g_today,
          lje25   = '1'
    WHERE lje01 = g_lje.lje01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","lje_file",g_lje.lje01,"",STATUS,"","",1)
      LET g_success = 'N'
   ELSE
      LET g_lje.ljeconf = 'Y'
      LET g_lje.ljeconu = g_user
      LET g_lje.ljecond = g_today
#     LET g_lje.ljecont = TIME    #CHI-D20015
      LET g_lje.ljecont = g_time  #CHI-D20015
      LET g_lje.ljemodu = g_user
      LET g_lje.ljedate = g_today
      LET g_lje.lje19   = '1'
      DISPLAY BY NAME g_lje.ljeconf,g_lje.ljeconu,g_lje.ljecond,g_lje.ljecont,
                      g_lje.ljemodu,g_lje.ljedate,g_lje.lje25
      SELECT gen02 INTO l_gen02_1 FROM gen_file WHERE gen01 = g_lje.ljeconu
      DISPLAY l_gen02_1 TO gen02_1                   
      CALL cl_set_field_pic(g_lje.ljeconf,g_lje.lje25,"","","",g_lje.ljeacti)                
   END IF
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
END FUNCTION

FUNCTION t385_undoconfirm()                     #取消審核
DEFINE l_n  LIKE type_file.num5
DEFINE l_gen02_1  LIKE gen_file.gen02           #CHI-D20015
   IF cl_null(g_lje.lje01) THEN
      CALL cl_err('','-400',0)
      RETURN
   END IF

   SELECT * INTO g_lje.*
   FROM lje_file
   WHERE lje01=g_lje.lje01
   IF g_lje.ljeplant <> g_plant THEN
        CALL cl_err('','alm1023',0)
        RETURN
   END IF   
   IF g_lje.ljeacti='N' THEN
      CALL cl_err('','alm-004',0)
      RETURN
   END IF

   IF g_lje.ljeconf='N' THEN
      CALL cl_err('','9025',0)
      RETURN
   END IF
   IF g_lje.lje19='2' THEN
      CALL cl_err('','alm-943',0)
      RETURN
   END IF
   SELECT COUNT(*) INTO l_n FROM lji_file
    WHERE lji03 = g_lje.lje01 
   IF l_n > 0 THEN 
      CALL cl_err('','alm1141',0)
      RETURN 
   END IF    
   BEGIN WORK
   LET g_success = 'Y'
   OPEN t385_cl USING g_lje.lje01
   IF STATUS THEN
      CALL cl_err("OPEN t385_cl:", STATUS, 1)
      CLOSE t385_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH t385_cl INTO g_lje.*
      IF SQLCA.sqlcode THEN
      CALL cl_err(g_lje.lje01,SQLCA.sqlcode,0)
      CLOSE t385_cl
      ROLLBACK WORK
      RETURN
   END IF
   
   IF NOT cl_confirm('alm-008') THEN
        RETURN
   END IF
   LET g_time = TIME     #CHI-D20015
#  UPDATE lje_file SET ljeconf = 'N',ljeconu = '',ljecond = '',ljecont = '',lje25 = '0',  #CHI-D20015
   UPDATE lje_file SET ljeconf = 'N',ljeconu = g_user,ljecond = g_today,ljecont = g_time,lje25 = '0', #CHI-D20015
                     ljemodu = g_user,ljedate = g_today
    WHERE lje01 = g_lje.lje01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","lje_file",g_lje.lje01,"",STATUS,"","",1)
      LET g_success = 'N'
   ELSE
      LET g_lje.ljeconf = 'N'
#CHI-D20015--str--
#     LET g_lje.ljeconu = ''
#     LET g_lje.ljecond = ''
#     LET g_lje.ljecont = ''
      LET g_lje.ljeconu = g_user
      LET g_lje.ljecond = g_today
      LET g_lje.ljecont = g_time  
#CHI-D20015--end--
      LET g_lje.lje25 = '0'
      LET g_lje.ljemodu = g_user
      LET g_lje.ljedate = g_today
      DISPLAY BY NAME g_lje.ljeconf,g_lje.ljeconu,g_lje.ljecond,g_lje.ljecont,g_lje.lje25,
                      g_lje.ljemodu,g_lje.ljedate
#     DISPLAY '' TO gen02_1        #CHI-D20015
      SELECT gen02 INTO l_gen02_1 FROM gen_file WHERE gen01 = g_lje.ljeconu   #CHI-D20015
      DISPLAY l_gen02_1 TO gen02_1                                            #CHI-D20015
      CALL cl_set_field_pic(g_lje.ljeconf,g_lje.lje25,"","","",g_lje.ljeacti)                
   END IF
   IF g_success = 'Y' THEN
      COMMIT WORK
   END IF 
END FUNCTION 

FUNCTION t385_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1

    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("lje01",TRUE)
    END IF

END FUNCTION

FUNCTION t385_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1

    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("lje01",FALSE)
    END IF

END FUNCTION 
FUNCTION t385_delall()
DEFINE l_cnt1      LIKE type_file.num5
DEFINE l_cnt2      LIKE type_file.num5 
   LET l_cnt1 = 0
   LET l_cnt2 = 0
   SELECT COUNT(*) INTO l_cnt1 FROM ljg_file                                                                                   
       WHERE ljg01=g_lje.lje01 AND ljgplant = g_plant
   SELECT COUNT(*) INTO l_cnt2 FROM ljh_file                                                                                   
       WHERE ljh01=g_lje.lje01 AND ljhplant = g_plant    
   IF l_cnt1=0 AND l_cnt2 = 0 THEN
      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
      ERROR g_msg CLIPPED
      DELETE FROM lje_file WHERE lje01 = g_lje.lje01 AND ljeplant = g_plant
      DELETE FROM ljf_file WHERE ljf01 = g_lje.lje01 AND ljfplant = g_plant
      INITIALIZE g_lje.* TO NULL
      CALL g_ljf.clear()
      CALL g_ljg.clear()
      CALL g_ljh.clear()
      CLEAR FORM
   END IF
END FUNCTION
#FUN-BA0118
#FUN-CB0076-------add------str
FUNCTION t385_out()
DEFINE l_sql     LIKE type_file.chr1000, 
       l_rtz13   LIKE rtz_file.rtz13,
       l_lne05   LIKE lne_file.lne05,
       l_gen02   LIKE gen_file.gen02,
       l_lmf13   LIKE lmf_file.lmf13,
       l_lnt60   LIKE lnt_file.lnt60,
       l_lnt10   LIKE lnt_file.lnt10,
       l_lnt33   LIKE lnt_file.lnt33
DEFINE l_img_blob     LIKE type_file.blob
DEFINE sr        RECORD
       ljeplant  LIKE lje_file.ljeplant,
       lje01     LIKE lje_file.lje01,
       lje02     LIKE lje_file.lje02,
       lje04     LIKE lje_file.lje04,
       lje05     LIKE lje_file.lje05,
       lje06     LIKE lje_file.lje06,
       lje07     LIKE lje_file.lje07,
       lje10     LIKE lje_file.lje10,
       lje11     LIKE lje_file.lje11,
       lje12     LIKE lje_file.lje12,
       lje13     LIKE lje_file.lje13,
       lje14     LIKE lje_file.lje14,
       lje15     LIKE lje_file.lje15,
       lje16     LIKE lje_file.lje16,
       lje17     LIKE lje_file.lje17,
       lje18     LIKE lje_file.lje18,
       lje19     LIKE lje_file.lje19,
       lje20     LIKE lje_file.lje20,
       lje21     LIKE lje_file.lje21,
       lje22     LIKE lje_file.lje22,
       lje23     LIKE lje_file.lje23,
       lje26     LIKE lje_file.lje26
                 END RECORD
DEFINE sr5       RECORD
       ljg02     LIKE ljg_file.ljg02, 
       ljg03     LIKE ljg_file.ljg03,
       oaj02     LIKE oaj_file.oaj02,
       oaj05     LIKE oaj_file.oaj05,    
       ljg04     LIKE ljg_file.ljg04
                 END RECORD
DEFINE sr6       RECORD
       ljh02     LIKE ljh_file.ljh02,    
       ljh03     LIKE ljh_file.ljh03, 
       oaj02     LIKE oaj_file.oaj02,
       oaj05     LIKE oaj_file.oaj05,                       
       ljh04     LIKE ljh_file.ljh04
                 END RECORD
DEFINE sr7       RECORD
       ljf02     LIKE ljf_file.ljf02, 
       ljf03     LIKE ljf_file.ljf03,
       oaj02     LIKE oaj_file.oaj02,
       oaj05     LIKE oaj_file.oaj05,    
       ljf04     LIKE ljf_file.ljf04,
       ljf05     LIKE ljf_file.ljf05,
       ljf06     LIKE ljf_file.ljf06
                 END RECORD
     LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,
                        ?,?,?,?,?, ?,?,?,?,?, ?,?,?)"
     PREPARE insert_prep FROM g_sql
     IF STATUS THEN
        CALL cl_err('insert_prep:',status,1)
        CALL cl_used(g_prog, g_time,2) RETURNING g_time
        CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3)
        EXIT PROGRAM
     END IF
  
     LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
               " VALUES(?,?,?,?,?)"
     PREPARE insert_prep1 FROM g_sql
     IF STATUS THEN
        CALL cl_err('insert_prep1:',status,1)
        CALL cl_used(g_prog, g_time,2) RETURNING g_time
        CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3)
        EXIT PROGRAM
     END IF
     LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,
               " VALUES(?,?,?,?,?)"
     PREPARE insert_prep2 FROM g_sql
     IF STATUS THEN
        CALL cl_err('insert_prep2:',status,1)
        CALL cl_used(g_prog, g_time,2) RETURNING g_time
        CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3)
        EXIT PROGRAM
     END IF
     LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table3 CLIPPED,
               " VALUES(?,?,?,?,?, ?,?)"
     PREPARE insert_prep3 FROM g_sql
     IF STATUS THEN
        CALL cl_err('insert_prep3:',status,1)
        CALL cl_used(g_prog, g_time,2) RETURNING g_time
        CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3)
        EXIT PROGRAM
     END IF
     CALL cl_del_data(l_table) 
     CALL cl_del_data(l_table1) 
     CALL cl_del_data(l_table2)
     CALL cl_del_data(l_table3)
     LOCATE l_img_blob IN MEMORY
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     LET l_sql = "SELECT ljeplant,lje01,lje02,lje04,lje05,lje06,lje07,lje10,lje11,lje12,lje13,lje14,",
                 "       lje15,lje16,lje17,lje18,lje19,lje20,lje21,lje22,lje23,lje26",
                 "  FROM lje_file",
                 " WHERE lje01 = '",g_lje.lje01,"'"
     PREPARE t385_prepare1 FROM l_sql
     DECLARE t385_cs1 CURSOR FOR t385_prepare1
     DISPLAY l_table
     FOREACH t385_cs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('prepare:',SQLCA.sqlcode,1)
          CALL cl_used(g_prog,g_time,2) RETURNING g_time
          CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3)
          EXIT PROGRAM
       END IF
       LET l_rtz13 = ' '
       SELECT rtz13 INTO l_rtz13 FROM rtz_file WHERE rtz01 = sr.ljeplant
       LET l_lne05 = ' '
       SELECT lne05 INTO l_lne05 FROM lne_file WHERE lne01 = sr.lje06
       LET l_gen02 = ' '
       SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = sr.lje23
       SELECT lmf13 INTO l_lmf13 FROM lmf_file WHERE lmf01 = sr.lje05
       SELECT lnt60,lnt10,lnt33 INTO l_lnt60,l_lnt10,l_lnt33 FROM lnt_file WHERE lnt01 = sr.lje04
       EXECUTE insert_prep USING sr.*,"",l_img_blob,"N","",l_rtz13,l_lne05,l_gen02,l_lmf13,l_lnt60,l_lnt10,l_lnt33
     END FOREACH
     LET l_sql = "SELECT ljg02,ljg03,'','',ljg04",
                 "  FROM ljg_file",
                 " WHERE ljg01 = '",g_lje.lje01,"'"
     PREPARE t385_prepare2 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3)
        EXIT PROGRAM
     END IF
     DECLARE t385_cs2 CURSOR FOR t385_prepare2
     DISPLAY l_table1
     FOREACH t385_cs2 INTO sr5.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       SELECT oaj02,oaj05 INTO sr5.oaj02,sr5.oaj05 
         FROM oaj_file
        WHERE oaj01 = sr5.ljg03
       EXECUTE insert_prep1 USING sr5.*
     END FOREACH
     LET l_sql = "SELECT ljh02,ljh03,'','',ljh04 ",
                 "  FROM ljh_file",
                 " WHERE ljh01 = '", g_lje.lje01,"'"
     PREPARE t385_prepare3 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3)
        EXIT PROGRAM
     END IF
     DECLARE t385_cs3 CURSOR FOR t385_prepare3
     DISPLAY l_table2
     FOREACH t385_cs3 INTO sr6.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       SELECT oaj02,oaj05 INTO sr6.oaj02,sr6.oaj05 
         FROM oaj_file
        WHERE oaj01 = sr6.ljh03
       EXECUTE insert_prep2 USING sr6.*
     END FOREACH
     LET l_sql = "SELECT ljf02,ljf03,'','',ljf04,ljf05,ljf06",
                 "  FROM ljf_file",
                 " WHERE ljf01 = '", g_lje.lje01,"'"
     PREPARE t385_prepare4 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3)
        EXIT PROGRAM
     END IF
     DECLARE t385_cs4 CURSOR FOR t385_prepare4
     DISPLAY l_table3
     FOREACH t385_cs4 INTO sr7.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       SELECT oaj02,oaj05 INTO sr7.oaj02,sr7.oaj05 
         FROM oaj_file
        WHERE oaj01 = sr7.ljf03
       EXECUTE insert_prep3 USING sr7.*
     END FOREACH
     LET g_cr_table = l_table
     LET g_cr_apr_key_f = "lje01"
     CALL t385_grdata()
END FUNCTION

FUNCTION t385_grdata()
   DEFINE l_sql    STRING
   DEFINE handler  om.SaxDocumentHandler
   DEFINE sr1      sr1_t
   DEFINE sr2      sr2_t
   DEFINE sr3      sr3_t
   DEFINE sr4      sr4_t
   DEFINE l_cnt    LIKE type_file.num10

   LET l_cnt = cl_gre_rowcnt(l_table)
   IF l_cnt <= 0 THEN 
      RETURN 
   END IF
   LOCATE sr1.sign_img IN MEMORY
   CALL cl_gre_init_apr()
   WHILE TRUE
       CALL cl_gre_init_pageheader()            
       LET handler = cl_gre_outnam("almt385")
       IF handler IS NOT NULL THEN
           LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                       " ORDER BY lje01"
           START REPORT almt385_rep TO XML HANDLER handler
           DECLARE almt385_datacur1 CURSOR FROM l_sql
           FOREACH almt385_datacur1 INTO sr1.*
               OUTPUT TO REPORT almt385_rep(sr1.*)
           END FOREACH
           FINISH REPORT almt385_rep
       END IF
       IF INT_FLAG = TRUE THEN
           LET INT_FLAG = FALSE
           EXIT WHILE
       END IF
   END WHILE
   CALL cl_gre_close_report()
END FUNCTION

REPORT almt385_rep(sr1)
    DEFINE sr1           sr1_t
    DEFINE sr2           sr2_t
    DEFINE sr3           sr3_t
    DEFINE sr4           sr4_t
    DEFINE l_lineno      LIKE type_file.num5
    DEFINE l_plant       STRING

    ORDER EXTERNAL BY sr1.lje01
    
    FORMAT
        FIRST PAGE HEADER
           PRINTX g_grPageHeader.*    
           PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name 
              
        BEFORE GROUP OF sr1.lje01
           LET l_lineno = 0

        ON EVERY ROW
           LET l_lineno = l_lineno + 1
           PRINTX l_lineno
           PRINTX sr1.*
           LET l_plant = sr1.ljeplant,' ',sr1.rtz13
           PRINTX l_plant

        AFTER GROUP OF sr1.lje01
           LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
                       " ORDER BY ljg02"
           START REPORT almt385_subrep01
           DECLARE almt385_repcur2 CURSOR FROM g_sql
           FOREACH almt385_repcur2 INTO sr2.*
               OUTPUT TO REPORT almt385_subrep01(sr2.*)
           END FOREACH
           FINISH REPORT almt385_subrep01
           LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED,
                       " ORDER BY ljh02"
           START REPORT almt385_subrep02
           DECLARE almt385_repcur3 CURSOR FROM g_sql
           FOREACH almt385_repcur3 INTO sr3.*
               OUTPUT TO REPORT almt385_subrep02(sr3.*)
           END FOREACH
           FINISH REPORT almt385_subrep02
           LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table3 CLIPPED,
                       " ORDER BY ljf02"
           START REPORT almt385_subrep03
           DECLARE almt385_repcur4 CURSOR FROM g_sql
           FOREACH almt385_repcur4 INTO sr4.*
               OUTPUT TO REPORT almt385_subrep03(sr4.*)
           END FOREACH
           FINISH REPORT almt385_subrep03
 

        ON LAST ROW
END REPORT
REPORT almt385_subrep01(sr2)
    DEFINE sr2          sr2_t
    DEFINE l_oaj05      STRING
 
    FORMAT
        ON EVERY ROW
           PRINTX sr2.*
           LET l_oaj05 = cl_gr_getmsg('gre-316',g_lang,sr2.oaj05)
           PRINTX l_oaj05

END REPORT
REPORT almt385_subrep02(sr3)
    DEFINE sr3 sr3_t
    DEFINE l_oaj05      STRING

    FORMAT
        ON EVERY ROW
           PRINTX sr3.*
           LET l_oaj05 = cl_gr_getmsg('gre-316',g_lang,sr3.oaj05)
           PRINTX l_oaj05

END REPORT
REPORT almt385_subrep03(sr4)
    DEFINE sr4 sr4_t
    DEFINE l_oaj05      STRING
    DEFINE l_ljf05      STRING    

    FORMAT
        ON EVERY ROW
           PRINTX sr4.*
           LET l_oaj05 = cl_gr_getmsg('gre-316',g_lang,sr4.oaj05)
           PRINTX l_oaj05
           LET l_ljf05 = cl_gr_getmsg('gre-332',g_lang,sr4.ljf05)
           PRINTX l_ljf05

END REPORT
#FUN-CB0076-------add------end

