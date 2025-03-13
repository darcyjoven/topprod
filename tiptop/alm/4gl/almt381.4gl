# Prog. Version..: '5.30.06-13.04.09(00006)'     #
#
# Pattern name...: almt381.4gl
# Descriptions...: 合約費用優惠審批單
# Date & Author..: NO.FUN-BA0118 11/11/01 By xumeimei
# Modify.........: No:TQC-C30239 12/03/20 By fanbj 主品牌名稱應帶出tqa03 = '2' 的資料
# Modify.........: No.CHI-C30002 12/05/18 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.CHI-C30107 12/06/11 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No.FUN-CB0076 12/11/15 By xumeimei 添加GR打印功能
# Modify.........: No:CHI-C80041 13/01/21 By bart 1.增加作廢功能 2.刪除單頭
# Modify.........: No.CHI-D20015 13/03/27 By qiull 統一確認和取消確認時確認人員和確認日期的寫法

DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE   g_lja          RECORD LIKE lja_file.*,
         g_lja_t        RECORD LIKE lja_file.*,
         g_lja01        LIKE lja_file.lja01,
         g_lja01_t      LIKE lja_file.lja01,
         g_ljb          DYNAMIC ARRAY OF RECORD
                        ljb02        LIKE ljb_file.ljb02,
                        ljb03        LIKE ljb_file.ljb03,
                        ljb04        LIKE ljb_file.ljb04,
                        oaj02        LIKE oaj_file.oaj02,
                        ljb05        LIKE ljb_file.ljb05,
                        ljb06        LIKE ljb_file.ljb06,
                        ljb07        LIKE ljb_file.ljb07,
                        ljb08        LIKE ljb_file.ljb08
                        END RECORD,
         g_ljc          DYNAMIC ARRAY OF RECORD
                        ljc02        LIKE ljc_file.ljc02,
                        ljc03        LIKE ljc_file.ljc03,
                        ljc04        LIKE ljc_file.ljc04,
                        ljc05        LIKE ljc_file.ljc05,
                        ljb03_5      LIKE ljb_file.ljb03,
                        ljc06        LIKE ljc_file.ljc06,
                        oaj02_1      LIKE oaj_file.oaj02,
                        ljc07        LIKE ljc_file.ljc07,
                        ljc08        LIKE ljc_file.ljc08,
                        ljc09        LIKE ljc_file.ljc09,
                        ljc10        LIKE ljc_file.ljc10
                        END RECORD,       
         g_ljd          DYNAMIC ARRAY OF RECORD
                        ljd02        LIKE ljd_file.ljd02,
                        ljdplant     LIKE ljd_file.ljdplant,
                        rtz13_1      LIKE rtz_file.rtz13,
                        ljd03        LIKE ljd_file.ljd03,
                        ljd04        LIKE ljd_file.ljd04,
                        ljd05        LIKE ljd_file.ljd05,
                        ljd06        LIKE ljd_file.ljd06,
                        ljd07        LIKE ljd_file.ljd07,
                        ljd08        LIKE ljd_file.ljd08,
                        oba02_1      LIKE oba_file.oba02
                        END RECORD,
         g_ljb_t        RECORD
                        ljb02        LIKE ljb_file.ljb02,
                        ljb03        LIKE ljb_file.ljb03,
                        ljb04        LIKE ljb_file.ljb04,
                        oaj02        LIKE oaj_file.oaj02,
                        ljb05        LIKE ljb_file.ljb05,
                        ljb06        LIKE ljb_file.ljb06,
                        ljb07        LIKE ljb_file.ljb07,
                        ljb08        LIKE ljb_file.ljb08
                        END RECORD,
         g_ljc_t        RECORD
                        ljc02        LIKE ljc_file.ljc02,
                        ljc03        LIKE ljc_file.ljc03,
                        ljc04        LIKE ljc_file.ljc04,
                        ljc05        LIKE ljc_file.ljc05,
                        ljb03_5      LIKE ljb_file.ljb03,
                        ljc06        LIKE ljc_file.ljc06,
                        oaj02_1      LIKE oaj_file.oaj02,
                        ljc07        LIKE ljc_file.ljc07,
                        ljc08        LIKE ljc_file.ljc08,
                        ljc09        LIKE ljc_file.ljc09,
                        ljc10        LIKE ljc_file.ljc10
                        END RECORD,
         g_ljd_t        RECORD
                        ljd02        LIKE ljd_file.ljd02,
                        ljdplant     LIKE ljd_file.ljdplant,
                        rtz13_1      LIKE rtz_file.rtz13,
                        ljd03        LIKE ljd_file.ljd03,
                        ljd04        LIKE ljd_file.ljd04,
                        ljd05        LIKE ljd_file.ljd05,
                        ljd06        LIKE ljd_file.ljd06,
                        ljd07        LIKE ljd_file.ljd07,
                        ljd08        LIKE ljd_file.ljd08,
                        oba02_1      LIKE oba_file.oba02
                        END RECORD                          
DEFINE   p_row,p_col    LIKE type_file.num5
DEFINE   g_row_count    LIKE type_file.num10
DEFINE   g_curs_index   LIKE type_file.num10
DEFINE   g_i            LIKE type_file.num5
DEFINE   g_wc           STRING
DEFINE   g_wc1          STRING
DEFINE   g_wc2          STRING
DEFINE   g_wc3          STRING
DEFINE   g_sql          STRING
DEFINE   g_rec_b1       LIKE type_file.num5
DEFINE   g_rec_b2       LIKE type_file.num5
DEFINE   g_rec_b3       LIKE type_file.num5
DEFINE   g_before_input_done  LIKE type_file.num5
DEFINE   g_forupd_sql   STRING
DEFINE   g_msg          LIKE type_file.chr1000
DEFINE   g_cnt          LIKE type_file.num5
DEFINE   g_jump         LIKE type_file.num10
DEFINE   g_flag_b       LIKE type_file.chr1
DEFINE   mi_no_ask      LIKE type_file.num5
DEFINE   g_void         LIKE type_file.chr1
DEFINE   l_ac           LIKE type_file.num5
DEFINE   g_chr          LIKE type_file.chr1
DEFINE   g_t1           LIKE oay_file.oayslip
DEFINE   g_lla04        LIKE lla_file.lla04
#FUN-CB0076----add---str
DEFINE   l_table        STRING
DEFINE   l_table1       STRING
DEFINE   l_table2       STRING
TYPE     sr1_t          RECORD
         ljaplant       LIKE lja_file.ljaplant,
         lja01          LIKE lja_file.lja01,
         lja05          LIKE lja_file.lja05,
         lja12          LIKE lja_file.lja12,
         lja03          LIKE lja_file.lja03,
         lja14          LIKE lja_file.lja14,
         lja06          LIKE lja_file.lja06,
         lja04          LIKE lja_file.lja04,
         lja15          LIKE lja_file.lja15,
         lja20          LIKE lja_file.lja20,
         lja07          LIKE lja_file.lja07,
         lja10          LIKE lja_file.lja10,
         ljb02          LIKE ljb_file.ljb02,
         ljb03          LIKE ljb_file.ljb03,
         ljb04          LIKE ljb_file.ljb04,
         ljb05          LIKE ljb_file.ljb05,
         ljb06          LIKE ljb_file.ljb06,
         ljb07          LIKE ljb_file.ljb07,
         ljb08          LIKE ljb_file.ljb08,
         sign_type      LIKE type_file.chr1,
         sign_img       LIKE type_file.blob,
         sign_show      LIKE type_file.chr1,
         sign_str       LIKE type_file.chr1000,
         rtz13          LIKE rtz_file.rtz13,
         lne05          LIKE lne_file.lne05,
         gen02          LIKE gen_file.gen02,
         oaj02          LIKE oaj_file.oaj02,
         lmf13          LIKE lmf_file.lmf13,
         lnt60          LIKE lnt_file.lnt60,
         lnt10          LIKE lnt_file.lnt10,
         lnt33          LIKE lnt_file.lnt33
                        END RECORD
TYPE     sr2_t          RECORD
         ljc01          LIKE ljc_file.ljc01,
         ljc02          LIKE ljc_file.ljc02,
         ljc03          LIKE ljc_file.ljc03,
         ljb03_1        LIKE ljb_file.ljb03,
         ljc04          LIKE ljc_file.ljc04,
         ljc05          LIKE ljc_file.ljc05,
         ljc06          LIKE ljc_file.ljc06,
         ljc07          LIKE ljc_file.ljc07,
         ljc08          LIKE ljc_file.ljc08,
         ljc09          LIKE ljc_file.ljc09,
         ljc10          LIKE ljc_file.ljc10
                        END RECORD
TYPE     sr3_t          RECORD
         ljd02          LIKE ljd_file.ljd02,
         ljd03          LIKE ljd_file.ljd03,
         ljd04          LIKE ljd_file.ljd04,
         ljd05          LIKE ljd_file.ljd05,
         ljd06          LIKE ljd_file.ljd06,
         ljd07          LIKE ljd_file.ljd07,
         ljd08          LIKE ljd_file.ljd08
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
   LET g_sql ="ljaplant.lja_file.ljaplant,",
              "lja01.lja_file.lja01,",
              "lja05.lja_file.lja05,",
              "lja12.lja_file.lja12,",
              "lja03.lja_file.lja03,",
              "lja14.lja_file.lja14,",
              "lja06.lja_file.lja06,",
              "lja04.lja_file.lja04,",
              "lja15.lja_file.lja15,",
              "lja20.lja_file.lja20,",
              "lja07.lja_file.lja07,",
              "lja10.lja_file.lja10,",
              "ljb02.ljb_file.ljb02,",
              "ljb03.ljb_file.ljb03,",
              "ljb04.ljb_file.ljb04,",
              "ljb05.ljb_file.ljb05,",
              "ljb06.ljb_file.ljb06,",
              "ljb07.ljb_file.ljb07,",
              "ljb08.ljb_file.ljb08,",
              "sign_type.type_file.chr1,",
              "sign_img.type_file.blob,",
              "sign_show.type_file.chr1,",
              "sign_str.type_file.chr1000,",
              "rtz13.rtz_file.rtz13,",
              "lne05.lne_file.lne05,",
              "gen02.gen_file.gen02,",
              "oaj02.oaj_file.oaj02,",
              "lmf13.lmf_file.lmf13,",
              "lnt60.lnt_file.lnt60,",
              "lnt10.lnt_file.lnt10,",
              "lnt33.lnt_file.lnt33"
   LET l_table = cl_prt_temptable('almt381',g_sql) CLIPPED
   IF l_table = -1 THEN
      CALL cl_used(g_prog, g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)
      EXIT PROGRAM
   END IF
   LET g_sql ="ljc01.ljc_file.ljc01,",
              "ljc02.ljc_file.ljc02,",
              "ljc03.ljc_file.ljc03,",
              "ljb03_1.ljb_file.ljb03,",
              "ljc04.ljc_file.ljc04,",
              "ljc05.ljc_file.ljc05,",
              "ljc06.ljc_file.ljc06,",
              "ljc07.ljc_file.ljc07,",
              "ljc08.ljc_file.ljc08,",
              "ljc09.ljc_file.ljc09,",
              "ljc10.ljc_file.ljc10"
   LET l_table1 = cl_prt_temptable('almt3811',g_sql) CLIPPED
   IF l_table1 = -1 THEN
      CALL cl_used(g_prog, g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)
      EXIT PROGRAM
   END IF
   LET g_sql ="ljd02.ljd_file.ljd02,",
              "ljd03.ljd_file.ljd03,",
              "ljd04.ljd_file.ljd04,",
              "ljd05.ljd_file.ljd05,",
              "ljd06.ljd_file.ljd06,",
              "ljd07.ljd_file.ljd07,",
              "ljd08.ljd_file.ljd08"
   LET l_table2 = cl_prt_temptable('almt3812',g_sql) CLIPPED
   IF l_table2 = -1 THEN
      CALL cl_used(g_prog, g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)
      EXIT PROGRAM
   END IF
   #FUN-CB0076------add-----end
   LET g_forupd_sql= " SELECT * FROM lja_file WHERE lja01 = ? FOR UPDATE  "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t381_cl CURSOR FROM g_forupd_sql
 
 
   OPEN WINDOW t381_w WITH FORM "alm/42f/almt381"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_set_locale_frm_name("almt381") 

   CALL cl_ui_init()

   SELECT lla04 INTO g_lla04 FROM lla_file
    WHERE llastore = g_plant
   CALL t381_menu()
 
   CLOSE WINDOW t381_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
   CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)    #FUN-CB0076 add
END MAIN


