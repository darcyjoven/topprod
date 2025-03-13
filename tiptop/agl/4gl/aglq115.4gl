# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: aglq115.4gl
# Descriptions...: 全年度財務報表列印
# Input parameter: 
# Return code....: 
# Date & Author..: FUN-C80102 12/10/11 By lujh
# Modify.........: No.FUN-CA0132 12/10/31 By wangrr 年度期別給默認值
# Modify.........: No.TQC-CC0122 13/01/11 By lujh “报表编号”栏位开窗应依据报表类型查詢資料

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD
                wc      LIKE type_file.chr1000,
                rtype   LIKE type_file.chr1,     #報表結構編號 
                a       LIKE mai_file.mai01,     #報表結構編號 
                b       LIKE aaa_file.aaa01,     #帳別編號     
                yy      LIKE type_file.num5,     #輸入年度     
                bm      LIKE type_file.num5,     #Begin 期別   
                em      LIKE type_file.num5,     #End 期別     
                c       LIKE type_file.chr1,     #異動額及餘額為0者是否列印
                d       LIKE type_file.chr1,     #金額單位                 
                e       LIKE type_file.num5,     #小數位數                 
                f       LIKE type_file.num5,     #列印最小階數            
                h       LIKE type_file.chr4,     #額外說明類別             
                o       LIKE type_file.chr1,     #轉換幣別否              
                p       LIKE azi_file.azi01,     #幣別
                q       LIKE azj_file.azj03,     #匯率
                r       LIKE azi_file.azi01,     #幣別
                more    LIKE type_file.chr1,      
                acc_code  LIKE type_file.chr1    
              END RECORD,
          bdate,edate    LIKE type_file.dat,     
          i,j,k          LIKE type_file.num5,    
          g_unit         LIKE type_file.num10,   #金額單位基數   
          g_bookno       LIKE aah_file.aah00,    #帳別
          g_mai02        LIKE mai_file.mai02,
          g_mai03        LIKE mai_file.mai03,
          g_tot          ARRAY[100,12] OF LIKE type_file.num20_6,    
          bal            ARRAY[12] OF LIKE type_file.num20_6,        
          g_basetot      ARRAY[12] OF LIKE type_file.num20_6,        
          amt            LIKE aah_file.aah04
   DEFINE g_aaa03        LIKE aaa_file.aaa03   
   DEFINE g_aaa09        LIKE aaa_file.aaa09    
   DEFINE g_i            LIKE type_file.num5     
   DEFINE g_msg          LIKE type_file.chr1000                                                                                        
   DEFINE l_table        STRING
   DEFINE g_sql          STRING
   DEFINE g_str          STRING
DEFINE  g_maj  DYNAMIC ARRAY OF RECORD
                 maj20     LIKE maj_file.maj20,
                 maj20e    LIKE maj_file.maj20e,
                 month01   LIKE type_file.num20_6,
                 month02   LIKE type_file.num20_6,
                 month03   LIKE type_file.num20_6,
                 month04   LIKE type_file.num20_6,
                 month05   LIKE type_file.num20_6,
                 month06   LIKE type_file.num20_6,
                 month07   LIKE type_file.num20_6,
                 month08   LIKE type_file.num20_6,
                 month09   LIKE type_file.num20_6,
                 month10   LIKE type_file.num20_6,
                 month11   LIKE type_file.num20_6,
                 month12   LIKE type_file.num20_6,
                 SUM       LIKE type_file.num20_6
              END RECORD 
DEFINE   g_rec_b        LIKE type_file.num10
DEFINE   g_row_count    LIKE type_file.num10
DEFINE   g_curs_index   LIKE type_file.num10
DEFINE   l_ac           LIKE type_file.num5 
DEFINE   g_cnt          LIKE type_file.num10

MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
 
   #No.FUN-780058---Begin                                                       
   LET g_sql = "maj31.maj_file.maj31,",  
               "maj20.maj_file.maj20,",                                         
               "maj20e.maj_file.maj20e,",                                       
               "maj02.maj_file.maj02,",   #項次(排序要用的)                     
               "maj03.maj_file.maj03,",   #列印碼                               
               "bal01.aah_file.aah04,",    #期初借                               
               "bal02.aah_file.aah04,",    #期初借                               
               "bal03.aah_file.aah04,",    #期初借                               
               "bal04.aah_file.aah04,",    #期初借                               
               "bal05.aah_file.aah04,",    #期初借                               
               "bal06.aah_file.aah04,",    #期初借                               
               "bal07.aah_file.aah04,",    #期初借                               
               "bal08.aah_file.aah04,",    #期初借                               
               "bal09.aah_file.aah04,",    #期初借                               
               "bal10.aah_file.aah04,",    #期初借                               
               "bal11.aah_file.aah04,",    #期初借                               
               "bal12.aah_file.aah04,",    #期初借                               
               "bal13.aah_file.aah04,",    #期初借                               
               "line.type_file.num5"      #1:表示此筆為空行 2:表示此筆不為空    
                                                                                
   LET l_table = cl_prt_temptable('aglq115',g_sql) CLIPPED   # 產生Temp Table   
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生   
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,#No.TQC-820008 
               " VALUES(?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?  )"   #FUN-B90140 add ?                                      
   PREPARE insert_prep FROM g_sql                                               
   IF STATUS THEN                                                               
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                         
   END IF                                                                       
   #No.FUN-780058---End     
    
   LET g_bookno= ARG_VAL(1)
   LET g_pdate = ARG_VAL(2)        # Get arguments from command line
   LET g_towhom= ARG_VAL(3)
   LET g_rlang = ARG_VAL(4)
   LET g_bgjob = ARG_VAL(5)
   LET g_prtway= ARG_VAL(6)
   LET g_copies= ARG_VAL(7)
   LET tm.rtype= ARG_VAL(8)
   LET tm.a    = ARG_VAL(9)
   LET tm.b    = ARG_VAL(10)   
   LET tm.yy   = ARG_VAL(11)
   LET tm.em   = ARG_VAL(12)
   LET tm.c    = ARG_VAL(13)
   LET tm.d    = ARG_VAL(14)
   LET tm.e    = ARG_VAL(15)
   LET tm.f    = ARG_VAL(16)
   LET tm.h    = ARG_VAL(17)
   LET tm.o    = ARG_VAL(18)
   LET tm.p    = ARG_VAL(19)
   LET tm.q    = ARG_VAL(20)
   LET tm.r    = ARG_VAL(21)   
   LET g_rep_user = ARG_VAL(22)
   LET g_rep_clas = ARG_VAL(23)
   LET g_template = ARG_VAL(24)
   LET g_rpt_name = ARG_VAL(25)  

   OPEN WINDOW q115_w AT 5,10
        WITH FORM "agl/42f/aglq115" ATTRIBUTE(STYLE = g_win_style)
 
   CALL cl_ui_init()
 
   IF cl_null(g_bookno) THEN
      LET g_bookno = g_aaz.aaz64
   END IF

   IF cl_null(tm.b) THEN
      LET tm.b = g_aza.aza81
   END IF

   CALL q115_tm()   
   CALL q115_menu() 
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN

FUNCTION q115_menu()
   DEFINE   l_cmd   LIKE type_file.chr1000
 
   WHILE TRUE
      CALL q115_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q115_tm()
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL q115_out()
            END IF

         #FUN-C80102--mark--str--
         #WHEN "find_detail"
         #   IF cl_chk_act_auth() THEN
         #      #CALL q115_detail()
         #   END IF
         #FUN-C80102--mark--end--

         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel
               (ui.Interface.getRootNode(),base.TypeInfo.create(g_maj),'','')
            END IF         
      END CASE
   END WHILE
END FUNCTION