FUNCTION t381_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01
DEFINE  l_table         LIKE    type_file.chr1000
DEFINE  l_where         LIKE    type_file.chr1000

      CLEAR FORM
      LET g_action_choice=" " 
      CALL cl_set_head_visible("","YES")
      INITIALIZE g_lja.* TO NULL
      DIALOG ATTRIBUTES(UNBUFFERED) 
        CONSTRUCT BY NAME g_wc ON
                  lja01,lja03,lja04,ljaplant,ljalegal,lja05,lja06,lja12,lja07,
                  lja13,lja08,lja09,lja10,lja14,lja15,lja16,lja17,lja18,ljamksg,
                  lja21,ljaconf,ljaconu,ljacond,ljacont,lja20,ljauser,ljagrup,
                  ljaoriu,ljamodu,ljadate,ljaorig,ljaacti,ljacrat
                      
        BEFORE CONSTRUCT
           CALL cl_qbe_display_condition(lc_qbe_sn) 
 
        ON ACTION controlp
           CASE WHEN INFIELD(lja01)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = "c"
                     LET g_qryparam.form = "q_lja01"
                     LET g_qryparam.default1 = g_lja.lja01
                     LET g_qryparam.where = "lja02 = '1'"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO lja01
                     NEXT FIELD lja01
              
                WHEN INFIELD(lja04)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = "c"
                     LET g_qryparam.form = "q_lja04"
                     LET g_qryparam.default1 = g_lja.lja04
                     LET g_qryparam.where = "lja02 = '1'"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO lja04
                     NEXT FIELD lja04
                  
                WHEN INFIELD(ljaplant)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = "c"
                     LET g_qryparam.form = "q_ljaplant"
                     LET g_qryparam.default1 = g_lja.ljaplant
                     LET g_qryparam.where = "lja02 = '1'"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO ljaplant
                     NEXT FIELD ljaplant
                        
                WHEN INFIELD(ljalegal)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = "c"
                     LET g_qryparam.form = "q_ljalegal"
                     LET g_qryparam.default1 = g_lja.ljalegal
                     LET g_qryparam.where = "lja02 = '1'"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO ljalegal
                     NEXT FIELD ljalegal
                   
                WHEN INFIELD(lja05)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = "c"
                     LET g_qryparam.form = "q_lja05"
                     LET g_qryparam.default1 = g_lja.lja05
                     LET g_qryparam.where = "lja02 = '1'"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO lja05
                     NEXT FIELD lja05
                      
                WHEN INFIELD(lja06)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = "c"
                     LET g_qryparam.form = "q_lja06"
                     LET g_qryparam.default1 = g_lja.lja06
                     LET g_qryparam.where = "lja02 = '1'"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO lja06
                     NEXT FIELD lja06  
  
                WHEN INFIELD(lja12)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = "c"
                     LET g_qryparam.form = "q_lja12"
                     LET g_qryparam.default1 = g_lja.lja12
                     LET g_qryparam.where = "lja02 = '1'"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO lja12
                     NEXT FIELD lja12 
                      
                WHEN INFIELD(lja07)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = "c"
                     LET g_qryparam.form = "q_lja07"
                     LET g_qryparam.default1 = g_lja.lja07
                     LET g_qryparam.where = "lja02 = '1'"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO lja07
                     NEXT FIELD lja07  
                  
                WHEN INFIELD(lja13)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = "c"
                     LET g_qryparam.form = "q_lja13"
                     LET g_qryparam.default1 = g_lja.lja13
                     LET g_qryparam.where = "lja02 = '1'"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO lja13
                     NEXT FIELD lja13     
                
                WHEN INFIELD(ljaconu)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = "c"
                     LET g_qryparam.form = "q_ljaconu"
                     LET g_qryparam.default1 = g_lja.ljaconu
                     LET g_qryparam.where = "lja02 = '1'"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO ljaconu
                     NEXT FIELD ljaconu
          
           END CASE
      
        END CONSTRUCT

        CONSTRUCT g_wc1 ON ljb02,ljb03,ljb04,ljb05,ljb06,ljb07,ljb08
             FROM s_ljb[1].ljb02,s_ljb[1].ljb03,s_ljb[1].ljb04,
                  s_ljb[1].ljb05,s_ljb[1].ljb06,s_ljb[1].ljb07,s_ljb[1].ljb08
                
        BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)

            ON ACTION CONTROLP
            CASE
               WHEN INFIELD(ljb04) 
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = 'c'
                    LET g_qryparam.form ="q_ljb04"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO ljb04
                    NEXT FIELD ljb04
                    
            END CASE

        END CONSTRUCT

        CONSTRUCT g_wc2 ON ljc02,ljc03,ljc04,ljc05,ljc06,ljc07,ljc08,ljc09,ljc10
             FROM s_ljc[1].ljc02,s_ljc[1].ljc03,s_ljc[1].ljc04,s_ljc[1].ljc05,s_ljc[1].ljc06,
                  s_ljc[1].ljc07,s_ljc[1].ljc08,s_ljc[1].ljc09,s_ljc[1].ljc10
                  
                
        BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)

            ON ACTION CONTROLP
            CASE
               WHEN INFIELD(ljc04)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = 'c'
                    LET g_qryparam.form ="q_ljc04"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO ljc04
                    NEXT FIELD ljc04

               WHEN INFIELD(ljc06) 
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = 'c'
                    LET g_qryparam.form ="q_ljc06" 
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO ljc06
                    NEXT FIELD ljc06
                    
            END CASE
      
        END CONSTRUCT
        
        CONSTRUCT g_wc3 ON ljd02,ljdplant,ljd03,ljd04,ljd05,ljd06,ljd07,ljd08
             FROM s_ljd[1].ljd02,s_ljd[1].ljdplant,s_ljd[1].ljd03,s_ljd[1].ljd04,
                  s_ljd[1].ljd05,s_ljd[1].ljd06,s_ljd[1].ljd07,s_ljd[1].ljd08
                  
                
        BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)

            ON ACTION CONTROLP
            CASE
              WHEN INFIELD(ljdplant)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = 'c'
                    LET g_qryparam.form ="q_ljdplant"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO ljdplant
                    NEXT FIELD ljdplant

               WHEN INFIELD(ljd03) 
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = 'c'
                    LET g_qryparam.form ="q_ljd03"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO ljd03
                    NEXT FIELD ljd03

               WHEN INFIELD(ljd04) 
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = 'c'
                    LET g_qryparam.form ="q_ljd04"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO ljd04
                    NEXT FIELD ljd04

               WHEN INFIELD(ljd08) 
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = 'c'
                    LET g_qryparam.form ="q_ljd08" 
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO ljd08
                    NEXT FIELD ljd08
                    
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
        
      ON ACTION qbe_select
         CALL cl_qbe_select()     
 
      ON ACTION qbe_save
         CALL cl_qbe_save() 
        
         
      ON ACTION ACCEPT
         ACCEPT DIALOG

      ON ACTION cancel
         LET INT_FLAG = 1
         EXIT DIALOG
         
     END DIALOG
     IF INT_FLAG THEN
        RETURN
     END IF
   LET g_sql = "SELECT UNIQUE(lja01) " 
   LET l_table = " FROM lja_file"
   LET l_where = " WHERE lja02 ='1' AND ",g_wc
   IF g_wc3 <> " 1=1" THEN
      LET l_table = l_table,",ljd_file"
      LET l_where = l_where," AND lja01 = ljd01 AND ",g_wc3
   END IF
   IF g_wc2 <> " 1=1" THEN
      LET l_table = l_table,",ljc_file"
      LET l_where = l_where," AND lja01 = ljc01 AND ",g_wc2
   END IF
   IF g_wc1 <> " 1=1" THEN
      LET l_table = l_table,",ljb_file"
      LET l_where = l_where," AND lja01 = ljb01 AND ",g_wc1
   END IF
   IF g_wc1 <> " 1=1" AND g_wc2 <> " 1=1" AND g_wc3 <> " 1=1" THEN
      LET l_table = l_table,",ljb_file",",ljc_file",",ljd_file"
      LET l_where = l_where," AND lja01 = ljb01 AND ljb01 = ljc01 AND ljc01 = ljd01 AND ",g_wc1," AND ",g_wc2," AND ",g_wc3
   END IF
   LET g_sql = g_sql,l_table,l_where," ORDER BY lja01"
 
   PREPARE t381_prepare FROM g_sql
   DECLARE t381_cs SCROLL CURSOR WITH HOLD FOR t381_prepare
 
   LET g_sql = "SELECT COUNT(DISTINCT lja01) ",l_table,l_where
   PREPARE t381_precount FROM g_sql
   DECLARE t381_count CURSOR FOR t381_precount
END FUNCTION
 
FUNCTION t381_menu()
 
   WHILE TRUE
      IF g_action_choice = "exit"  THEN
         EXIT WHILE
      END IF
      CALL t381_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t381_a()
            END IF
 
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t381_q()
            END IF
 
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t381_r()
            END IF
 
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t381_u()
            END IF
         #FUN-CB0076------add----str
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL t381_out()
            END IF
         #FUN-CB0076------add----end
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL t381_x()
            END IF
            CALL t381_pic()
            
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t381_b1()
            END IF
        
         WHEN "exporttoexcel"                                                                                                       
            IF cl_chk_act_auth() THEN  
                CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ljb),base.TypeInfo.create(g_ljc),base.TypeInfo.create(g_ljd))   
            END IF

         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "confirm"                                                                                                             
            IF cl_chk_act_auth() THEN            
               CALL t381_confirm()
               CALL t381_pic()
            END IF  

         WHEN "unconfirm"                                                                                                             
            IF cl_chk_act_auth() THEN            
               CALL t381_unconfirm()
               CALL t381_pic()
            END IF                                                                                                                                         
            
         WHEN "controlg"
            CALL cl_cmdask()
 
         WHEN "related_document"
            IF cl_chk_act_auth() THEN
               IF g_lja01 IS NOT NULL THEN
                  LET g_doc.column1 = "lja01"
                  LET g_doc.value1 = g_lja.lja01
                  CALL cl_doc()
               END IF 
            END IF
         #CHI-C80041---begin
         WHEN "void"
            IF cl_chk_act_auth() THEN
               CALL t381_v()
               CALL t381_pic()
            END IF
         #CHI-C80041---end 
      END CASE
   END WHILE
END FUNCTION

FUNCTION t381_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DIALOG ATTRIBUTES(UNBUFFERED)
      DISPLAY ARRAY g_ljb TO s_ljb.* ATTRIBUTE(COUNT=g_rec_b1)

        BEFORE DISPLAY
          CALL cl_navigator_setting( g_curs_index, g_row_count )
          DISPLAY g_rec_b1 TO FORMONLY.cn2

        BEFORE ROW
          LET l_ac = ARR_CURR()
          CALL cl_show_fld_cont()
      END DISPLAY  

      DISPLAY ARRAY g_ljc TO s_ljc.* ATTRIBUTE(COUNT=g_rec_b2)

        BEFORE DISPLAY
          CALL cl_navigator_setting( g_curs_index, g_row_count )
          DISPLAY g_rec_b2 TO FORMONLY.cn2

        BEFORE ROW
          LET l_ac = ARR_CURR()
          CALL cl_show_fld_cont()
      END DISPLAY  

      DISPLAY ARRAY g_ljd TO s_ljd.* ATTRIBUTE(COUNT=g_rec_b3)

        BEFORE DISPLAY
          CALL cl_navigator_setting( g_curs_index, g_row_count )
          DISPLAY g_rec_b3 TO FORMONLY.cn2
        BEFORE ROW
          LET l_ac = ARR_CURR()
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

      ON ACTION MODIFY
         LET g_action_choice="modify"
         EXIT DIALOG
      #FUN-CB0076------add-----str
      ON ACTION OUTPUT
         LET g_action_choice="output"
         EXIT DIALOG 
      #FUN-CB0076------add-----end
      ON ACTION FIRST
         CALL t381_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG 

      ON ACTION PREVIOUS
         CALL t381_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG 

      ON ACTION jump
         CALL t381_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG 

      ON ACTION NEXT
         CALL t381_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG 

      ON ACTION LAST
         CALL t381_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG 

      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DIALOG 

      ON ACTION unconfirm
         LET g_action_choice="unconfirm"
         EXIT DIALOG
      #CHI-C80041---begin
      ON ACTION void
         LET g_action_choice="void"
         EXIT DIALOG 
      #CHI-C80041---end 
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DIALOG 

      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
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

      ON ACTION ACCEPT
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
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

      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG 

      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")

      ON ACTION related_document
         LET g_action_choice="related_document"
         EXIT DIALOG 
   END DIALOG 
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION


FUNCTION t381_desc()
DEFINE l_lja04_desc  LIKE gen_file.gen02
DEFINE l_rtz13       LIKE rtz_file.rtz13
DEFINE l_azt02       LIKE azt_file.azt02
DEFINE l_lne05       LIKE lne_file.lne05
DEFINE l_oba02       LIKE oba_file.oba02
DEFINE l_tqa02       LIKE tqa_file.tqa02
DEFINE l_gen02       LIKE gen_file.gen02
DEFINE l_money       LIKE ljb_file.ljb07

   SELECT gen02 INTO l_lja04_desc FROM gen_file WHERE gen01 = g_lja.lja04
   DISPLAY l_lja04_desc TO FORMONLY.lja04_desc

   SELECT rtz13 INTO l_rtz13 FROM rtz_file WHERE rtz01 = g_lja.ljaplant
   DISPLAY l_rtz13 TO FORMONLY.rtz13

   SELECT azt02 INTO l_azt02 FROM azt_file WHERE azt01 = g_lja.ljalegal
   DISPLAY l_azt02 TO FORMONLY.azt02

   SELECT lne05 INTO l_lne05 FROM lne_file WHERE lne01 = g_lja.lja12
   DISPLAY l_lne05 TO FORMONLY.lne05

   SELECT oba02 INTO l_oba02 FROM oba_file WHERE oba01 = g_lja.lja07
   DISPLAY l_oba02 TO FORMONLY.oba02

   #SELECT tqa02 INTO l_tqa02 FROM tqa_file WHERE tqa01 = g_lja.lja13   #TQC-C30239 mark
   SELECT tqa02 INTO l_tqa02 FROM tqa_file WHERE tqa01 = g_lja.lja13 AND tqa03 = '2'  #TQC-C30239 add 
   DISPLAY l_tqa02 TO FORMONLY.tqa02

   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = g_lja.ljaconu
   DISPLAY l_gen02 TO FORMONLY.gen02

   SELECT SUM(ljb07) INTO l_money FROM ljb_file WHERE ljb01 = g_lja.lja01
   DISPLAY l_money TO FORMONLY.money
END FUNCTION