FUNCTION q115_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1        
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_maj TO s_maj.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         IF g_rec_b != 0 AND l_ac != 0 THEN  
            CALL fgl_set_arr_curr(l_ac)     
         END IF                            
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY 
          
      #FUN-C80102--mark--str--
      #ON ACTION find_detail
      #   LET g_action_choice="find_detail"
      #   EXIT DISPLAY
      #FUN-C80102--mark--end--
         
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY 

      AFTER DISPLAY
         CONTINUE DISPLAY
 
      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION q115_tm()
   DEFINE p_row,p_col   LIKE type_file.num5,                        
          l_sw          LIKE type_file.chr1,       #重要欄位是否空白 
          l_cmd         LIKE type_file.chr1000,                      
          li_chk_bookno LIKE type_file.num5,       
          li_result     LIKE type_file.num5        
   DEFINE lc_qbe_sn     LIKE gbm_file.gbm01        
 
   CALL s_dsmark(g_bookno)
    
   CALL cl_ui_init()
 
   CALL  s_shwact(0,0,g_bookno)
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   CLEAR FORM
   CALL g_maj.clear()
 
   #使用預設帳別之幣別
   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = g_bookno
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","aaa_file",g_bookno,"",SQLCA.sqlcode,"","sel aaa:",0)   
   END IF
 
   #使用預設帳別之幣別之小數位數
   SELECT azi05 INTO tm.e FROM azi_file WHERE azi01 = g_aaa03
   IF SQLCA.sqlcode THEN 
      CALL cl_err3("sel","azi_file", g_aaa03,"",SQLCA.sqlcode,"","sel azi:",0)  
   END IF
 
   LET tm.rtype = '1'   #TQC-CC0122 add
   LET tm.b = g_aza.aza81  
   LET tm.c = 'Y'
   LET tm.d = '1'
   LET tm.f = 0
   LET tm.h = 'N'
   LET tm.o = 'N'
   LET tm.p = g_aaa03
   LET tm.q = 1
   LET tm.r = g_aaa03
   LET tm.more = 'N'
   LET tm.acc_code = 'N'  
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.yy = YEAR(g_today)  #FUN-CA0132
   LET tm.em = MONTH(g_today) #FUN-CA0132
 
   WHILE TRUE
 
      LET l_sw = 1
 
      INPUT BY NAME tm.rtype,tm.b,tm.a,tm.yy,tm.em,tm.e,tm.f, 
                    tm.d,tm.acc_code,tm.c,tm.h,tm.o,tm.r, 
                    tm.p,tm.q WITHOUT DEFAULTS  

         BEFORE INPUT
             CALL cl_qbe_init()
 
         ON ACTION locale
            LET g_action_choice = "locale"
            CALL cl_dynamic_locale()                  
            CALL cl_show_fld_cont()                   
      
         AFTER FIELD a
            IF tm.a IS NULL THEN
               NEXT FIELD a
            END IF
            CALL s_chkmai(tm.a,'RGL') RETURNING li_result
            IF NOT li_result THEN
              CALL cl_err(tm.a,g_errno,1)
              NEXT FIELD a
            END IF
            SELECT mai02,mai03 INTO g_mai02,g_mai03 FROM mai_file
             WHERE mai01 = tm.a
               AND mai00 = tm.b     
               AND maiacti IN ('Y','y')
            IF STATUS THEN
               CALL cl_err3("sel","mai_file",tm.a,"",STATUS,"","sel mai:",0)   
               NEXT FIELD a
            ELSE
               IF g_mai03 = '5' OR g_mai03 = '6' THEN
                  CALL cl_err('','agl-268',0)
                  NEXT FIELD a
               END IF
            END IF
      
         AFTER FIELD b
            IF tm.b IS NULL THEN 
               NEXT FIELD b
            END IF
             CALL s_check_bookno(tm.b,g_user,g_plant) 
                  RETURNING li_chk_bookno
             IF (NOT li_chk_bookno) THEN
                NEXT FIELD b
             END IF 
            SELECT aaa02 FROM aaa_file WHERE aaa01=tm.b AND aaaacti IN ('Y','y')
            IF STATUS THEN 
               CALL cl_err3("sel","aaa_file",tm.b,"",STATUS,"","sel aaa:",0)   
               NEXT FIELD b 
            END IF
      
         AFTER FIELD c
            IF tm.c IS NULL OR tm.c NOT MATCHES "[YN]" THEN
               NEXT FIELD c 
            END IF
      
         AFTER FIELD yy
            IF tm.yy IS NULL OR tm.yy = 0 THEN
               NEXT FIELD yy 
            END IF
      
         AFTER FIELD em

         IF NOT cl_null(tm.em) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.yy
            IF g_azm.azm02 = 1 THEN
               IF tm.em > 12 OR tm.em < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD em
               END IF
            ELSE
               IF tm.em > 13 OR tm.em < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD em
               END IF
            END IF
         END IF

            IF tm.em IS NULL THEN
               NEXT FIELD em
            END IF

      
         AFTER FIELD d
            IF tm.d IS NULL OR tm.d NOT MATCHES'[123]' THEN
               NEXT FIELD d
            END IF
            IF tm.d = '1' THEN
               LET g_unit = 1
            END IF
            IF tm.d = '2' THEN
               LET g_unit = 1000
            END IF
            IF tm.d = '3' THEN
               LET g_unit = 1000000
            END IF
      
         AFTER FIELD e
            IF tm.e < 0 THEN
               LET tm.e = 0
               DISPLAY BY NAME tm.e
            END IF
      
         AFTER FIELD f
            IF tm.f IS NULL OR tm.f < 0 THEN
               LET tm.f = 0
               DISPLAY BY NAME tm.f
               NEXT FIELD f
            END IF
      
         AFTER FIELD h
            IF tm.h NOT MATCHES "[YN]" THEN
               NEXT FIELD h
            END IF
      
         AFTER FIELD o
            IF tm.o IS NULL OR tm.o NOT MATCHES'[YN]' THEN
               NEXT FIELD o
            END IF
            IF tm.o = 'N' THEN 
               LET tm.p = g_aaa03 
               LET tm.q = 1
               DISPLAY g_aaa03 TO p
               DISPLAY BY NAME tm.q
            END IF
      
         BEFORE FIELD p
            IF tm.o = 'N' THEN
               NEXT FIELD more 
            END IF
      
         AFTER FIELD p
            SELECT azi01 FROM azi_file WHERE azi01 = tm.p
            IF SQLCA.sqlcode THEN
               CALL cl_err3("sel","azi_file",tm.p,"","agl-109","","",0)   
               NEXT FIELD p
            END IF
      
         BEFORE FIELD q
            IF tm.o = 'N' THEN 
               NEXT FIELD o
            END IF
      
         AFTER INPUT 
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
            IF tm.yy IS NULL THEN 
               LET l_sw = 0 
               DISPLAY BY NAME tm.yy 
               CALL cl_err('',9033,0)
            END IF
            IF tm.em IS NULL THEN 
               LET l_sw = 0 
               DISPLAY BY NAME tm.em 
            END IF
            IF l_sw = 0 THEN 
               LET l_sw = 1 
               NEXT FIELD a
               CALL cl_err('',9033,0)
            END IF
            IF tm.d = '1' THEN
               LET g_unit = 1
            END IF
            IF tm.d = '2' THEN
               LET g_unit = 1000
            END IF
            IF tm.d = '3' THEN
               LET g_unit = 1000000
            END IF
      
 
         ON ACTION CONTROLZ
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask() 
 
         ON ACTION CONTROLP
            IF INFIELD(a) THEN
               #TQC-CC0122--add--str--
               IF tm.rtype = '1' THEN
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_mai'
                  LET g_qryparam.default1 = tm.a
                  LET g_qryparam.where = " mai00 = '",tm.b,"' AND mai03 NOT IN ('5','6') AND mai03 = '2'"   
                  CALL cl_create_qry() RETURNING tm.a
                  DISPLAY BY NAME tm.a
                  NEXT FIELD a
               END IF
               IF tm.rtype = '2' THEN
               #TQC-CC0122--add--end--
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_mai'
                  LET g_qryparam.default1 = tm.a
                  #LET g_qryparam.where = " mai00 = '",tm.b,"' AND mai03 NOT IN ('5','6')"     #TQC-CC0122  mark
                  LET g_qryparam.where = " mai00 = '",tm.b,"' AND mai03 NOT IN ('5','6') AND mai03 = '3'"   #TQC-CC0122  add
                  CALL cl_create_qry() RETURNING tm.a
                  DISPLAY BY NAME tm.a
                  NEXT FIELD a
               END IF   #TQC-CC0122  add 
            END IF
 
            IF INFIELD(p) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = 'q_azi'
               LET g_qryparam.default1 = tm.p
               CALL cl_create_qry() RETURNING tm.p
               DISPLAY BY NAME tm.p
               NEXT FIELD p
            END IF
 
            IF INFIELD(b) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form='q_aaa'
               LET g_qryparam.default1=tm.b
               CALL cl_create_qry() RETURNING tm.b
               DISPLAY BY NAME tm.b
               NEXT FIELD b
            END IF
 
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
      
         ON ACTION qbe_select
            CALL cl_qbe_select()
            CALL cl_qbe_display_condition(lc_qbe_sn)
            LET tm.rtype = GET_FLDBUF(rtype)
            LET tm.b = GET_FLDBUF(b)
            LET tm.a = GET_FLDBUF(a)
            LET tm.yy = GET_FLDBUF(yy)
            LET tm.em = GET_FLDBUF(em)
            LET tm.e = GET_FLDBUF(e)
            LET tm.f = GET_FLDBUF(f)
            LET tm.d = GET_FLDBUF(d)
            LET tm.acc_code = GET_FLDBUF(acc_code)
            LET tm.c = GET_FLDBUF(c)
            LET tm.h = GET_FLDBUF(h)
            LET tm.o = GET_FLDBUF(o)
            LET tm.r = GET_FLDBUF(r)
            LET tm.p = GET_FLDBUF(p)
            LET tm.q = GET_FLDBUF(q)
            LET tm.more = GET_FLDBUF(more)
 
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
      END INPUT
      
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         RETURN
      END IF
      
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    
          WHERE zz01='aglq115'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('aglq115','9031',1)   
         ELSE
            LET l_cmd = l_cmd CLIPPED,        
                        " '",g_bookno CLIPPED,"'" ,
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'", 
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.rtype CLIPPED,"'",
                        " '",tm.a CLIPPED,"'",
                        " '",tm.b CLIPPED,"'",   
                        " '",tm.yy CLIPPED,"'",
                        " '",tm.em CLIPPED,"'",
                        " '",tm.c CLIPPED,"'",
                        " '",tm.d CLIPPED,"'",
                        " '",tm.e CLIPPED,"'",
                        " '",tm.f CLIPPED,"'",
                        " '",tm.h CLIPPED,"'",
                        " '",tm.o CLIPPED,"'",
                        " '",tm.p CLIPPED,"'",
                        " '",tm.q CLIPPED,"'",
                        " '",tm.r CLIPPED,"'",   
                         " '",g_rep_user CLIPPED,"'",          
                         " '",g_rep_clas CLIPPED,"'",           
                         " '",g_template CLIPPED,"'",           
                         " '",g_rpt_name CLIPPED,"'"            
            CALL cl_cmdat('aglq115',g_time,l_cmd)    
         END IF
 
         CLOSE WINDOW q115_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
      CALL q115()
 
      ERROR ""
      EXIT WHILE
   END WHILE
 
   IF INT_FLAG THEN    
      LET INT_FLAG = 0
      RETURN         
   END IF 
   
   CALL q115_b_fill()   
   CALL cl_show_fld_cont() 

   IF tm.h = 'Y' THEN 
      CALL cl_set_comp_visible("maj20e",TRUE)
   ELSE
      CALL cl_set_comp_visible("maj20e",FALSE)
   END IF 
   IF tm.rtype = "1" THEN  
      CALL cl_set_comp_visible("sum",FALSE)
   ELSE
      CALL cl_set_comp_visible("sum",TRUE)
   END IF 
 
END FUNCTION
 
FUNCTION q115()
   DEFINE l_name    LIKE type_file.chr20        
   DEFINE l_sql     LIKE type_file.chr1000      
   DEFINE l_chr     LIKE type_file.chr1         
   DEFINE maj       RECORD LIKE maj_file.*
   DEFINE l_endy1   LIKE abb_file.abb07          
   DEFINE l_endy2   LIKE abb_file.abb07       
   DEFINE l_aeh11    LIKE aeh_file.aeh11
   DEFINE l_aeh12    LIKE aeh_file.aeh12
   DEFINE l_aeh15    LIKE aeh_file.aeh15
   DEFINE l_aeh16    LIKE aeh_file.aeh16
   DEFINE sr        RECORD
                       bal01,bal02,bal03,bal04,bal05,bal06,
                       bal07,bal08,bal09,bal10,bal11,bal12,
                       bal13   LIKE aah_file.aah04
                    END RECORD
 
   CALL cl_del_data(l_table)    

   CALL q115_table()   
 
   SELECT aaf03 INTO g_company FROM aaf_file
    WHERE aaf01 = tm.b AND aaf02 = g_rlang
 
   CASE WHEN tm.rtype='1' LET g_msg=" maj23[1,1]='1'"
        WHEN tm.rtype='2' LET g_msg=" maj23[1,1]='2'"
        OTHERWISE         LET g_msg=" 1=1"
   END CASE
 
   LET l_sql = "SELECT * FROM maj_file",
               " WHERE maj01 = '",tm.a,"'",
               "   AND ",g_msg CLIPPED,
               " ORDER BY maj02"
   PREPARE q115_p FROM l_sql
   IF STATUS THEN
      CALL cl_err('prepare:',STATUS,1)   
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
   END IF
   DECLARE q115_c CURSOR FOR q115_p
 
   FOR i = 1 TO 100 
      FOR j = 1 TO 12
         LET g_tot[i,j] = 0 
      END FOR
   END FOR
 
   FOREACH q115_c INTO maj.*
      IF STATUS THEN
         CALL cl_err('foreach:',STATUS,1)
         EXIT FOREACH
      END IF
 
      FOR i = 1 TO 12
         LET bal[i] = 0
      END FOR
 
      FOR i = 1 TO tm.em
         LET amt = 0
         IF NOT cl_null(maj.maj21) THEN
            IF tm.rtype='1' THEN
               LET tm.bm = 0
            ELSE
               LET tm.bm = i
            END IF                                                        
            IF maj.maj06 NOT MATCHES '[12345]' THEN CONTINUE FOREACH END IF     
                                                                                
            IF maj.maj06='4' THEN      ## 借方金额                              
               IF maj.maj24 IS NULL THEN                                        
                  SELECT SUM(aah04) INTO amt                                    
                    FROM aah_file,aag_file                                      
                   WHERE aah00 = tm.b                                           
                     AND aah00 = aag00                        
                     AND aah01 BETWEEN maj.maj21 AND maj.maj22                  
                     AND aah02 = tm.yy                                          
                     AND aah03 BETWEEN tm.bm AND i                              
                     AND aah01 = aag01                                          
                     AND aag07 IN ('2','3')                  
               ELSE                                                             
                  SELECT SUM(aao05) INTO amt                                    
                    FROM aao_file,aag_file                                      
                   WHERE aao00 = tm.b                                           
                     AND aao00 = aag00                           
                     AND aao01 BETWEEN maj.maj21 AND maj.maj22                  
                     AND aao02 BETWEEN maj.maj24 AND maj.maj25                  
                     AND aao03 = tm.yy                                          
                     AND aao04 BETWEEN tm.bm AND i                              
                     AND aao01 = aag01                                           
                     AND aag07 IN ('2','3')                   
               END IF                                                           
            END IF
            IF maj.maj06='5' THEN      ## 贷方金额                              
               IF maj.maj24 IS NULL THEN                                        
                  SELECT SUM(aah05) INTO amt                                    
                    FROM aah_file,aag_file                                      
                   WHERE aah00 = tm.b                                           
                     AND aah00 = aag00                          
                     AND aah01 BETWEEN maj.maj21 AND maj.maj22                  
                     AND aah02 = tm.yy                                          
                     AND aah03 BETWEEN tm.bm AND i                              
                     AND aah01 = aag01                                            
                     AND aag07 IN ('2','3')                   
               ELSE                                                             
                  SELECT SUM(aao06) INTO amt                                    
                    FROM aao_file,aag_file                                      
                   WHERE aao00 = tm.b                                           
                     AND aao00 = aag00                        
                     AND aao01 BETWEEN maj.maj21 AND maj.maj22                  
                     AND aao02 BETWEEN maj.maj24 AND maj.maj25                  
                     AND aao03 = tm.yy                                          
                     AND aao04 BETWEEN tm.bm AND i                              
                     AND aao01 = aag01                                          
                     AND aag07 IN ('2','3')                  
               END IF  
            END IF                                                              
                                                                                
                                                                                
            IF maj.maj06<'4' THEN                        
               IF maj.maj24 IS NULL THEN                                        
                  SELECT SUM(aah04-aah05) INTO amt                              
                    FROM aah_file,aag_file                                      
                   WHERE aah00 = tm.b                                           
                     AND aah00 = aag00                           
                     AND aah01 BETWEEN maj.maj21 AND maj.maj22                  
                     AND aah02 = tm.yy                                          
                     AND aah03 BETWEEN tm.bm AND i                              
                     AND aah01 = aag01                                           
                     AND aag07 IN ('2','3')                   
               ELSE                                                             
                  SELECT SUM(aao05-aao06) INTO amt                              
                    FROM aao_file,aag_file                                      
                   WHERE aao00 = tm.b                                           
                     AND aao00 = aag00                         
                     AND aao01 BETWEEN maj.maj21 AND maj.maj22                  
                     AND aao02 BETWEEN maj.maj24 AND maj.maj25                  
                     AND aao03 = tm.yy                                          
                     AND aao04 BETWEEN tm.bm AND i
                     AND aao01 = aag01                                           
                     AND aag07 IN ('2','3')                  
               END IF                                                           
               IF maj.maj06 ='3' THEN                                           
                  IF maj.maj24 IS NULL THEN                                     
                     SELECT SUM(aah04-aah05) INTO amt                           
                       FROM aah_file,aag_file                                   
                      WHERE aah00 = tm.b                                        
                        AND aah00 = aag00                       
                        AND aah01 BETWEEN maj.maj21 AND maj.maj22               
                        AND aah02 = tm.yy                                       
                        AND aah03 <=i                               
                        AND aah01 = aag01                                       
                        AND aag07 IN ('2','3')                  
                  ELSE                                                          
                     SELECT SUM(aao05-aao06) INTO amt                           
                       FROM aao_file,aag_file                                   
                      WHERE aao00 = tm.b                                        
                        AND aao00 = aag00                       
                        AND aao01 BETWEEN maj.maj21 AND maj.maj22               
                        AND aao02 BETWEEN maj.maj24 AND maj.maj25               
                        AND aao03 = tm.yy                                       
                        AND aao04 <=i                               
                        AND aao01 = aag01                                       
                        AND aag07 IN ('2','3')                 
                  END IF                                                        
               END IF                                                           
               IF maj.maj06 ='1' THEN                                           
                  IF maj.maj24 IS NULL THEN                                     
                     SELECT SUM(aah04-aah05) INTO amt                           
                       FROM aah_file,aag_file                                   
                      WHERE aah00 = tm.b                                        
                        AND aah00 = aag00                        
                        AND aah01 BETWEEN maj.maj21 AND maj.maj22               
                        AND aah02 = tm.yy                                       
                        AND aah03 < tm.bm                                                               
                        AND aah01 = aag01                                       
                        AND aag07 IN ('2','3')                   
                  ELSE                                                          
                     SELECT SUM(aao05-aao06) INTO amt                           
                       FROM aao_file,aag_file                                   
                      WHERE aao00 = tm.b                                        
                        AND aao00 = aag00                       
                        AND aao01 BETWEEN maj.maj21 AND maj.maj22               
                        AND aao02 BETWEEN maj.maj24 AND maj.maj25               
                        AND aao03 = tm.yy
                        AND aao04 < tm.bm                                                               
                        AND aao01 = aag01                                       
                        AND aag07 IN ('2','3')                   
                  END IF                                                        
               END IF                                                           
            END IF   
 
            IF STATUS THEN 
               CALL cl_err('sel aah1:',STATUS,1)
               EXIT FOREACH 
            END IF
 
            IF amt IS NULL THEN LET amt = 0 END IF

            LET g_aaa09 = ''
            SELECT aaa09 INTO g_aaa09 FROM aaa_file WHERE aaa01=tm.b
            IF g_aaa09 = '2' THEN   #帳結法
                CALL s_minus_ce(tm.b, maj.maj21, maj.maj22, NULL,     NULL,     NULL,
                                NULL,      NULL,      NULL,      NULL,     NULL,     tm.yy,
                                tm.bm,     i,        NULL,      NULL,      NULL,     NULL,
                                NULL,    NULL,      NULL,      NULL,     g_plant,  g_aaa09,'0')
                RETURNING  l_aeh11,l_aeh12,l_aeh15,l_aeh16
                #减借加贷
                LET amt = amt - l_aeh11 + l_aeh12
            END IF
         END IF
        IF NOT cl_null(maj.maj21) THEN
           IF maj.maj06 MATCHES '[123]' AND maj.maj07 = '2' THEN
              LET amt = amt * -1
           END IF
           IF maj.maj06 = '4' AND maj.maj07 = '2' THEN
              LET amt = amt * -1
           END IF
           IF maj.maj06 = '5' AND maj.maj07 = '1' THEN
              LET amt = amt * -1
           END IF
        END IF
 
         IF tm.o = 'Y' THEN   #匯率的轉換
            LET amt = amt * tm.q 
         END IF
 
         IF maj.maj03 MATCHES "[012]" AND maj.maj08 > 0 THEN     #合計階數處理
            FOR j=1 TO 100
               IF maj.maj09 = '-' THEN
                  LET g_tot[j,i] = g_tot[j,i] - amt
               ELSE
                  LET g_tot[j,i] = g_tot[j,i] + amt
               END IF
            END FOR
            LET k = maj.maj08
            LET bal[i] = g_tot[k,i]
            IF maj.maj07 = '1' AND maj.maj09 = '-' THEN
               LET bal[i] = bal[i] *-1
            END IF
            FOR j = 1 TO maj.maj08 
               LET g_tot[j,i] = 0
            END FOR
         ELSE 
            IF maj.maj03='5' THEN
               LET bal[i]=amt
            ELSE
               LET bal[i]=0
            END IF
         END IF
 
         IF maj.maj11 = 'Y' THEN                  # 百分比基準科目
            LET g_basetot[i] = bal[i]
            IF maj.maj07 = '2' THEN 
               LET g_basetot[i] = g_basetot[i] * -1
            END IF
            IF g_basetot[i] = 0 THEN
               LET g_basetot[i] = NULL
            END IF
         END IF
         IF maj.maj03 = 'H' THEN
            LET bal[i] = NULL
         END IF
      END FOR
 
      IF maj.maj03 = '0' THEN
         CONTINUE FOREACH 
      END IF #本行不印出
 
      IF (tm.c='N' OR maj.maj03='2') AND maj.maj03 MATCHES "[0125]"  
         AND bal[1]=0 AND bal[2]=0 AND bal[3]=0 AND bal[4]=0
         AND bal[5]=0 AND bal[6]=0 AND bal[7]=0 AND bal[8]=0
         AND bal[9]=0 AND bal[10]=0 AND bal[11]=0 AND bal[12]=0 THEN
         CONTINUE FOREACH                        #餘額為 0 者不列印
      END IF
 
      IF tm.f > 0 AND maj.maj08 < tm.f THEN
         CONTINUE FOREACH                        #最小階數起列印
      END IF
      IF maj.maj06 NOT MATCHES "[13]" THEN                                           
         LET sr.bal13=bal[1]+bal[2]+bal[3]+bal[4]+bal[5]+bal[6]+   
                      bal[7]+bal[8]+bal[9]+bal[10]+bal[11]+bal[12] 
      ELSE                                                         
         LET sr.bal13=bal[tm.em]    
      END IF                                                      
 
      IF tm.rtype = '1' THEN
         LET sr.bal13 = 0   
      END IF
 
      FOR i = tm.em + 1 TO 12 
         LET bal[i] = 0 
      END FOR
 
      LET sr.bal01=bal[1]
      LET sr.bal02=bal[2]
      LET sr.bal03=bal[3]
      LET sr.bal04=bal[4]
      LET sr.bal05=bal[5]
      LET sr.bal06=bal[6]
      LET sr.bal07=bal[7]
      LET sr.bal08=bal[8]
      LET sr.bal09=bal[9]
      LET sr.bal10=bal[10]
      LET sr.bal11=bal[11]
      LET sr.bal12=bal[12]
 
       IF maj.maj07='2' AND maj.maj09='-' THEN      
          LET sr.bal01 = sr.bal01 * -1
          LET sr.bal02 = sr.bal02 * -1
          LET sr.bal03 = sr.bal03 * -1
          LET sr.bal04 = sr.bal04 * -1
          LET sr.bal05 = sr.bal05 * -1
          LET sr.bal06 = sr.bal06 * -1
          LET sr.bal07 = sr.bal07 * -1
          LET sr.bal08 = sr.bal08 * -1
          LET sr.bal09 = sr.bal09 * -1
          LET sr.bal10 = sr.bal10 * -1
          LET sr.bal11 = sr.bal11 * -1
          LET sr.bal12 = sr.bal12 * -1
          LET sr.bal13 = sr.bal13 * -1
       END IF
 
      LET maj.maj20 = maj.maj05 SPACES,maj.maj20
 
      LET sr.bal01=sr.bal01/g_unit                                       
      LET sr.bal02=sr.bal02/g_unit                                       
      LET sr.bal03=sr.bal03/g_unit                                       
      LET sr.bal04=sr.bal04/g_unit                                       
      LET sr.bal05=sr.bal05/g_unit                                       
      LET sr.bal06=sr.bal06/g_unit                                       
      LET sr.bal07=sr.bal07/g_unit                                       
      LET sr.bal08=sr.bal08/g_unit                                       
      LET sr.bal09=sr.bal09/g_unit                                       
      LET sr.bal10=sr.bal10/g_unit                                       
      LET sr.bal11=sr.bal11/g_unit                                       
      LET sr.bal12=sr.bal12/g_unit                                       
      LET sr.bal13=sr.bal13/g_unit 
 
      IF maj.maj04 = 0 THEN                                                       
         INSERT INTO aglq115_tmp VALUES(maj.maj31,  
            maj.maj20,maj.maj20e,maj.maj02,maj.maj03,                           
            sr.bal01,sr.bal02,sr.bal03,sr.bal04,                           
            sr.bal05,sr.bal06,sr.bal07,sr.bal08,
            sr.bal09,sr.bal10,sr.bal11,sr.bal12,
            sr.bal13,'2')                   
      ELSE                                                                      
            INSERT INTO aglq115_tmp VALUES(maj.maj31,           
            maj.maj20,maj.maj20e,maj.maj02,maj.maj03,                           
            sr.bal01,sr.bal02,sr.bal03,sr.bal04,                                
            sr.bal05,sr.bal06,sr.bal07,sr.bal08,                                
            sr.bal09,sr.bal10,sr.bal11,sr.bal12,                                
            sr.bal13,'2')    
         #空行的部份,以寫入同樣的maj20資料列進Temptable,                        
         #但line=1來區別(line=2表示是非空行的資料),再用排序的方式,              
         #讓空行的這筆資料排在正常的資料前面印出                                
         FOR i = 1 TO maj.maj04                                                  
            INSERT INTO aglq115_tmp VALUES(maj.maj31,  
               maj.maj20,maj.maj20e,maj.maj02,'',                               
               '0','0','0','0',                                                 
               '0','0','0','0',                                                 
               '0','0','0','0',                                                 
               '0', '1')                                                                        
         END FOR                                                                
      END IF                                                       
   END FOREACH
 