FUNCTION t381_a()
DEFINE li_result   LIKE type_file.num5
DEFINE l_n         LIKE type_file.num5
 
   IF s_shut(0) THEN RETURN END IF
   MESSAGE ""
   CLEAR FORM
 
   CALL g_ljb.clear()
   CALL g_ljc.clear()
   CALL g_ljd.clear()
 
   INITIALIZE g_lja.*  LIKE lii_file.* 
   LET g_lja01_t = NULL
   LET g_lja_t.* = g_lja.*
   CALL cl_opmsg('a')
   WHILE TRUE
       LET g_lja.lja02 = '1'
       LET g_lja.lja04 = g_user
       LET g_lja.lja03 = g_today
       LET g_lja.ljaplant = g_plant
       LET g_lja.ljalegal = g_legal
       LET g_lja.ljamksg = 'N'
       LET g_lja.lja21 = '0'
       LET g_lja.ljaconf = 'N'
       LET g_lja.ljauser = g_user
       LET g_lja.ljagrup = g_grup
       LET g_lja.ljadate = g_today
       LET g_lja.ljaacti = 'Y'
       LET g_lja.ljacrat = g_today
       LET g_lja.ljaoriu = g_user 
       LET g_lja.ljaorig = g_grup 
       CALL cl_set_comp_entry("lja12,lja06,lja14,lja15,lja16",TRUE)
       CALL t381_desc()
       CALL t381_i("a")
       IF INT_FLAG THEN
           INITIALIZE g_lja.* TO NULL
           LET INT_FLAG = 0
           CALL cl_err('',9001,0)
           CLEAR FORM
           CALL g_ljb.clear()
           CALL g_ljc.clear()
           CALL g_ljd.clear()
           EXIT WHILE
       END IF
       IF g_lja.lja01 IS NULL OR g_lja.ljaplant IS NULL THEN
          CONTINUE WHILE
       END IF
       BEGIN WORK
       CALL s_auto_assign_no("alm",g_lja.lja01,g_today,"P4","lja_file","lja01","","","")
          RETURNING li_result,g_lja.lja01
       IF (NOT li_result) THEN   
           ROLLBACK WORK                                                                        
           CONTINUE WHILE                                                                     
       END IF
       DISPLAY BY NAME g_lja.lja01
       
       INSERT INTO lja_file VALUES(g_lja.*)     
       IF SQLCA.SQLCODE OR SQLCA.sqlerrd[3]=0 THEN
          CALL cl_err3("ins","lja_file",g_lja.lja01,"",SQLCA.SQLCODE,"","",1)
          ROLLBACK WORK
          CONTINUE WHILE
       ELSE
          COMMIT WORK
          CALL cl_flow_notify(g_lja.lja01,'I')
       END IF
       LET g_rec_b1=0
       LET g_rec_b2=0
       LET g_rec_b3=0
       CALL t381_b1()
       CALL t381_ins_ljc()
       CALL t381_ins_ljd()
       EXIT WHILE
   END WHILE
END FUNCTION

FUNCTION t381_delall()
DEFINE l_cnt1      LIKE type_file.num5
 
   LET l_cnt1 = 0
   SELECT COUNT(*) INTO l_cnt1 FROM ljb_file                                                                                   
       WHERE ljb01=g_lja.lja01 AND ljbplant = g_plant
   IF l_cnt1=0  THEN
      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
      ERROR g_msg CLIPPED
      DELETE FROM lja_file WHERE lja01 = g_lja.lja01 AND ljaplant = g_plant
      INITIALIZE g_lja.* TO NULL
      CALL g_ljb.clear()
      CALL g_ljc.clear()
      CALL g_ljd.clear()
      CLEAR FORM
   END IF
END FUNCTION
 
FUNCTION t381_u()

   IF s_shut(0) THEN
      RETURN
   END IF
   IF g_lja.lja01 IS NULL OR g_lja.ljaplant IS NULL THEN 
      CALL cl_err('',-400,0) RETURN 
   END IF
   SELECT * INTO g_lja.* FROM lja_file WHERE lja01 = g_lja.lja01
 
   IF g_lja.ljaconf='Y' THEN 
      CALL cl_err('','9022',0) 
      RETURN
   END IF   
   IF g_lja.ljaconf='X' THEN RETURN END IF  #CHI-C80041
   IF g_lja.ljaacti = 'N' THEN                                                                                                      
      CALL cl_err('','mfg1000',0)                                                                                                   
      RETURN                                                                                                                        
   END IF
 
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_lja01_t = g_lja.lja01
   LET g_lja_t.* = g_lja.*
   BEGIN WORK
   OPEN t381_cl USING g_lja.lja01
   IF STATUS THEN
      CALL cl_err("OPEN t381_cl:", STATUS, 1)
      CLOSE t381_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t381_cl INTO g_lja.*
   IF SQLCA.SQLCODE THEN
      CALL cl_err(g_lja.lja01,SQLCA.SQLCODE,0)
      CLOSE t381_cl 
      ROLLBACK WORK 
      RETURN
   END IF
   CALL t381_show()
   WHILE TRUE
      LET g_lja01_t = g_lja.lja01
      LET g_lja.ljamodu = g_user
      LET g_lja.ljadate = g_today
      CALL t381_i("u")
      IF INT_FLAG THEN
          LET INT_FLAG = 0
          LET g_lja.*=g_lja_t.*
          CALL t381_show()
          CALL cl_err('','9001',0)
          EXIT WHILE
      END IF

      IF g_lja.lja01 != g_lja01_t THEN
         UPDATE lja_file SET lja01 = g_lja.lja01
          WHERE lja01 = g_lja01_t
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","lja_file",g_lja01_t,"",SQLCA.sqlcode,"","lja",1)
            CONTINUE WHILE
         END IF
      END IF

      UPDATE lja_file SET lja_file.* = g_lja.* WHERE lja01 = g_lja.lja01 
      IF SQLCA.SQLCODE OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","lja_file",g_lja.lja01,"",SQLCA.SQLCODE,"","",1)  
         CONTINUE WHILE
      END IF
      IF NOT cl_null(g_lja.lja05) THEN
         IF g_lja.lja05 <> g_lja_t.lja05 OR cl_null(g_lja_t.lja05)  OR g_lja.lja12 <> g_lja_t.lja12 THEN
            CALL g_ljc.clear()
            DELETE  FROM ljc_file WHERE ljc01 = g_lja.lja01
            CALL t381_ins_ljc()
            IF g_lja.lja12 <> g_lja_t.lja12 THEN
               CALL g_ljd.clear()
               DELETE  FROM ljd_file WHERE ljd01 = g_lja.lja01
               CALL t381_ins_ljd()
            END IF
         END IF
      END IF
      
      IF cl_null(g_lja.lja05) THEN
         IF NOT cl_null(g_lja_t.lja05) OR g_lja.lja06 <> g_lja_t.lja06 OR g_lja.lja12 <> g_lja_t.lja12 THEN
            CALL g_ljc.clear()
            DELETE  FROM ljc_file WHERE ljc01 = g_lja.lja01
            CALL t381_ins_ljc()
            IF g_lja.lja12 <> g_lja_t.lja12 THEN   
               CALL g_ljd.clear()
               DELETE  FROM ljd_file WHERE ljd01 = g_lja.lja01
               CALL t381_ins_ljd()
            END IF
         END IF
      END IF
     
      EXIT WHILE
   END WHILE
   CLOSE t381_cl
   COMMIT WORK
   CALL cl_flow_notify(g_lja.lja01,'U')
   CALL t381_b1_fill("1=1")
   CALL t381_bp1_refresh()
   CALL t381_delall()
END FUNCTION
 
FUNCTION t381_i(p_cmd)
   DEFINE p_cmd        LIKE type_file.chr1,
          l_n          LIKE type_file.num5,
          l_sma53      LIKE sma_file.sma53,
          l_oba15      LIKE oba_file.oba15,
          l_llc02      LIKE llc_file.llc02,
          li_result    LIKE type_file.num5


   DISPLAY BY NAME g_lja.lja01,g_lja.lja03,g_lja.lja04,g_lja.ljaplant,g_lja.ljalegal,g_lja.lja05,
      g_lja.lja06,g_lja.lja12,g_lja.lja07,g_lja.lja13,g_lja.lja08,g_lja.lja09,g_lja.lja10,
      g_lja.lja14,g_lja.lja15,g_lja.lja16,g_lja.lja17,g_lja.lja18,g_lja.ljamksg,g_lja.lja21,
      g_lja.ljaconf,g_lja.ljaconu,g_lja.ljacont,g_lja.lja20,g_lja.ljauser,g_lja.ljagrup,
      g_lja.ljaoriu,g_lja.ljamodu,g_lja.ljadate,g_lja.ljaorig,g_lja.ljaacti,g_lja.ljacrat
   CALL t381_desc()
   INPUT BY NAME g_lja.lja01,g_lja.lja03,g_lja.lja04,g_lja.ljaplant,g_lja.ljalegal,g_lja.lja05,
      g_lja.lja06,g_lja.lja12,g_lja.lja07,g_lja.lja13,g_lja.lja08,g_lja.lja09,g_lja.lja10,
      g_lja.lja14,g_lja.lja15,g_lja.lja16,g_lja.lja17,g_lja.lja18,g_lja.ljamksg,g_lja.lja21,
      g_lja.ljaconf,g_lja.ljaconu,g_lja.ljacont,g_lja.lja20,g_lja.ljauser,g_lja.ljagrup,
      g_lja.ljaoriu,g_lja.ljamodu,g_lja.ljadate,g_lja.ljaorig,g_lja.ljaacti,g_lja.ljacrat
      WITHOUT DEFAULTS
      BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL t381_set_entry(p_cmd)
           CALL t381_set_no_entry(p_cmd)
           CALL cl_set_docno_format("lja01")
           LET g_before_input_done = TRUE
 
       AFTER FIELD lja01
           IF NOT cl_null(g_lja.lja01) THEN
              IF (p_cmd='a') OR (p_cmd='u' AND g_lja.lja01!=g_lja_t.lja01) THEN
                 CALL s_check_no("alm",g_lja.lja01,g_lja01_t,"P4","lja_file","lja01","")  
                    RETURNING li_result,g_lja.lja01
                 IF (NOT li_result) THEN                                                            
                    LET g_lja.lja01=g_lja_t.lja01                                                                 
                    NEXT FIELD lja01                                                                                      
                 END IF
                 LET g_t1=s_get_doc_no(g_lja.lja01)
                 SELECT oayapr INTO g_lja.ljamksg FROM oay_file WHERE oayslip = g_t1
                 DISPLAY BY NAME g_lja.ljamksg
              END IF
           END IF

      AFTER FIELD lja03
           IF NOT cl_null(g_lja.lja03) THEN
              SELECT sma53 INTO l_sma53 FROM sma_file
              IF g_lja.lja03 < l_sma53 THEN
                 CALL cl_err('','alm1140',0)
                 LET g_lja.lja03 = g_lja_t.lja03
                 NEXT FIELD lja03
              END IF
           END IF

      AFTER FIELD lja04
           IF NOT cl_null(g_lja.lja04) THEN
              CALL t381_lja04()
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0)
                 LET g_lja.lja04 = g_lja_t.lja04
                 NEXT FIELD lja04
              END IF
              CALL t381_desc()
           END IF    

      AFTER FIELD lja05
           IF NOT cl_null(g_lja.lja05) THEN
              CALL cl_set_comp_entry("lja12,lja06,lja14,lja15,lja16",FALSE)
              CALL t381_lja05()
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0)
                 LET g_lja.lja05 = g_lja_t.lja05
                 NEXT FIELD lja05
              END IF
              CALL t381_desc()
           ELSE
              CALL cl_set_comp_entry("lja12,lja06,lja14,lja15,lja16",TRUE)
           END IF
         

      AFTER FIELD lja06
           IF NOT cl_null(g_lja.lja06) THEN
              CALL t381_lja06()
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0)
                 LET g_lja.lja06 = g_lja_t.lja06
                 NEXT FIELD lja06
              END IF
              CALL t381_desc()
              IF cl_null(g_lja.lja05) THEN
                 SELECT lmf09,lmf10,lmf11 INTO g_lja.lja08,g_lja.lja09,g_lja.lja10 FROM lmf_file WHERE lmf01 = g_lja.lja06
                 DISPLAY BY NAME g_lja.lja08,g_lja.lja09,g_lja.lja10
              END IF
           END IF    

      AFTER FIELD lja12 
           IF NOT cl_null(g_lja.lja12) THEN
              IF cl_null(g_lja.lja05) THEN
                 CALL t381_lja12()
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,0)
                    LET g_lja.lja12 = g_lja_t.lja12
                    NEXT FIELD lja12
                 END IF
                 CALL t381_desc()
               END IF
           END IF    


      AFTER FIELD lja14,lja15
           IF NOT cl_null(g_lja.lja14) AND NOT cl_null(g_lja.lja15)  THEN
              IF g_lja.lja14 > g_lja.lja15 THEN
                 CALL cl_err('','alm1038',0)
                 NEXT FIELD CURRENT
              END IF
              CALL t381_lja14_lja15(g_lja.lja14,g_lja.lja15,p_cmd)
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0)
                 CASE
                     WHEN INFIELD(lja14)
                            LET g_lja.lja14 = g_lja_t.lja14
                     WHEN INFIELD(lja15)
                            LET g_lja.lja15 = g_lja_t.lja15
                 END CASE
                 NEXT FIELD CURRENT
              END IF
              IF cl_null(g_lja.lja05) THEN
                 LET g_lja.lja17 = g_lja.lja14 + g_lja.lja16
                 LET g_lja.lja18 = g_lja.lja15
                 DISPLAY BY NAME g_lja.lja17,g_lja.lja18
              END IF
            END IF  
       

      AFTER FIELD lja16
           IF NOT cl_null(g_lja.lja16) THEN
              SELECT oba15 INTO l_oba15 FROM oba_file WHERE oba01 = g_lja.lja07
              SELECT llc02 INTO l_llc02 FROM llc_file WHERE llc01 = l_oba15 AND llcstore = g_lja.ljaplant
              IF g_lja.lja16 < 0 THEN
                 CALL cl_err('','alm1075',0) 
                 LET g_lja.lja16 = g_lja_t.lja16
                 NEXT FIELD lja16
              END IF
              IF g_lja.lja16 > l_llc02 THEN
                 CALL cl_err('','alm1251',0)
                 LET g_lja.lja16 = g_lja_t.lja16
                 NEXT FIELD lja16
              END IF
              IF NOT cl_null(g_lja.lja14) AND NOT cl_null(g_lja.lja15) THEN
                 IF g_lja.lja16 > g_lja.lja15 - g_lja.lja14 THEN
                    CALL cl_err('','alm1118',0)
                    LET g_lja.lja16 = g_lja_t.lja16
                    NEXT FIELD lja16
                 END IF
              END IF
              IF cl_null(g_lja.lja05) THEN
                 LET g_lja.lja17 = g_lja.lja14 + g_lja.lja16
                 LET g_lja.lja18 = g_lja.lja15
                 DISPLAY BY NAME g_lja.lja17,g_lja.lja18
              END IF
           END IF
           IF p_cmd = 'u' AND NOT cl_null(g_lja.lja14) AND NOT cl_null(g_lja.lja15) THEN      
              IF NOT cl_null(g_lja.lja17) AND NOT cl_null(g_lja.lja18) THEN
                    LET g_sql = "SELECT ljb05,ljb06 FROM ljb_file ",
                                " WHERE ljb01 = '",g_lja.lja01,"'",
                                "  AND ljbplant = '",g_lja.ljaplant,"'"
                    DECLARE t381_sel_cr1 CURSOR FROM g_sql
                    FOREACH t381_sel_cr1 INTO g_ljb[g_cnt].ljb05,g_ljb[g_cnt].ljb06
                       IF SQLCA.SQLCODE THEN
                          CALL cl_err('foreach:',SQLCA.SQLCODE,1)
                          EXIT FOREACH
                       END IF
                       IF g_ljb[g_cnt].ljb06 < g_lja.lja17 OR g_ljb[g_cnt].ljb06 > g_lja.lja18 THEN
                          CALL cl_err('','alm1122',0)
                          LET g_lja.lja16 = g_lja_t.lja16
                          NEXT FIELD lja16
                       END IF
                       IF g_ljb[g_cnt].ljb05 < g_lja.lja17  OR g_ljb[g_cnt].ljb05 > g_lja.lja18 THEN
                          CALL cl_err('','alm1120',0)
                          LET g_lja.lja16 = g_lja_t.lja16
                          NEXT FIELD lja16
                       END IF
                       LET g_cnt = g_cnt +1
                       IF g_cnt > g_max_rec THEN
                          CALL cl_err( '', 9035, 0 )
                          EXIT FOREACH
                       END IF
                    END FOREACH
              END IF
           END IF

      ON ACTION controlp
          CASE 
           WHEN INFIELD(lja01)
                LET g_t1=s_get_doc_no(g_lja.lja01)
                CALL q_oay(FALSE,FALSE,g_t1,'P4','ALM') RETURNING g_t1  
                LET g_lja.lja01=g_t1               
                DISPLAY BY NAME g_lja.lja01       
                NEXT FIELD lja01
                
           WHEN INFIELD(lja04) 
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_gen"
                LET g_qryparam.default1 = g_lja.lja04
                CALL cl_create_qry() RETURNING g_lja.lja04
                CALL t381_lja04() 
                DISPLAY BY NAME g_lja.lja04
                NEXT FIELD lja04

           WHEN INFIELD(lja05) 
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_lnt01i"
                LET g_qryparam.default1 = g_lja.lja05
                LET g_qryparam.where = " lntplant IN ",g_auth," "
                CALL cl_create_qry() RETURNING g_lja.lja05
                DISPLAY BY NAME g_lja.lja05
                NEXT FIELD lja05

           WHEN INFIELD(lja06) 
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_lja06i"
                LET g_qryparam.default1 = g_lja.lja06
                LET g_qryparam.where = " lmfstore IN ",g_auth," "
                CALL cl_create_qry() RETURNING g_lja.lja06
                DISPLAY BY NAME g_lja.lja06
                NEXT FIELD lja06

           WHEN INFIELD(lja12) 
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_lja12i"
                LET g_qryparam.default1 = g_lja.lja12
                CALL cl_create_qry() RETURNING g_lja.lja12
                DISPLAY BY NAME g_lja.lja12
                NEXT FIELD lja12
                 
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
          IF cl_null(g_lja.lja05)  THEN
             IF cl_null(g_lja.lja06)  OR cl_null(g_lja.lja12) OR cl_null(g_lja.lja14) OR cl_null(g_lja.lja15) OR cl_null(g_lja.lja16) THEN
                CALL cl_err('','alm1126',0)
                EXIT INPUT
             END IF
          END IF
          CALL t381_b2_fill("1=1")
          CALL t381_b3_fill("1=1")
          CALL t381_b1_fill("1=1")
   END INPUT
END FUNCTION


FUNCTION t381_q()
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_lja.* TO NULL
   CALL cl_opmsg('q')
   MESSAGE ""
   DISPLAY ' ' TO FORMONLY.cnt
   CALL t381_cs()
   IF INT_FLAG OR g_action_choice="exit" THEN
      LET INT_FLAG = 0
      CLEAR FORM
      LET g_rec_b1=0
      LET g_rec_b2=0
      LET g_rec_b3=0
      INITIALIZE g_lja.* TO NULL
      CALL g_ljb.clear()
      CALL g_ljc.clear()
      CALL g_ljd.clear()
      RETURN
   END IF
 
   MESSAGE " SEARCHING ! "
   OPEN t381_cs
   IF SQLCA.SQLCODE THEN
      CALL cl_err('',SQLCA.SQLCODE,0)
      INITIALIZE g_lja.* TO NULL
   ELSE
      OPEN t381_count
      FETCH t381_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL t381_fetch('F')
   END IF
   MESSAGE ""
END FUNCTION
 
FUNCTION t381_fetch(p_flag)
   DEFINE   p_flag   LIKE type_file.chr1,
            l_abso   LIKE type_file.num10
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     t381_cs INTO g_lja.lja01
      WHEN 'P' FETCH PREVIOUS t381_cs INTO g_lja.lja01
      WHEN 'F' FETCH FIRST    t381_cs INTO g_lja.lja01
      WHEN 'L' FETCH LAST     t381_cs INTO g_lja.lja01
      WHEN '/'
         IF (NOT mi_no_ask) THEN
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
         FETCH ABSOLUTE g_jump t381_cs INTO g_lja.lja01
         LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.SQLCODE THEN
      CALL cl_err(g_lja.lja01,SQLCA.SQLCODE,0) 
      INITIALIZE g_lja.* TO NULL
      CALL g_ljb.clear()
      CALL g_ljc.clear()
      CALL g_ljd.clear()
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
   SELECT * INTO g_lja.* FROM lja_file WHERE  lja01 = g_lja.lja01
   IF SQLCA.SQLCODE THEN
      INITIALIZE g_lja.* TO NULL
      CALL g_ljb.clear()
      CALL g_ljc.clear()
      CALL g_ljd.clear()
      CALL cl_err3("sel","lja_file",g_lja.lja01,"",SQLCA.SQLCODE,"","",1)  
      RETURN
   END IF
   
   CALL t381_show()
END FUNCTION
 
FUNCTION t381_show()
   DISPLAY BY NAME g_lja.lja01,g_lja.lja03,g_lja.lja04,g_lja.ljaplant,g_lja.ljalegal,g_lja.lja05,
      g_lja.lja06,g_lja.lja12,g_lja.lja07,g_lja.lja13,g_lja.lja08,g_lja.lja09,g_lja.lja10,
      g_lja.lja14,g_lja.lja15,g_lja.lja16,g_lja.lja17,g_lja.lja18,g_lja.ljamksg,g_lja.lja21,
      g_lja.ljaconf,g_lja.ljaconu,g_lja.ljacond,g_lja.ljacont,g_lja.lja20,g_lja.ljauser,g_lja.ljagrup,
      g_lja.ljaoriu,g_lja.ljamodu,g_lja.ljadate,g_lja.ljaorig,g_lja.ljaacti,g_lja.ljacrat
      
   CALL t381_desc()
   CALL t381_b1_fill(g_wc1)
   CALL t381_b2_fill(g_wc2)
   CALL t381_b3_fill(g_wc3)
   CALL t381_pic() 
   CALL cl_show_fld_cont()
   
END FUNCTION
 
FUNCTION t381_b1()
DEFINE
   l_ac_t          LIKE type_file.num5,
   l_n             LIKE type_file.num5,
   l_qty           LIKE type_file.num10,
   l_lock_sw       LIKE type_file.chr1,
   p_cmd           LIKE type_file.chr1,
   l_allow_insert  LIKE type_file.num5,
   l_allow_delete  LIKE type_file.num5,
   l_money         LIKE ljb_file.ljb07,
   l_cnt           LIKE type_file.num5

   LET g_action_choice = ""
   IF g_lja.lja01 IS NULL OR g_lja.ljaplant IS NULL THEN
      RETURN 
   END IF
      
   SELECT * INTO g_lja.* FROM lja_file
      WHERE lja01=g_lja.lja01
        AND lja02='1' 
   IF g_lja.ljaacti = 'N' THEN CALL cl_err('','mfg1000',0) RETURN END IF     
   IF g_lja.ljaconf = 'Y' THEN CALL cl_err('','alm1061',0) RETURN END IF
   IF g_lja.ljaconf='X' THEN RETURN END IF  #CHI-C80041
   
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = " SELECT ljb02,ljb03,ljb04,'',ljb05,ljb06,ljb07,ljb08",
                      "  FROM ljb_file ",
                      " WHERE ljb01=? AND ljb02=? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t381_bc1 CURSOR FROM g_forupd_sql     
 
   LET l_ac_t = 0
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_ljb WITHOUT DEFAULTS FROM s_ljb.*
         ATTRIBUTE(COUNT=g_rec_b1,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
       BEFORE INPUT
           IF g_rec_b1 != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
              LET l_ac = 1
           END IF
           
       BEFORE ROW
           LET p_cmd=''
           LET l_ac = ARR_CURR()
           LET l_lock_sw = 'N'            #DEFAULT
           LET l_n  = ARR_COUNT()
           BEGIN WORK
           
           LET g_success = 'N'
           OPEN t381_cl USING g_lja.lja01
           IF STATUS THEN
              CALL cl_err("OPEN t381_cl:", STATUS, 1)
              CLOSE t381_cl
              ROLLBACK WORK
              RETURN
           END IF
           FETCH t381_cl INTO g_lja.*
           IF SQLCA.SQLCODE THEN
              CALL cl_err(g_lja.lja01,SQLCA.SQLCODE,0)
              ROLLBACK WORK
              RETURN
           END IF
           IF g_rec_b1>=l_ac THEN
              LET p_cmd='u'
              LET g_ljb_t.* = g_ljb[l_ac].*
              OPEN t381_bc1 USING g_lja.lja01,g_ljb_t.ljb02
              IF STATUS THEN
                 CALL cl_err("OPEN t381_bc1:", STATUS, 1)
                 LET l_lock_sw = "Y"
              END IF
              FETCH t381_bc1 INTO g_ljb[l_ac].*
              SELECT oaj02 INTO g_ljb[l_ac].oaj02 FROM oaj_file WHERE oaj01 = g_ljb[l_ac].ljb04
              IF SQLCA.SQLCODE THEN
                  CALL cl_err(g_ljb_t.ljb02,SQLCA.SQLCODE,1)
                  LET l_lock_sw = "Y"
              END IF
              CALL cl_show_fld_cont()
           END IF
 
       BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_ljb[l_ac].* TO NULL
           LET g_ljb_t.* = g_ljb[l_ac].*
           CALL cl_show_fld_cont()
           NEXT FIELD ljb02
 
       AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           CALL cl_digcut(g_ljb[l_ac].ljb07,g_lla04) RETURNING g_ljb[l_ac].ljb07
           INSERT INTO ljb_file(ljb01,ljb02,ljb03,ljb04,ljb05,ljb06,ljb07,ljb08,ljbplant,ljblegal)
              VALUES(g_lja.lja01,g_ljb[l_ac].ljb02,g_ljb[l_ac].ljb03,g_ljb[l_ac].ljb04,g_ljb[l_ac].ljb05,
                     g_ljb[l_ac].ljb06,g_ljb[l_ac].ljb07,g_ljb[l_ac].ljb08,g_plant,g_legal)
           IF SQLCA.SQLCODE THEN
              CALL cl_err3("ins","ljb_file",g_lja.lja01,"",SQLCA.SQLCODE,"","",1)
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              COMMIT WORK
              LET g_rec_b1=g_rec_b1+1  
              DISPLAY g_rec_b1 TO FORMONLY.cn2 
           END IF

      BEFORE FIELD ljb02
           IF g_ljb[l_ac].ljb02 IS NULL OR g_ljb[l_ac].ljb02 = 0 THEN
              SELECT max(ljb02)+1
                INTO g_ljb[l_ac].ljb02
                FROM ljb_file
               WHERE ljb01 = g_lja.lja01
              IF g_ljb[l_ac].ljb02 IS NULL THEN
                 LET g_ljb[l_ac].ljb02 = 1
              END IF
           END IF

      AFTER FIELD ljb02
           IF NOT cl_null(g_ljb[l_ac].ljb02) THEN
              IF g_ljb[l_ac].ljb02 != g_ljb_t.ljb02
                 OR g_ljb_t.ljb02 IS NULL THEN
                 IF g_ljb[l_ac].ljb02 <= 0 THEN
                    CALL cl_err('','aec-994',0)
                    LET g_ljb[l_ac].ljb02 = g_ljb_t.ljb02
                    NEXT FIELD ljb02
                 END IF 
                 SELECT count(*)
                   INTO l_n
                   FROM ljb_file
                  WHERE ljb01 = g_lja.lja01
                    AND ljb02 = g_ljb[l_ac].ljb02
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_ljb[l_ac].ljb02 = g_ljb_t.ljb02
                    NEXT FIELD ljb02
                 END IF
              END IF
           END IF

      AFTER FIELD ljb04
           IF NOT cl_null(g_ljb[l_ac].ljb04) THEN
              IF cl_null(g_lja.lja05) THEN
                 CALL t381_ljb04()
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,0)
                    LET g_ljb[l_ac].ljb04 = g_ljb_t.ljb04
                    NEXT FIELD ljb04
                 END IF
              ELSE
                 CALL t381_ljb04_1()
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,0)
                    LET g_ljb[l_ac].ljb04 = g_ljb_t.ljb04
                    NEXT FIELD ljb04
                 END IF
              END IF
              IF g_ljb[l_ac].ljb04 != g_ljb_t.ljb04 OR cl_null(g_ljb_t.ljb04) THEN 
                 IF NOT cl_null(g_ljb[l_ac].ljb05) AND NOT cl_null(g_ljb[l_ac].ljb06) THEN
                    CALL t381_ljb05_ljb06(g_ljb[l_ac].ljb02,g_ljb[l_ac].ljb04,g_ljb[l_ac].ljb05,g_ljb[l_ac].ljb06,p_cmd)
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err('',g_errno,0)
                       LET g_ljb[l_ac].ljb04 = g_ljb_t.ljb04
                       NEXT FIELD ljb04
                    END IF
                 END IF  
              END IF
              SELECT oaj02 INTO g_ljb[l_ac].oaj02 FROM oaj_file WHERE oaj01 = g_ljb[l_ac].ljb04
           END IF

      AFTER FIELD ljb05 
           IF NOT cl_null(g_ljb[l_ac].ljb05) THEN
              IF g_ljb[l_ac].ljb05 < g_lja.lja17  OR g_ljb[l_ac].ljb05 > g_lja.lja18 THEN
                 CALL cl_err('','alm1120',0)
                 LET g_ljb[l_ac].ljb05 = g_ljb_t.ljb05
                 NEXT FIELD ljb05
              END IF
              IF NOT cl_null(g_ljb[l_ac].ljb06)  AND g_ljb[l_ac].ljb05 > g_ljb[l_ac].ljb06 THEN
                 CALL cl_err('','alm1122',0)
                 LET g_ljb[l_ac].ljb05 = g_ljb_t.ljb05
                 NEXT FIELD ljb05
              END IF
              IF g_ljb[l_ac].ljb05 != g_ljb_t.ljb05 OR cl_null(g_ljb_t.ljb05) THEN
                 IF NOT cl_null(g_ljb[l_ac].ljb04) AND NOT cl_null(g_ljb[l_ac].ljb06) THEN
                    CALL t381_ljb05_ljb06(g_ljb[l_ac].ljb02,g_ljb[l_ac].ljb04,g_ljb[l_ac].ljb05,g_ljb[l_ac].ljb06,p_cmd)
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err('',g_errno,0)
                       LET g_ljb[l_ac].ljb05 = g_ljb_t.ljb05
                       NEXT FIELD ljb05
                    END IF
                 END IF  
              END IF
            END IF

      AFTER FIELD ljb06
           IF NOT cl_null(g_ljb[l_ac].ljb06) THEN
              IF g_ljb[l_ac].ljb06 < g_lja.lja17  OR g_ljb[l_ac].ljb06 > g_lja.lja18 THEN
                 CALL cl_err('','alm1120',0)
                 LET g_ljb[l_ac].ljb06 = g_ljb_t.ljb06
                 NEXT FIELD ljb06
              END IF
              IF NOT cl_null(g_ljb[l_ac].ljb05)  AND g_ljb[l_ac].ljb05 > g_ljb[l_ac].ljb06 THEN
                 CALL cl_err('','alm1122',0)
                 LET g_ljb[l_ac].ljb06 = g_ljb_t.ljb06
                 NEXT FIELD ljb06
              END IF
              IF g_ljb[l_ac].ljb06 != g_ljb_t.ljb06 OR cl_null(g_ljb_t.ljb06) THEN
                 IF NOT cl_null(g_ljb[l_ac].ljb04) AND NOT cl_null(g_ljb[l_ac].ljb05) THEN
                    CALL t381_ljb05_ljb06(g_ljb[l_ac].ljb02,g_ljb[l_ac].ljb04,g_ljb[l_ac].ljb05,g_ljb[l_ac].ljb06,p_cmd)
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err('',g_errno,0)
                       LET g_ljb[l_ac].ljb06 = g_ljb_t.ljb06
                       NEXT FIELD ljb06
                    END IF
                 END IF  
              END IF
            END IF 

      AFTER FIELD ljb07
           IF g_ljb[l_ac].ljb07 = 0 THEN
              CALL cl_err('','alm1121',0)
              LET g_ljb[l_ac].ljb07 = g_ljb_t.ljb07
              NEXT FIELD ljb07
           END IF
      BEFORE DELETE  
           IF NOT cl_delb(0,0) THEN
              CANCEL DELETE
           END IF
           IF l_lock_sw = "Y" THEN
              CALL cl_err("", -263, 1)
              CANCEL DELETE
           END IF
           DELETE FROM ljb_file
            WHERE ljb01 = g_lja.lja01
              AND ljb02 = g_ljb_t.ljb02
           IF SQLCA.sqlcode THEN
              CALL cl_err3("del","ljb_file",g_lja.lja01,g_ljb_t.ljb02,SQLCA.sqlcode,"","",1)  
              ROLLBACK WORK
              CANCEL DELETE
           END IF
           LET g_rec_b1=g_rec_b1-1
           DISPLAY g_rec_b1 TO FORMONLY.cn2
           COMMIT WORK
 
       ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_ljb[l_ac].* = g_ljb_t.*
              CLOSE t381_bc1
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_ljb[l_ac].ljb02,-263,1) 
              LET g_ljb[l_ac].* = g_ljb_t.*
           ELSE
              UPDATE ljb_file SET ljb02 = g_ljb[l_ac].ljb02,
                                  ljb03 = g_ljb[l_ac].ljb03,
                                  ljb04 = g_ljb[l_ac].ljb04,
                                  ljb05 = g_ljb[l_ac].ljb05,
                                  ljb06 = g_ljb[l_ac].ljb06,
                                  ljb07 = g_ljb[l_ac].ljb07,
                                  ljb08 = g_ljb[l_ac].ljb08
                 WHERE ljb01=g_lja.lja01 
                   AND ljb02=g_ljb_t.ljb02
              IF SQLCA.SQLCODE THEN
                 CALL cl_err3("upd","ljb_file",g_lja.lja01,"",SQLCA.SQLCODE,"","",1)
                 LET g_ljb[l_ac].* = g_ljb_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF
 
       AFTER ROW
           LET l_ac= ARR_CURR()
           LET l_ac_t = l_ac
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_ljb[l_ac].* = g_ljb_t.*
              END IF
              IF cl_null(g_ljb[l_ac].ljb04) THEN
                 CALL g_ljb.deleteElement(l_ac)
              END IF
              CLOSE t381_bc1
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF NOT cl_null(g_ljb[l_ac].ljb07) THEN
              SELECT SUM(ljb07) INTO l_money FROM ljb_file WHERE ljb01 = g_lja.lja01
              DISPLAY l_money TO FORMONLY.money
           END IF
           IF cl_null(g_ljb[l_ac].ljb04) THEN
               CALL g_ljb.deleteElement(l_ac)
           END IF 
           CLOSE t381_bc1
           COMMIT WORK

       ON ACTION CONTROLO
          IF INFIELD(ljb02) AND l_ac > 1 THEN
             LET g_ljb[l_ac].* = g_ljb[l_ac-1].*
             NEXT FIELD ljb02
          END IF
 
       ON ACTION CONTROLR
          CALL cl_show_req_fields()
 
       ON ACTION CONTROLG
          CALL cl_cmdask()

       ON ACTION controlp
           CASE
              WHEN INFIELD(ljb04) 
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_oaj"
                 LET g_qryparam.where = "oajacti = 'Y'"
                 CALL cl_create_qry() RETURNING g_ljb[l_ac].ljb04
                 DISPLAY g_ljb[l_ac].ljb04 TO ljb04
                 NEXT FIELD ljb04
             
           END CASE
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
                                                                                                             
       ON ACTION controls
         CALL cl_set_head_visible("","AUTO")                                                                                  
 
   END INPUT
   IF p_cmd = 'u' THEN
      LET g_lja.ljamodu = g_user
      LET g_lja.ljadate = g_today
      UPDATE lja_file SET ljamodu = g_lja.ljamodu,
                          ljadate = g_lja.ljadate
         WHERE lja01 = g_lja.lja01 
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err3("upd","lja_file",g_lja.lja01,"",SQLCA.SQLCODE,"","upd lja",1)  
      END IF
      DISPLAY BY NAME g_lja.ljamodu,g_lja.ljadate
   END IF
   CLOSE t381_bc1
   COMMIT WORK