END FUNCTION

FUNCTION q115_b_fill()

   LET g_sql = "SELECT maj20,maj20e,bal01,bal02,bal03,",
               " bal04,bal05,bal06,bal07,bal08,bal09,bal10,bal11,bal12,bal13 FROM aglq115_tmp order by maj02"
   PREPARE aglq115_pb FROM g_sql
   DECLARE maj_curs  CURSOR FOR aglq115_pb
   CALL g_maj.clear()
   LET g_cnt = 1
   LET g_rec_b = 0

   FOREACH maj_curs INTO g_maj[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF 
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	     EXIT FOREACH
      END IF
   END FOREACH 
   CALL g_maj.deleteElement(g_cnt)
   LET g_rec_b = g_cnt - 1
   DISPLAY g_rec_b TO FORMONLY.cnt
END FUNCTION 

FUNCTION q115_table()
   DROP TABLE aglq115_tmp;
   CREATE TEMP TABLE aglq115_tmp(
           maj31   LIKE  maj_file.maj31,  
           maj20   LIKE  maj_file.maj20,                                     
           maj20e  LIKE  maj_file.maj20e,                                      
           maj02   LIKE  maj_file.maj02,   #項次(排序要用的)                     
           maj03   LIKE  maj_file.maj03,   #列印碼                               
           bal01   LIKE  aah_file.aah04,   #期初借                               
           bal02   LIKE  aah_file.aah04,   #期初借                               
           bal03   LIKE  aah_file.aah04,   #期初借                               
           bal04   LIKE  aah_file.aah04,   #期初借                               
           bal05   LIKE  aah_file.aah04,   #期初借                               
           bal06   LIKE  aah_file.aah04,   #期初借                               
           bal07   LIKE  aah_file.aah04,   #期初借                               
           bal08   LIKE  aah_file.aah04,   #期初借                               
           bal09   LIKE  aah_file.aah04,   #期初借                               
           bal10   LIKE  aah_file.aah04,   #期初借                               
           bal11   LIKE  aah_file.aah04,   #期初借                               
           bal12   LIKE  aah_file.aah04,   #期初借                               
           bal13   LIKE  aah_file.aah04,   #期初借                               
           LINE    LIKE  type_file.num5);  #1:表示此筆為空行 2:表示此筆不為空
END FUNCTION

FUNCTION q115_out()
   DEFINE l_cmd        LIKE type_file.chr1000, 
          l_wc         LIKE type_file.chr1000 

   CALL cl_wait()
   IF tm.wc IS NULL THEN CALL cl_err('','9057',0) END IF
   LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
   LET l_cmd = "aglr115",
               " '",g_bookno CLIPPED,"' ", 
               " '",g_today CLIPPED,"' ''", 
               " '",g_lang CLIPPED,"' 'Y' '' '1'", 
               " '",tm.rtype CLIPPED,"' ",
               " '",tm.a CLIPPED,"' ", 
               " '",tm.b CLIPPED,"' ", 
               " '",tm.yy CLIPPED,"' ",
               " '",tm.em CLIPPED,"' ",
               " '",tm.c CLIPPED,"' ",
               " '",tm.d CLIPPED,"' ",
               " '",tm.e CLIPPED,"' ",
               " '",tm.f CLIPPED,"' ",
               " '",tm.h CLIPPED,"' ",
               " '",tm.o CLIPPED,"' ",
               " '",tm.p CLIPPED,"' ",
               " '",tm.q CLIPPED,"' ",
               " '",tm.r CLIPPED,"' '' '' '' ''" 
   CALL cl_cmdrun(l_cmd)
   ERROR ' '
END FUNCTION