#  CALL t381_delall()#CHI-C30002 mark
   CALL t381_delHeader()     #CHI-C30002 add
END FUNCTION

#CHI-C30002 -------- add -------- begin
FUNCTION t381_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b1 = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_lja.lja01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM lja_file ",
                  "  WHERE lja01 LIKE '",l_slip,"%' ",
                  "    AND lja01 > '",g_lja.lja01,"'"
      PREPARE t381_pb1 FROM l_sql 
      EXECUTE t381_pb1 INTO l_cnt      
      
      LET l_action_choice = g_action_choice
      LET g_action_choice = 'delete'
      IF cl_chk_act_auth() AND l_cnt = 0 THEN
         CALL cl_getmsg('aec-130',g_lang) RETURNING g_msg
         LET l_num = 3
      ELSE
         CALL cl_getmsg('aec-131',g_lang) RETURNING g_msg
         LET l_num = 2
      END IF 
      LET g_action_choice = l_action_choice
      PROMPT g_msg CLIPPED,': ' FOR l_cho
         ON IDLE g_idle_seconds
            CALL cl_on_idle()

         ON ACTION about     
            CALL cl_about()

         ON ACTION help         
            CALL cl_show_help()

         ON ACTION controlg   
            CALL cl_cmdask() 
      END PROMPT
      IF l_cho > l_num THEN LET l_cho = 1 END IF 
      IF l_cho = 2 THEN 
         CALL t381_v()
         CALL t381_pic()
      END IF 
      
      IF l_cho = 3 THEN 
         DELETE FROM ljc_file 
          WHERE ljc01 = g_lja.lja01 
       
         DELETE FROM ljd_file 
          WHERE ljd01 = g_lja.lja01 
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM lja_file WHERE lja01 = g_lja.lja01
         INITIALIZE g_lja.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end
FUNCTION t381_b1_fill(p_wc)
DEFINE l_sql      STRING
DEFINE p_wc       STRING

   LET l_sql = "SELECT ljb02,ljb03,ljb04,'',ljb05,ljb06,ljb07,ljb08",
               " FROM ljb_file ",
               "WHERE ljb01 = '",g_lja.lja01,"'",
               "  AND ljbplant = '",g_lja.ljaplant,"'"
               
   IF NOT cl_null(p_wc) THEN
      LET l_sql = l_sql," AND ",p_wc
   END IF
   DECLARE t381_cr1 CURSOR FROM l_sql
   CALL g_ljb.clear()
   LET g_rec_b1 = 0
   LET g_cnt = 1
   FOREACH t381_cr1 INTO g_ljb[g_cnt].*
      IF SQLCA.SQLCODE THEN
         CALL cl_err('foreach:',SQLCA.SQLCODE,1)
         EXIT FOREACH
      END IF
      SELECT oaj02 INTO g_ljb[g_cnt].oaj02 FROM oaj_file WHERE oaj01 = g_ljb[g_cnt].ljb04 
      LET g_cnt=g_cnt+1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_ljb.deleteElement(g_cnt)
   LET g_rec_b1 = g_cnt - 1
   DISPLAY g_rec_b1 TO FORMONLY.cn2
   CALL t381_bp1_refresh()
END FUNCTION
 
FUNCTION t381_bp1_refresh()
  DISPLAY ARRAY g_ljb TO s_ljb.* ATTRIBUTE(COUNT = g_rec_b1,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY
END FUNCTION

FUNCTION t381_ins_ljc()
DEFINE l_sql        STRING
DEFINE l_ljc02      LIKE ljc_file.ljc02
DEFINE l_ljc03      LIKE ljc_file.ljc03
DEFINE l_n1         LIKE type_file.num5
DEFINE l_n2         LIKE type_file.num5
  
   IF NOT cl_null(g_lja.lja05) THEN
      LET l_sql = "SELECT '','',ljb01,ljb02,ljb03,ljb04,'',ljb05,ljb06,ljb07,ljb08 ",
                  "  FROM lja_file,ljb_file ",
                  " WHERE ljb01 <> '",g_lja.lja01,"'",
                  "   AND lja01 = ljb01",
                  "   AND ((lja05 = '",g_lja.lja05,"')",
                  "    OR (lja06 = '",g_lja.lja06,"'",
                  "   AND lja12 = '",g_lja.lja12,"'))",
                  "   AND ljaconf <> 'X' "  #CHI-C80041
   END IF 
   IF cl_null(g_lja.lja05) THEN
      LET l_sql = "SELECT '','',ljb01,ljb02,ljb03,ljb04,'',ljb05,ljb06,ljb07,ljb08 ",
                  "  FROM lja_file,ljb_file ", 
                  " WHERE ljb01 <> '",g_lja.lja01,"'",
                  "   AND lja01 = ljb01",
                  "   AND lja06 = '",g_lja.lja06,"'",
                  "   AND lja12 = '",g_lja.lja12,"'",
                  "   AND ljaconf <> 'X' "  #CHI-C80041
   END IF
               
   DECLARE t381_ljc_cr2 CURSOR FROM l_sql
 
   LET g_cnt = 1
   FOREACH t381_ljc_cr2 INTO g_ljc[g_cnt].*
      LET l_ljc02 = g_cnt
      LET g_ljc[g_cnt].ljc02 = l_ljc02
      IF SQLCA.SQLCODE THEN
         CALL cl_err('foreach:',SQLCA.SQLCODE,1)
         EXIT FOREACH
      END IF
      SELECT COUNT(*) INTO l_n1 FROM liv_file 
       WHERE liv07 = g_ljc[g_cnt].ljc04 
         AND liv08 = '2'
         AND liv09 = g_ljc[g_cnt].ljb03_5
      IF l_n1 = 0 THEN
         LET l_ljc03 = '1'
      ELSE
         SELECT COUNT(*) INTO l_n2 FROM liv_file,liw_file
          WHERE liv07 = g_ljc[g_cnt].ljc04 
            AND liv08 = '2'
            AND liv09 = g_ljc[g_cnt].ljb03_5
            AND liw04 = g_ljc[g_cnt].ljc06 
            AND liw17 = 'N'
            AND liv01 = liw01
            AND liv05 = liw04
            AND liv04  BETWEEN g_ljc[g_cnt].ljc07 AND g_ljc[g_cnt].ljc08
            AND liw07 >= g_ljc[g_cnt].ljc07
            AND liw08 <= g_ljc[g_cnt].ljc08
            AND liw02 = liv02
         IF l_n2 = 0 THEN
            LET l_ljc03 = '2'
         ELSE 
            LET l_ljc03 = '3'
         END IF
      END IF
      LET g_ljc[g_cnt].ljc03 = l_ljc03
      INSERT INTO ljc_file(ljc01,ljc02,ljc03,ljc04,ljc05,ljc06,ljc07,ljc08,ljc09,ljc10,ljcplant,ljclegal)
                    VALUES(g_lja.lja01,g_ljc[g_cnt].ljc02,g_ljc[g_cnt].ljc03,g_ljc[g_cnt].ljc04,g_ljc[g_cnt].ljc05,g_ljc[g_cnt].ljc06,
                           g_ljc[g_cnt].ljc07,g_ljc[g_cnt].ljc08,g_ljc[g_cnt].ljc09,g_ljc[g_cnt].ljc10,g_lja.ljaplant,g_lja.ljalegal)
      LET g_cnt=g_cnt+1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_ljc.deleteElement(g_cnt)
END FUNCTION
 
FUNCTION t381_ins_ljd()
DEFINE l_sql        STRING
DEFINE l_ljd02      LIKE ljd_file.ljd02
DEFINE l_rtz01      LIKE rtz_file.rtz01
DEFINE l_azw02      LIKE azw_file.azw02

   LET l_sql = "SELECT rtz01 FROM rtz_file,lnt_file ",
               " WHERE lntplant = rtz01"
   PREPARE sel_rtz_pre FROM l_sql
   DECLARE sel_rtz_cs CURSOR FOR sel_rtz_pre
   FOREACH sel_rtz_cs INTO l_rtz01
           IF SQLCA.sqlcode THEN
              EXIT FOREACH
           END IF
           LET l_sql = "SELECT '',lntplant,'',lnt01,lnt06,lnt56,lnt17,lnt18,lnt33,''",
                       "  FROM ",cl_get_target_table(l_rtz01,'lnt_file'),
                       " WHERE lnt04 = '",g_lja.lja12,"'",
                       "   AND lnt26 = 'Y' ",
                       "   AND lntplant = '",l_rtz01,"' "
           DECLARE t381_ljd_cr3 CURSOR FROM l_sql
           LET g_cnt = 1
           FOREACH t381_ljd_cr3 INTO g_ljd[g_cnt].*
              LET l_ljd02 = g_cnt
              LET g_ljd[g_cnt].ljd02 = l_ljd02
              IF SQLCA.SQLCODE THEN
                 CALL cl_err('foreach:',SQLCA.SQLCODE,1)
                 EXIT FOREACH
              END IF
              SELECT rtz13 INTO g_ljd[g_cnt].rtz13_1 FROM rtz_file WHERE rtz01 = g_ljd[g_cnt].ljdplant
              SELECT oba02 INTO g_ljd[g_cnt].oba02_1 FROM oba_file WHERE oba01 = g_ljd[g_cnt].ljd08
              SELECT azw02 INTO l_azw02 FROM azw_file  WHERE azw01  = g_ljd[g_cnt].ljdplant
              INSERT INTO ljd_file(ljd01,ljd02,ljd03,ljd04,ljd05,ljd06,ljd07,ljd08,ljdplant,ljdlegal)
                            VALUES(g_lja.lja01,g_ljd[g_cnt].ljd02,g_ljd[g_cnt].ljd03,g_ljd[g_cnt].ljd04,g_ljd[g_cnt].ljd05,
                                   g_ljd[g_cnt].ljd06,g_ljd[g_cnt].ljd07,g_ljd[g_cnt].ljd08,g_ljd[g_cnt].ljdplant,l_azw02)
              LET g_cnt=g_cnt+1
              IF g_cnt > g_max_rec THEN
                 CALL cl_err( '', 9035, 0 )
                 EXIT FOREACH
              END IF
           END FOREACH
   END FOREACH
   CALL g_ljd.deleteElement(g_cnt)
END FUNCTION

FUNCTION t381_b2_fill(p_wc)
DEFINE l_sql        STRING
DEFINE p_wc         STRING
DEFINE l_n1         LIKE type_file.num5
DEFINE l_n2         LIKE type_file.num5

   LET l_sql = "SELECT ljc02,ljc03,ljc04,ljc05,ljb03,ljc06,'',ljc07,ljc08,ljc09,ljc10 FROM ljb_file,ljc_file ",
               "WHERE ljc01 = '",g_lja.lja01,"'",
               "  AND ljb01 = ljc04 ",
               "  AND ljb02 = ljc05 "

   IF NOT cl_null(p_wc) THEN
      LET l_sql = l_sql," AND ",p_wc
   END IF
   DECLARE t381_cr2 CURSOR FROM l_sql

   CALL g_ljc.clear()
   LET g_rec_b2 = 0

   LET g_cnt = 1
   FOREACH t381_cr2 INTO g_ljc[g_cnt].*
      IF SQLCA.SQLCODE THEN
         CALL cl_err('foreach:',SQLCA.SQLCODE,1)
         EXIT FOREACH
      END IF
      SELECT oaj02 INTO g_ljc[g_cnt].oaj02_1 FROM oaj_file WHERE oaj01 = g_ljc[g_cnt].ljc06
      LET g_cnt=g_cnt+1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_ljc.deleteElement(g_cnt)
   LET g_rec_b2 = g_cnt - 1
   DISPLAY g_rec_b2 TO FORMONLY.cn2
   CLOSE t381_cr2
   CALL t381_bp2_refresh()
END FUNCTION

FUNCTION t381_bp2_refresh()
  DISPLAY ARRAY g_ljc TO s_ljc.* ATTRIBUTE(COUNT = g_rec_b2,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY
END FUNCTION

FUNCTION t381_b3_fill(p_wc)
DEFINE l_sql        STRING
DEFINE p_wc         STRING
DEFINE l_rtz01      LIKE rtz_file.rtz01

   LET l_sql = "SELECT ljd02,ljdplant,'',ljd03,ljd04,ljd05,ljd06,ljd07,ljd08,''",
               "  FROM ",cl_get_target_table(l_rtz01,'ljd_file'),
               " WHERE ljd01 = '",g_lja.lja01,"'"
   IF NOT cl_null(p_wc) THEN
      LET l_sql = l_sql," AND ",p_wc
   END IF
   DECLARE t381_cr3 CURSOR FROM l_sql
  
   CALL g_ljd.clear()
   LET g_rec_b3 = 0
   LET g_cnt = 1
   FOREACH t381_cr3 INTO g_ljd[g_cnt].*
      IF SQLCA.SQLCODE THEN
         CALL cl_err('foreach:',SQLCA.SQLCODE,1)
         EXIT FOREACH
      END IF
      SELECT rtz13 INTO g_ljd[g_cnt].rtz13_1 FROM rtz_file WHERE rtz01 = g_ljd[g_cnt].ljdplant
      SELECT oba02 INTO g_ljd[g_cnt].oba02_1 FROM oba_file WHERE oba01 = g_ljd[g_cnt].ljd08
      LET g_cnt=g_cnt+1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_ljd.deleteElement(g_cnt)
   LET g_rec_b3 = g_cnt - 1
   DISPLAY g_rec_b3 TO FORMONLY.cn2
   CLOSE t381_cr3
   CALL t381_bp3_refresh()
END FUNCTION

FUNCTION t381_bp3_refresh()
  DISPLAY ARRAY g_ljd TO s_ljd.* ATTRIBUTE(COUNT = g_rec_b3,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY
END FUNCTION

 
FUNCTION t381_r()
   DEFINE l_cnt    LIKE type_file.num5
 
   IF s_shut(0) THEN RETURN END IF
   IF g_lja.lja01 IS NULL OR g_lja.ljaplant IS NULL THEN 
      CALL cl_err('',-400,2) 
      RETURN 
   END IF
   SELECT * INTO g_lja.* FROM lja_file WHERE lja01 = g_lja.lja01
   IF g_lja.ljaconf='Y' THEN CALL cl_err('','9023',0) RETURN END IF
   IF g_lja.ljaconf='X' THEN RETURN END IF  #CHI-C80041
 
   LET g_success = 'Y'
   BEGIN WORK
   OPEN t381_cl USING g_lja.lja01
   FETCH t381_cl INTO g_lja.*
   IF SQLCA.SQLCODE THEN
      CALL cl_err(g_lja.lja01,SQLCA.SQLCODE,0)
      CLOSE t381_cl 
      ROLLBACK WORK 
      RETURN
   END IF
   LET g_lja_t.* = g_lja.*
   CALL t381_show()
   IF cl_delete() THEN
      INITIALIZE g_doc.* TO NULL          
      LET g_doc.column1 = "lja01"        
      LET g_doc.value1 = g_lja.lja01      
      CALL cl_del_doc()                                     
      DELETE FROM lja_file 
       WHERE lja01=g_lja.lja01
      IF SQLCA.SQLCODE THEN
         CALL cl_err3("del","lja_file",g_lja.lja01,"",SQLCA.SQLCODE,"","(t381_r:delete lja)",1)
         LET g_success='N'
      END IF
      
      DELETE FROM ljb_file 
       WHERE ljb01 = g_lja.lja01 
      IF SQLCA.SQLCODE THEN
         CALL cl_err3("del","ljb_file",g_lja.lja01,"",SQLCA.SQLCODE,"","(t381_r:delete ljb)",1) 
         LET g_success='N'
      END IF

      DELETE FROM ljc_file 
       WHERE ljc01 = g_lja.lja01 
      IF SQLCA.SQLCODE THEN
         CALL cl_err3("del","ljc_file",g_lja.lja01,"",SQLCA.SQLCODE,"","(t381_r:delete ljc)",1) 
         LET g_success='N'
      END IF

      DELETE FROM ljd_file 
       WHERE ljd01 = g_lja.lja01 
      IF SQLCA.SQLCODE THEN
         CALL cl_err3("del","ljd_file",g_lja.lja01,"",SQLCA.SQLCODE,"","(t381_r:delete ljd)",1) 
         LET g_success='N'
      END IF
      INITIALIZE g_lja.* TO NULL
      IF g_success = 'Y' THEN
         COMMIT WORK
         CLEAR FORM
         LET g_lja_t.* = g_lja.*
         CALL g_ljb.clear()
         CALL g_ljc.clear()
         CALL g_ljd.clear()
         OPEN t381_count
         FETCH t381_count INTO g_row_count
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN t381_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL t381_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE
            CALL t381_fetch('/')
         END IF
      ELSE
         ROLLBACK WORK
         LET g_lja.* = g_lja_t.*
      END IF
   END IF
   CALL t381_show()
END FUNCTION

FUNCTION t381_x()

   IF s_shut(0) THEN RETURN END IF
   SELECT * INTO g_lja.* FROM lja_file WHERE lja01 = g_lja.lja01
   IF g_lja.lja01 IS NULL  OR g_lja.ljaplant IS NULL THEN 
      CALL cl_err('',-400,0) 
      RETURN 
   END IF
   IF g_lja.ljaconf = 'Y' THEN 
      CALL cl_err('',9023,0) 
      RETURN 
   END IF
   BEGIN WORK
 
   OPEN t381_cl USING g_lja.lja01
   IF STATUS THEN
      CALL cl_err("OPEN t381_cl:", STATUS, 1)
      CLOSE t381_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t381_cl INTO g_lja.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lja.lja01,SQLCA.sqlcode,0)
      CLOSE t381_cl
      ROLLBACK WORK
      RETURN
   END IF
   IF cl_exp(0,0,g_lja.ljaacti) THEN
      LET g_chr=g_lja.ljaacti
      IF g_lja.ljaacti='Y' THEN
         LET g_lja.ljaacti='N'
      ELSE
         LET g_lja.ljaacti='Y'
      END IF

      UPDATE lja_file SET ljaacti=g_lja.ljaacti,
                          ljamodu=g_user,
                          ljadate=g_today
       WHERE lja01=g_lja.lja01
      IF SQLCA.sqlerrd[3]=0 THEN
        CALL cl_err3("upd","lja_file",g_lja.lja01,"",SQLCA.sqlcode,"","",1)
        LET g_lja.ljaacti = g_chr
        CLOSE t381_cl
        ROLLBACK WORK
        RETURN
      END IF
    END IF
    CLOSE t381_cl
    COMMIT WORK

   SELECT ljaacti,ljamodu,ljadate
     INTO g_lja.ljaacti,g_lja.ljamodu,g_lja.ljadate FROM lja_file
    WHERE lja01=g_lja.lja01
   DISPLAY BY NAME g_lja.ljaacti,g_lja.ljamodu,g_lja.ljadate

END FUNCTION

FUNCTION t381_confirm()
  DEFINE l_ljacond         LIKE lja_file.ljacond 
  DEFINE l_ljaconu         LIKE lja_file.ljaconu
  DEFINE l_ljamodu         LIKE lja_file.ljamodu
  DEFINE l_ljadate         LIKE lja_file.ljadate
  DEFINE l_lja21           LIKE lja_file.lja21
  DEFINE l_ljacont         LIKE lja_file.ljacont
  DEFINE l_gen02           LIKE gen_file.gen02        #CHI-D20015---add---


   IF cl_null(g_lja.lja01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

#CHI-C30107 --------- add ---------- begin
   IF g_lja.ljaconf = 'Y' THEN
      CALL cl_err('','alm1061',0)
      RETURN
   END IF
   IF g_lja.ljaconf='X' THEN RETURN END IF  #CHI-C80041
   IF g_lja.ljaacti = 'N' THEN
      CALL cl_err('','alm1067',0)
      RETURN
   END IF
   IF NOT cl_confirm("alm1070") THEN RETURN END IF
#CHI-C30107 --------- add ---------- end
   SELECT lja_file.* INTO g_lja.* FROM lja_file
    WHERE lja01 = g_lja.lja01
   IF g_lja.ljaconf = 'Y' THEN
      CALL cl_err('','alm1061',0)
      RETURN
   END IF
   IF g_lja.ljaconf='X' THEN RETURN END IF  #CHI-C80041
   IF g_lja.ljaacti = 'N' THEN
      CALL cl_err('','alm1067',0)
      RETURN
   END IF
 

   LET l_ljacond = g_lja.ljacond
   LET l_ljaconu = g_lja.ljaconu
   LET l_ljamodu = g_lja.ljamodu
   LET l_ljadate = g_lja.ljadate   
   LET l_lja21 = g_lja.lja21
   LET l_ljacont = g_lja.ljacont  

   IF g_lja.ljaacti ='N' THEN
      CALL cl_err(g_lja.lja01,'alm1068',1)
      RETURN
   END IF
   IF g_lja.ljaconf = 'Y' THEN
      CALL cl_err(g_lja.lja01,'alm1069',1)
      RETURN
   END IF
   IF g_lja.ljaconf='X' THEN RETURN END IF  #CHI-C80041
   BEGIN WORK
 
   OPEN t381_cl USING g_lja.lja01
   IF STATUS THEN
      CALL cl_err("OPEN t381_cl:",STATUS,0)
      CLOSE t381_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t381_cl INTO g_lja.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lja.lja01,SQLCA.sqlcode,0)
      CLOSE t381_cl
      ROLLBACK WORK
      RETURN
   END IF
    
#  IF NOT cl_confirm("alm1070") THEN  #CHI-C30107 mark
#      RETURN                         #CHI-C30107 mark
#  ELSE                               #CHI-C30107 mark
      LET g_lja.ljaconf = 'Y'
      LET g_lja.ljacond = g_today 
      LET g_lja.ljaconu = g_user 
      LET g_lja.ljamodu = g_user
      LET g_lja.ljadate = g_today 
      LET g_lja.lja21 = '1'
      LET g_lja.ljacont = TIME
      CALL t381_desc()
      UPDATE lja_file
         SET ljaconf = 'Y',
             ljacond = g_lja.ljacond,
             ljaconu = g_lja.ljaconu,
             ljamodu = g_lja.ljamodu,
             ljadate = g_lja.ljadate,
             lja21 = g_lja.lja21,
             ljacont = g_lja.ljacont
       WHERE lja01 = g_lja.lja01
       IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err('upd lja:',SQLCA.SQLCODE,0)
         LET g_lja.ljaconf = 'N'
         LET g_lja.ljacond = l_ljacond
         LET g_lja.ljaconu = l_ljaconu
         LET g_lja.ljamodu = l_ljamodu
         LET g_lja.ljadate = l_ljadate
         LET g_lja.lja21 = l_lja21
         LET g_lja.ljacont = l_ljacont 
         DISPLAY '' TO FORMONLY.gen02
         DISPLAY BY NAME g_lja.ljaconf,g_lja.ljacond,g_lja.ljaconu,g_lja.ljamodu,g_lja.ljadate,g_lja.lja21,g_lja.ljacont
         RETURN
       ELSE
         DISPLAY BY NAME g_lja.ljaconf,g_lja.ljacond,g_lja.ljaconu,g_lja.ljamodu,g_lja.ljadate,g_lja.lja21,g_lja.ljacont
         #CHI-D20015---STR---
         SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_lja.ljaconu
         DISPLAY l_gen02 TO FORMONLY.gen02
         #CHI-D20015---END---
       END IF
#   END IF    #CHI-C30107 mark
    
   CLOSE t381_cl
   COMMIT WORK  
   CALL t381_pic() 
END FUNCTION

FUNCTION t381_pic()
   LET g_confirm = 'N'  #CHI-C80041
   LET g_void = 'N'     #CHI-C80041
   CASE g_lja.ljaconf
      WHEN 'Y'  LET g_confirm = 'Y'
      WHEN 'N'  LET g_confirm = 'N'
      WHEN 'X'  LET g_void = 'Y'   #CHI-C80041
      OTHERWISE LET g_confirm = ''
   END CASE
   #CALL cl_set_field_pic(g_confirm,"","","","",g_lja.ljaacti) #CHI-C80041
   CALL cl_set_field_pic(g_confirm,"","","",g_void,g_lja.ljaacti) #CHI-C80041
END FUNCTION

FUNCTION t381_unconfirm()
DEFINE l_n      LIKE type_file.num5
DEFINE l_gen02  LIKE gen_file.gen02   #CHI-D20015---ADD


   IF cl_null(g_lja.lja01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT lja_file.* INTO g_lja.* FROM lja_file
    WHERE lja01 = g_lja.lja01

   SELECT COUNT(*) INTO l_n FROM lji_file
    WHERE lji03 = g_lja.lja01
   IF l_n > 0 THEN
      CALL cl_err(g_lja.lja01,'alm1141',1)
      RETURN
   END IF
  
   SELECT COUNT(lit05) INTO l_n FROM lit_file WHERE lit05 = g_lja.lja01
   IF l_n > 0  THEN
      CALL cl_err(g_lja.lja01,'alm1196',1)
      RETURN
   END IF
  
   IF g_lja.ljaacti ='N' THEN
      CALL cl_err(g_lja.lja01,'alm1071',1)
      RETURN
   END IF
   IF g_lja.ljaconf = 'N' THEN
      CALL cl_err(g_lja.lja01,'alm1072',1)
      RETURN
   END IF
   IF g_lja.ljaconf='X' THEN RETURN END IF  #CHI-C80041
   BEGIN WORK
 
   OPEN t381_cl USING g_lja.lja01
   IF STATUS THEN
      CALL cl_err("OPEN t381_cl:",STATUS,0)
      CLOSE t381_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t381_cl INTO g_lja.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lja.lja01,SQLCA.sqlcode,0)
      CLOSE t381_cl
      ROLLBACK WORK
      RETURN
   END IF
   
 
   IF NOT cl_confirm('alm1073') THEN
      RETURN
   ELSE
      UPDATE lja_file
         SET ljaconf = 'N',
             #CHI-D20015---modify---str---
             #ljacond = '',
             #ljaconu = '',
             ljacond = g_today,
             ljaconu = g_user,
             #CHI-D20015---modify---end---
             ljamodu = g_user,
             ljadate = g_today,
             lja21 = '0',
             #ljacont = ''   #CHI-D20015---mark---
             ljacont = TIME  #CHI-D20015---add---
       WHERE lja01 = g_lja.lja01
       IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err('upd lja:',SQLCA.SQLCODE,0)
         LET g_lja.ljaconf = 'Y' 
         LET g_lja.ljacond = g_lja_t.ljacond 
         LET g_lja.ljaconu = g_lja_t.ljaconu
         LET g_lja.ljamodu = g_lja_t.ljamodu
         LET g_lja.ljadate = g_lja_t.ljadate
         LET g_lja.lja21 = g_lja_t.lja21
         LET g_lja.ljacont = g_lja_t.ljacont
         DISPLAY BY NAME g_lja.ljaconf,g_lja.ljacond,g_lja.ljaconu,g_lja.ljamodu,g_lja.ljadate,g_lja.lja21,g_lja.ljacont
       ELSE
         LET g_lja.ljaconf = 'N'
         #CHI-D20015---modify---str---
         #LET g_lja.ljacond = ''
         #LET g_lja.ljaconu = ''
         LET g_lja.ljacond = g_today
         LET g_lja.ljaconu = g_user
         #CHI-D20015---modify---end---
         LET g_lja.ljamodu = g_user
         LET g_lja.ljadate = g_today 
         LET g_lja.lja21 = '0'
         #LET g_lja.ljacont = ''    #CHI-D20015---mark---
         LET g_lja.ljacont = TIME   #CHI-D20015---add---
         #DISPLAY '' TO FORMONLY.gen02  #CHI-D20015---mark--
         #CHI-D20015---STR---
         SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_lja.ljaconu
         DISPLAY l_gen02 TO FORMONLY.gen02
         #CHI-D20015---END---
         DISPLAY BY NAME g_lja.ljaconf,g_lja.ljacond,g_lja.ljaconu,g_lja.ljamodu,g_lja.ljadate,g_lja.lja21,g_lja.ljacont
       END IF
    END IF 

   CLOSE t381_cl
   COMMIT WORK   
END FUNCTION

FUNCTION t381_lja04()  
   DEFINE l_gen01         LIKE gen_file.gen01,
          l_genacti       LIKE gen_file.genacti
          
   LET g_errno = ' '
   SELECT gen01,genacti 
     INTO l_gen01,l_genacti  
     FROM gen_file
    WHERE gen01 = g_lja.lja04

   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg1312'
        WHEN l_genacti = 'N'      LET g_errno = '9028'
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
END FUNCTION

FUNCTION t381_lja05()  
   DEFINE l_lnt01         LIKE lnt_file.lnt01,
          l_lnt04         LIKE lnt_file.lnt04,
          l_lnt06         LIKE lnt_file.lnt06,
          l_lnt33         LIKE lnt_file.lnt33,
          l_lnt30         LIKE lnt_file.lnt30,
          l_lnt11         LIKE lnt_file.lnt11,
          l_lnt61         LIKE lnt_file.lnt61,
          l_lnt10         LIKE lnt_file.lnt10,
          l_lnt17         LIKE lnt_file.lnt17,
          l_lnt18         LIKE lnt_file.lnt18,
          l_lnt21         LIKE lnt_file.lnt21,
          l_lnt22         LIKE lnt_file.lnt22,
          l_lnt51         LIKE lnt_file.lnt51,
          l_lnt26         LIKE lnt_file.lnt26,
          l_n             LIKE type_file.num5
          
   LET g_errno = ' '
   SELECT lnt01,lnt04,lnt06,lnt33,lnt30,lnt11,lnt61,lnt10,lnt17,lnt18,lnt21,lnt22,lnt51,lnt26
     INTO l_lnt01,l_lnt04,l_lnt06,l_lnt33,l_lnt30,l_lnt11,l_lnt61,l_lnt10,l_lnt17,l_lnt18,l_lnt21,l_lnt22,l_lnt51,l_lnt26
     FROM lnt_file
    WHERE lnt01 = g_lja.lja05

   IF SQLCA.SQLCODE = 100 THEN LET g_errno = 'alm1124' END IF
   IF l_lnt26 <> 'Y' THEN LET g_errno = 'alm1125' END IF

   SELECT COUNT(*) INTO l_n FROM lje_file WHERE lje04 = g_lja.lja05
   IF l_n > 0 THEN LET g_errno = 'alm1360' END IF
   
   IF cl_null(g_errno) THEN
      LET g_lja.lja12 = l_lnt04
      LET g_lja.lja06 = l_lnt06
      LET g_lja.lja07 = l_lnt33
      LET g_lja.lja13 = l_lnt30
      LET g_lja.lja08 = l_lnt11
      LET g_lja.lja09 = l_lnt61
      LET g_lja.lja10 = l_lnt10
      LET g_lja.lja14 = l_lnt17
      LET g_lja.lja15 = l_lnt18
      LET g_lja.lja17 = l_lnt21
      LET g_lja.lja18 = l_lnt22
      LET g_lja.lja16 = l_lnt51
      DISPLAY BY NAME g_lja.lja06,g_lja.lja12,g_lja.lja07,g_lja.lja13,g_lja.lja08,g_lja.lja09,g_lja.lja10,g_lja.lja14,g_lja.lja15,g_lja.lja17,g_lja.lja18,g_lja.lja16
   END IF
   
END FUNCTION

FUNCTION t381_lja06()  
   DEFINE l_lmf01         LIKE lmf_file.lmf01,
          l_lmfacti       LIKE lmf_file.lmfacti,
          l_lmfstore      LIKE lmf_file.lmfstore,
          l_lmf06         LIKE lmf_file.lmf06
          
   LET g_errno = ' '
   SELECT lmf01,lmfacti,lmfstore,lmf06 
     INTO l_lmf01,l_lmfacti,l_lmfstore,l_lmf06  
     FROM lmf_file
    WHERE lmf01 = g_lja.lja06

   CASE WHEN SQLCA.SQLCODE = 100           LET g_errno = 'alm-042'
        WHEN l_lmfstore <> g_lja.ljaplant  LET g_errno = 'alm-620'
        WHEN l_lmfacti = 'N'               LET g_errno = '9028'
        WHEN l_lmf06 = 'N'                 LET g_errno = 'alm1063'
        OTHERWISE                          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE

   IF g_errno = ' ' THEN
      SELECT lml02 INTO g_lja.lja07 FROM lml_file WHERE lml01 = g_lja.lja06
      DISPLAY BY NAME g_lja.lja07
   END IF
END FUNCTION


FUNCTION t381_lja12()  
   DEFINE l_lne01         LIKE lne_file.lne01,
          l_lne36         LIKE lne_file.lne36
          
   LET g_errno = ' '
   SELECT lne01,lne36
     INTO l_lne01,l_lne36  
     FROM lne_file
    WHERE lne01 = g_lja.lja12

   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'alm-133'
        WHEN l_lne36 = 'N'        LET g_errno = 'alm1065'
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF g_errno = ' ' THEN
      SELECT lnt30 INTO g_lja.lja13 FROM lnt_file WHERE lnt04 = g_lja.lja12
      DISPLAY BY NAME g_lja.lja13
   END IF
END FUNCTION

FUNCTION t381_ljb04()  
   DEFINE l_oaj01         LIKE oaj_file.oaj01,
          l_oajacti       LIKE oaj_file.oajacti
          
   LET g_errno = ' '
   SELECT oaj01,oajacti
     INTO l_oaj01,l_oajacti
     FROM oaj_file
    WHERE oaj01 = g_ljb[l_ac].ljb04

   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'alm1031'
        WHEN l_oajacti = 'N'      LET g_errno = 'alm1032'
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
END FUNCTION


FUNCTION t381_ljb04_1() 
   DEFINE l_n             LIKE type_file.num5,
          l_n1            LIKE type_file.num5 
   LET g_errno = ' '
   SELECT count(*) INTO l_n 
     FROM lnv_file 
    WHERE lnv04 = g_ljb[l_ac].ljb04
      AND lnv01 = g_lja.lja05
   SELECT count(*) INTO l_n1
     FROM lnw_file 
    WHERE lnw03 = g_ljb[l_ac].ljb04
      AND lnw01 = g_lja.lja05
   IF l_n = 0 AND l_n1 = 0 THEN 
      LET g_errno = 'alm1119'
   END IF 
END FUNCTION

FUNCTION t381_lja14_lja15(p_stardate,p_enddate,p_cmd)
DEFINE p_stardate   LIKE lja_file.lja14,
       p_enddate    LIKE lja_file.lja15,
       l_ljb05      LIKE ljb_file.ljb05,
       l_ljb06      LIKE ljb_file.ljb06,
       p_cmd        LIKE type_file.chr1
   LET g_errno =''
   IF p_cmd = 'u' THEN
      SELECT MIN(ljb05),MAX(ljb06) INTO l_ljb05,l_ljb06 FROM ljb_file
       WHERE ljb01 = g_lja.lja01
      IF p_stardate > l_ljb05 OR p_enddate < l_ljb06 THEN
         LET g_errno = 'alm-854'
      END IF
   END IF
END FUNCTION

FUNCTION t381_ljb05_ljb06(l_ljb02,l_ljb04,p_stardate,p_enddate,p_cmd)
DEFINE l_n          LIKE type_file.num5,
       l_ljb02      LIKE ljb_file.ljb02,
       l_ljb04      LIKE ljb_file.ljb04,
       p_stardate   LIKE ljb_file.ljb05,
       p_enddate    LIKE ljb_file.ljb06,
       p_cmd        LIKE type_file.chr1
   LET g_errno =''
   IF p_cmd = 'u' THEN
      SELECT COUNT(ljb04) INTO l_n FROM ljb_file
       WHERE ljb04 = l_ljb04
         AND ljb01 = g_lja.lja01
         AND ljb02 <> l_ljb02
         AND (
              ljb05 BETWEEN p_stardate AND p_enddate
              OR  ljb06 BETWEEN p_stardate AND p_enddate
              OR  (ljb05 <=p_stardate AND ljb06 >= p_enddate)
             )
   ELSE 
      SELECT COUNT(ljb04) INTO l_n FROM ljb_file
       WHERE ljb04 = l_ljb04
         AND ljb01 = g_lja.lja01
         AND (
              ljb05 BETWEEN p_stardate AND p_enddate
              OR  ljb06 BETWEEN p_stardate AND p_enddate
              OR  (ljb05 <=p_stardate AND ljb06 >= p_enddate)
             )
   END IF 
   IF l_n > 0 THEN
      LET g_errno = 'alm1123'
   END IF
END FUNCTION

FUNCTION t381_set_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1
   
   IF p_cmd = 'a' THEN
     CALL cl_set_comp_entry("lja01",TRUE) 
   END IF
END FUNCTION
 
FUNCTION t381_set_no_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1

   IF p_cmd = 'u' THEN
      CALL cl_set_comp_entry("lja01",FALSE) 
   END IF
END FUNCTION
#FUN-BA0118
#FUN-CB0076-------add------str
FUNCTION t381_out()
DEFINE l_sql     LIKE type_file.chr1000, 
       l_rtz13   LIKE rtz_file.rtz13,
       l_lne05   LIKE lne_file.lne05,
       l_gen02   LIKE gen_file.gen02,
       l_oaj02   LIKE oaj_file.oaj02,
       l_lmf13   LIKE lmf_file.lmf13,
       l_lnt60   LIKE lnt_file.lnt60,
       l_lnt10   LIKE lnt_file.lnt10,
       l_lnt33   LIKE lnt_file.lnt33
DEFINE l_img_blob     LIKE type_file.blob
DEFINE sr        RECORD
       ljaplant  LIKE lja_file.ljaplant,
       lja01     LIKE lja_file.lja01,
       lja05     LIKE lja_file.lja05,
       lja12     LIKE lja_file.lja12,
       lja03     LIKE lja_file.lja03,
       lja14     LIKE lja_file.lja14,
       lja06     LIKE lja_file.lja06,
       lja04     LIKE lja_file.lja04,
       lja15     LIKE lja_file.lja15,
       lja20     LIKE lja_file.lja20,
       lja07     LIKE lja_file.lja07,
       lja10     LIKE lja_file.lja10,
       ljb02     LIKE ljb_file.ljb02,
       ljb03     LIKE ljb_file.ljb03,
       ljb04     LIKE ljb_file.ljb04,
       ljb05     LIKE ljb_file.ljb05,
       ljb06     LIKE ljb_file.ljb06,
       ljb07     LIKE ljb_file.ljb07,
       ljb08     LIKE ljb_file.ljb08
                 END RECORD
DEFINE sr4       RECORD
       ljc01     LIKE ljc_file.ljc01,
       ljc02     LIKE ljc_file.ljc02,
       ljc03     LIKE ljc_file.ljc03,
       ljb03_1   LIKE ljb_file.ljb03,
       ljc04     LIKE ljc_file.ljc04,
       ljc05     LIKE ljc_file.ljc05,
       ljc06     LIKE ljc_file.ljc06,
       ljc07     LIKE ljc_file.ljc07,
       ljc08     LIKE ljc_file.ljc08,
       ljc09     LIKE ljc_file.ljc09,
       ljc10     LIKE ljc_file.ljc10
                 END RECORD
DEFINE sr5       RECORD
       ljd02     LIKE ljd_file.ljd02,
       ljd03     LIKE ljd_file.ljd03,
       ljd04     LIKE ljd_file.ljd04,
       ljd05     LIKE ljd_file.ljd05,
       ljd06     LIKE ljd_file.ljd06,
       ljd07     LIKE ljd_file.ljd07,
       ljd08     LIKE ljd_file.ljd08
                 END RECORD
     LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,
                        ?,?,?,?,?, ?,?,?,?,?,?)"
     PREPARE insert_prep FROM g_sql
     IF STATUS THEN
        CALL cl_err('insert_prep:',status,1)
        CALL cl_used(g_prog, g_time,2) RETURNING g_time
        CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)
        EXIT PROGRAM
     END IF
  
     LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
               " VALUES(?,?,?,?,?,?, ?,?,?,?,?)"
     PREPARE insert_prep1 FROM g_sql
     IF STATUS THEN
        CALL cl_err('insert_prep1:',status,1)
        CALL cl_used(g_prog, g_time,2) RETURNING g_time
        CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)
        EXIT PROGRAM
     END IF
     LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,
               " VALUES(?,?,?,?,?, ?,?)"
     PREPARE insert_prep2 FROM g_sql
     IF STATUS THEN
        CALL cl_err('insert_prep2:',status,1)
        CALL cl_used(g_prog, g_time,2) RETURNING g_time
        CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)
        EXIT PROGRAM
     END IF
     CALL cl_del_data(l_table) 
     CALL cl_del_data(l_table1) 
     CALL cl_del_data(l_table2)
     LOCATE l_img_blob IN MEMORY
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     LET l_sql = "SELECT ljaplant,lja01,lja05,lja12,lja03,lja14,lja06,lja04,lja15,lja20,lja07,lja10,",
                 "       ljb02,ljb03,ljb04,ljb05,ljb06,ljb07,ljb08",
                 "  FROM lja_file,ljb_file",
                 " WHERE lja01 = '",g_lja.lja01,"'",
                 "   AND ljb01 = lja01"
     PREPARE t381_prepare1 FROM l_sql
     DECLARE t381_cs1 CURSOR FOR t381_prepare1
     DISPLAY l_table
     FOREACH t381_cs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('prepare:',SQLCA.sqlcode,1)
          CALL cl_used(g_prog,g_time,2) RETURNING g_time
          CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)
          EXIT PROGRAM
       END IF
       LET l_rtz13 = ' '
       SELECT rtz13 INTO l_rtz13 FROM rtz_file WHERE rtz01 = sr.ljaplant
       LET l_lne05 = ' '
       SELECT lne05 INTO l_lne05 FROM lne_file WHERE lne01 = sr.lja12
       LET l_gen02 = ' '
       SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = sr.lja04
       LET l_oaj02 = ' '
       SELECT oaj02 INTO l_oaj02 FROM oaj_file WHERE oaj01 = sr.ljb04
       SELECT lmf13 INTO l_lmf13 FROM lmf_file WHERE lmf01 = sr.lja06
       SELECT lnt60,lnt10,lnt33 INTO l_lnt60,l_lnt10,l_lnt33 FROM lnt_file WHERE lnt01 = sr.lja05
       EXECUTE insert_prep USING sr.*,"",l_img_blob,"N","",l_rtz13,l_lne05,l_gen02,l_oaj02,l_lmf13,l_lnt60,l_lnt10,l_lnt33
     END FOREACH
     LET l_sql = "SELECT ljc01,ljc02,ljc03,ljb03,ljc04,ljc05,ljc06,ljc07,ljc08,ljc09,ljc10",
                 "  FROM ljb_file,ljc_file",
                 " WHERE ljc01 = '",g_lja.lja01,"'",
                 "   AND ljb01 = ljc04 ",
                 "   AND ljb02 = ljc05 "
     PREPARE t381_prepare2 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)
        EXIT PROGRAM
     END IF
     DECLARE t381_cs2 CURSOR FOR t381_prepare2
     DISPLAY l_table1
     FOREACH t381_cs2 INTO sr4.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       EXECUTE insert_prep1 USING sr4.*
     END FOREACH
     LET l_sql = "SELECT ljd02,ljd03,ljd04,ljd05,ljd06,ljd07,ljd08",
                 "  FROM ljd_file",
                 " WHERE ljd01 = '",g_lja.lja01,"'"
     PREPARE t381_prepare3 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)
        EXIT PROGRAM
     END IF
     DECLARE t381_cs3 CURSOR FOR t381_prepare3
     DISPLAY l_table2
     FOREACH t381_cs3 INTO sr5.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       EXECUTE insert_prep2 USING sr5.*
     END FOREACH
     LET g_cr_table = l_table
     LET g_cr_apr_key_f = "lja01"
     CALL t381_grdata()
END FUNCTION

FUNCTION t381_grdata()
   DEFINE l_sql    STRING
   DEFINE handler  om.SaxDocumentHandler
   DEFINE sr1      sr1_t
   DEFINE sr2      sr2_t
   DEFINE sr3      sr3_t
   DEFINE l_cnt    LIKE type_file.num10

   LET l_cnt = cl_gre_rowcnt(l_table)
   IF l_cnt <= 0 THEN 
      RETURN 
   END IF

   LOCATE sr1.sign_img IN MEMORY
   CALL cl_gre_init_apr()  
   WHILE TRUE
       CALL cl_gre_init_pageheader()            
       LET handler = cl_gre_outnam("almt381")
       IF handler IS NOT NULL THEN
           LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                       " ORDER BY lja01,ljb02"
           START REPORT almt381_rep TO XML HANDLER handler
           DECLARE almt381_datacur1 CURSOR FROM l_sql
           FOREACH almt381_datacur1 INTO sr1.*
               OUTPUT TO REPORT almt381_rep(sr1.*)
           END FOREACH
           FINISH REPORT almt381_rep
       END IF
       IF INT_FLAG = TRUE THEN
           LET INT_FLAG = FALSE
           EXIT WHILE
       END IF
   END WHILE
   CALL cl_gre_close_report()
END FUNCTION

REPORT almt381_rep(sr1)
    DEFINE sr1           sr1_t
    DEFINE sr2           sr2_t
    DEFINE sr3           sr3_t
    DEFINE l_lineno      LIKE type_file.num5
    DEFINE l_amt_sum     LIKE ljb_file.ljb07
    DEFINE l_ljb03       STRING
    DEFINE l_plant       STRING

    ORDER EXTERNAL BY sr1.lja01,sr1.ljb02
    
    FORMAT
        FIRST PAGE HEADER
           PRINTX g_grPageHeader.*    
           PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name 
              
        BEFORE GROUP OF sr1.lja01
           LET l_lineno = 0
        BEFORE GROUP OF sr1.ljb02

        ON EVERY ROW
           LET l_lineno = l_lineno + 1
           PRINTX l_lineno
           PRINTX sr1.*
           LET l_ljb03 = cl_gr_getmsg('gre-288',g_lang,sr1.ljb03)
           PRINTX l_ljb03
           LET l_plant = sr1.ljaplant,' ',sr1.rtz13
           PRINTX l_plant

        AFTER GROUP OF sr1.ljb02
        AFTER GROUP OF sr1.lja01
           LET l_amt_sum = GROUP SUM(sr1.ljb07) 
           PRINTX l_amt_sum                    
 
           LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
                       " ORDER BY ljc02"
           START REPORT almt381_subrep01
           DECLARE almt381_repcur2 CURSOR FROM g_sql
           FOREACH almt381_repcur2 INTO sr2.*
               OUTPUT TO REPORT almt381_subrep01(sr2.*)
           END FOREACH

           FINISH REPORT almt381_subrep01
           LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED,
                       " ORDER BY ljd02"
           START REPORT almt381_subrep02
           DECLARE almt381_repcur3 CURSOR FROM g_sql
           FOREACH almt381_repcur3 INTO sr3.*
               OUTPUT TO REPORT almt381_subrep02(sr3.*)
           END FOREACH
           FINISH REPORT almt381_subrep02
 

        ON LAST ROW
END REPORT
REPORT almt381_subrep01(sr2)
    DEFINE sr2 sr2_t
    DEFINE l_amt1_sum    LIKE ljc_file.ljc09
    DEFINE l_ljb03_1     STRING
    DEFINE l_ljc03       STRING 

    ORDER EXTERNAL BY sr2.ljc01
    
    FORMAT
        ON EVERY ROW
            PRINTX sr2.*
            LET l_ljb03_1 = cl_gr_getmsg('gre-288',g_lang,sr2.ljb03_1)
            PRINTX l_ljb03_1
            LET l_ljc03 = cl_gr_getmsg('gre-327',g_lang,sr2.ljc03)
            PRINTX l_ljc03

        AFTER GROUP OF sr2.ljc01
           LET l_amt1_sum = GROUP SUM(sr2.ljc09)
           PRINTX l_amt1_sum
END REPORT
REPORT almt381_subrep02(sr3)
    DEFINE sr3 sr3_t

    FORMAT
        ON EVERY ROW
            PRINTX sr3.*
END REPORT
#FUN-CB0076-------add------end
#CHI-C80041---begin
FUNCTION t381_v()
DEFINE l_chr LIKE type_file.chr1

   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_lja.lja01) THEN CALL cl_err('',-400,0) RETURN END IF  
 
   BEGIN WORK
 
   LET g_success='Y'
 
   OPEN t381_cl USING g_lja.lja01
   IF STATUS THEN
      CALL cl_err("OPEN t381_cl:", STATUS, 1)
      CLOSE t381_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t381_cl INTO g_lja.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lja.lja01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t381_cl ROLLBACK WORK RETURN
   END IF
   #-->確認不可作廢
   IF g_lja.ljaconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF 
   IF cl_void(0,0,g_lja.ljaconf)   THEN 
        LET l_chr=g_lja.ljaconf
        IF g_lja.ljaconf='N' THEN 
            LET g_lja.ljaconf='X' 
        ELSE
            LET g_lja.ljaconf='N'
        END IF
        UPDATE lja_file
            SET ljaconf=g_lja.ljaconf,  
                ljamodu=g_user,
                ljadate=g_today
            WHERE lja01=g_lja.lja01
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","lja_file",g_lja.lja01,"",SQLCA.sqlcode,"","",1)  
            LET g_lja.ljaconf=l_chr 
        END IF
        DISPLAY BY NAME g_lja.ljaconf
   END IF
 
   CLOSE t381_cl
   COMMIT WORK
   CALL cl_flow_notify(g_lja.lja01,'V')
 
END FUNCTION
#CHI-C80041---end
