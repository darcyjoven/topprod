# Prog. Version..: '5.30.06-13.03.29(00002)'     #
#
# Pattern name...: aglq010.4gl
# Descriptions...: 多部門財務報表
# Date & Author..: FUN-C80102  12/09/24 By lujh
# Modify.........: No.TQC-CC0122 12/12/28 By lujh 加回CE憑證
# Modify.........: No.TQC-D10110 13/01/31 by lujh 連續2次查詢 單身欄位數量為累加
# Modify.........: No:FUN-D70095 13/08/23 BY fengmy  參照gglq812,修改讀取agli116計算邏輯
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD
           wc      LIKE type_file.chr1000,
           a       LIKE mai_file.mai01,     #報表結構編號     
           b       LIKE aaa_file.aaa01,     #帳別編號      
           abe01   LIKE abe_file.abe01,     #列印族群/部門層級/部門    
           yy      LIKE type_file.num5,     #輸入年度       
           bm      LIKE type_file.num5,     #Begin 期別   
           em      LIKE type_file.num5,     # End  期別    
           c       LIKE type_file.chr1,     #異動額及餘額為0者是否列印   
           d       LIKE type_file.chr1,     #金額單位             
           e       LIKE type_file.chr1,     #列印額外名稱 
           f       LIKE type_file.num5,     #列印最小階數         
           s       LIKE type_file.chr1,     #列印下層部門           
           p       LIKE type_file.chr1,     #分頁選項            
           more    LIKE type_file.chr1      #Input more condition(Y/N)      
           END RECORD,
       i,j,k,g_mm LIKE type_file.num5,      
       g_unit     LIKE type_file.num10,     #金額單位基數  
       g_buf      STRING,                    
       g_cn       LIKE type_file.num5,      
       g_flag     LIKE type_file.chr1,          
       g_bookno   LIKE aah_file.aah00,      #帳別      
       g_gem05    LIKE gem_file.gem05,
       m_dept     DYNAMIC ARRAY OF LIKE gem_file.gem02,   
       g_mai02    LIKE mai_file.mai02,
       g_mai03    LIKE mai_file.mai03,
       g_abd01    LIKE abd_file.abd01,
       g_abe01    LIKE abe_file.abe01,
       g_total    DYNAMIC ARRAY OF RECORD
                   maj02 LIKE maj_file.maj02,
                   amt    LIKE type_file.num20_6                   
                  END RECORD,
       g_tot1     DYNAMIC ARRAY OF  LIKE type_file.num20_6, 
       g_no       LIKE type_file.num5,                 
       g_dept     DYNAMIC ARRAY OF RECORD
                  gem01 LIKE gem_file.gem01, #部門編號
                  gem05 LIKE gem_file.gem05  #是否為會計部門
                  END RECORD,
       maj02_max  LIKE type_file.num5     #MOD-640089   
 
DEFINE g_aaa03    LIKE aaa_file.aaa03
DEFINE g_i        LIKE type_file.num5     
DEFINE g_sql      STRING                 
DEFINE l_table    STRING                  
DEFINE l_table1   STRING                  
DEFINE g_str      STRING                  
DEFINE g_cnt,l_n  LIKE type_file.num10  
DEFINE l_sql      STRING 

DEFINE  g_maj  DYNAMIC ARRAY OF RECORD   
                  maj20   LIKE maj_file.maj20,
                  maj20e  LIKE maj_file.maj20e,
                  dept1   LIKE type_file.num20_6,
                  dept2   LIKE type_file.num20_6,
                  dept3   LIKE type_file.num20_6,
                  dept4   LIKE type_file.num20_6,
                  dept5   LIKE type_file.num20_6,
                  dept6   LIKE type_file.num20_6,
                  dept7   LIKE type_file.num20_6,
                  dept8   LIKE type_file.num20_6,
                  dept9   LIKE type_file.num20_6,
                  dept10  LIKE type_file.num20_6,
                  dept11  LIKE type_file.num20_6,
                  dept12  LIKE type_file.num20_6,
                  dept13  LIKE type_file.num20_6,
                  dept14  LIKE type_file.num20_6,
                  dept15  LIKE type_file.num20_6,
                  dept16  LIKE type_file.num20_6,
                  dept17  LIKE type_file.num20_6,
                  dept18  LIKE type_file.num20_6,
                  dept19  LIKE type_file.num20_6,
                  dept20  LIKE type_file.num20_6,
                  dept21  LIKE type_file.num20_6,
                  dept22  LIKE type_file.num20_6,
                  dept23  LIKE type_file.num20_6,
                  dept24  LIKE type_file.num20_6,
                  dept25  LIKE type_file.num20_6,
                  dept26  LIKE type_file.num20_6,
                  dept27  LIKE type_file.num20_6,
                  dept28  LIKE type_file.num20_6,
                  dept29  LIKE type_file.num20_6,
                  dept30  LIKE type_file.num20_6,
                  dept31  LIKE type_file.num20_6,
                  dept32  LIKE type_file.num20_6,
                  dept33  LIKE type_file.num20_6,
                  dept34  LIKE type_file.num20_6,
                  dept35  LIKE type_file.num20_6,
                  dept36  LIKE type_file.num20_6,
                  dept37  LIKE type_file.num20_6,
                  dept38  LIKE type_file.num20_6,
                  dept39  LIKE type_file.num20_6,
                  dept40  LIKE type_file.num20_6,
                  dept41  LIKE type_file.num20_6,
                  dept42  LIKE type_file.num20_6,
                  dept43  LIKE type_file.num20_6,
                  dept44  LIKE type_file.num20_6,
                  dept45  LIKE type_file.num20_6,
                  dept46  LIKE type_file.num20_6,
                  dept47  LIKE type_file.num20_6,
                  dept48  LIKE type_file.num20_6,
                  dept49  LIKE type_file.num20_6,
                  dept50  LIKE type_file.num20_6,
                  SUM     LIKE type_file.num20_6
               END RECORD 
DEFINE sr2 RECORD  
              maj20     LIKE maj_file.maj20,
              maj20e    LIKE maj_file.maj20e,
              dept1     LIKE type_file.num20_6,
              dept2     LIKE type_file.num20_6,
              dept3     LIKE type_file.num20_6,
              dept4     LIKE type_file.num20_6,
              dept5     LIKE type_file.num20_6,
              dept6     LIKE type_file.num20_6,
              dept7     LIKE type_file.num20_6,
              dept8     LIKE type_file.num20_6,
              dept9     LIKE type_file.num20_6,
              dept10    LIKE type_file.num20_6,
              dept11    LIKE type_file.num20_6,
              dept12    LIKE type_file.num20_6,
              dept13    LIKE type_file.num20_6,
              dept14    LIKE type_file.num20_6,
              dept15    LIKE type_file.num20_6,
              dept16    LIKE type_file.num20_6,
              dept17    LIKE type_file.num20_6,
              dept18    LIKE type_file.num20_6,
              dept19    LIKE type_file.num20_6,
              dept20    LIKE type_file.num20_6,
              dept21    LIKE type_file.num20_6,
              dept22    LIKE type_file.num20_6,
              dept23    LIKE type_file.num20_6,
              dept24    LIKE type_file.num20_6,
              dept25    LIKE type_file.num20_6,
              dept26    LIKE type_file.num20_6,
              dept27    LIKE type_file.num20_6,
              dept28    LIKE type_file.num20_6,
              dept29    LIKE type_file.num20_6,
              dept30    LIKE type_file.num20_6,
              dept31    LIKE type_file.num20_6,
              dept32    LIKE type_file.num20_6,
              dept33    LIKE type_file.num20_6,
              dept34    LIKE type_file.num20_6,
              dept35    LIKE type_file.num20_6,
              dept36    LIKE type_file.num20_6,
              dept37    LIKE type_file.num20_6,
              dept38    LIKE type_file.num20_6,
              dept39    LIKE type_file.num20_6,
              dept40    LIKE type_file.num20_6,
              dept41    LIKE type_file.num20_6,
              dept42    LIKE type_file.num20_6,
              dept43    LIKE type_file.num20_6,
              dept44    LIKE type_file.num20_6,
              dept45    LIKE type_file.num20_6,
              dept46    LIKE type_file.num20_6,
              dept47    LIKE type_file.num20_6,
              dept48    LIKE type_file.num20_6,
              dept49    LIKE type_file.num20_6,
              dept50    LIKE type_file.num20_6,
              SUM       LIKE type_file.num20_6
              END RECORD
DEFINE   g_rec_b        LIKE type_file.num10
DEFINE   g_row_count    LIKE type_file.num10
DEFINE   g_curs_index   LIKE type_file.num10
DEFINE   l_ac           LIKE type_file.num5 
#No.FUN-D70095  --Begin
DEFINE g_bal_a     DYNAMIC ARRAY OF RECORD
                   maj02      LIKE maj_file.maj02,
                   maj03      LIKE maj_file.maj03,
                   bal1       LIKE aah_file.aah05,                             
                   maj08      LIKE maj_file.maj08,
                   maj09      LIKE maj_file.maj09
                   END RECORD
#No.FUN-D70095  --End  
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                          #Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 
 
   LET g_bookno= ARG_VAL(1)
   LET g_pdate = ARG_VAL(2)                 
   LET g_towhom= ARG_VAL(3)
   LET g_rlang = ARG_VAL(4)
   LET g_bgjob = ARG_VAL(5)
   LET g_prtway= ARG_VAL(6)
   LET g_copies= ARG_VAL(7)
   LET tm.a    = ARG_VAL(8)
   LET tm.b    = ARG_VAL(9)   
   LET tm.abe01= ARG_VAL(10)
   LET tm.yy   = ARG_VAL(11)
   LET tm.bm   = ARG_VAL(12)
   LET tm.em   = ARG_VAL(13)
   LET tm.c    = ARG_VAL(14)
   LET tm.d    = ARG_VAL(15)
   LET tm.f    = ARG_VAL(16)
   LET tm.s    = ARG_VAL(17)   
   LET g_rep_user = ARG_VAL(18)
   LET g_rep_clas = ARG_VAL(19)
   LET g_template = ARG_VAL(20)
   LET tm.e    = ARG_VAL(21)    

   OPEN WINDOW q010_w AT 5,10
        WITH FORM "agl/42f/aglq010" ATTRIBUTE(STYLE = g_win_style)
 
   CALL cl_ui_init()


   DROP TABLE q010_file

   CALL cl_set_comp_visible("maj20e",FALSE)
   CALL cl_set_comp_visible("dept1,dept2,dept3,dept4,dept5,dept6,dept7,dept8,dept9,dept10",FALSE)
   CALL cl_set_comp_visible("dept11,dept12,dept13,dept14,dept15,dept16,dept17,dept18,dept19,dept20",FALSE)
   CALL cl_set_comp_visible("dept21,dept22,dept23,dept24,dept25,dept26,dept27,dept28,dept29,dept30",FALSE)
   CALL cl_set_comp_visible("dept31,dept32,dept33,dept34,dept35,dept36,dept37,dept38,dept39,dept40",FALSE)
   CALL cl_set_comp_visible("dept41,dept42,dept43,dept44,dept45,dept46,dept47,dept48,dept49,dept50",FALSE)
   
   CREATE TEMP TABLE q010_file_1(
       maj02     LIKE maj_file.maj02,
       maj03     LIKE maj_file.maj03,
       maj04     LIKE maj_file.maj04,
       maj05     LIKE maj_file.maj05,
       maj07     LIKE maj_file.maj07,
       maj20     LIKE maj_file.maj20,
       maj20e    LIKE maj_file.maj20e,
       page      LIKE type_file.num5,
       m_dept    LIKE gem_file.gem02,
       l_amt     LIKE type_file.num20_6, 
       line      LIKE type_file.num5)

   
   CREATE TEMP TABLE q010_file(
       no        LIKE type_file.num5,  
       maj02     LIKE maj_file.maj02,
       maj03     LIKE maj_file.maj03,
       maj04     LIKE maj_file.maj04,
       maj05     LIKE maj_file.maj05,
       maj07     LIKE maj_file.maj07,
       maj20     LIKE maj_file.maj20,
       maj20e    LIKE maj_file.maj20e,
       maj21     LIKE maj_file.maj21,
       maj22     LIKE maj_file.maj22,
       bal1      LIKE type_file.num20_6)  
      
   IF cl_null(g_bookno) THEN LET g_bookno = g_aaz.aaz64 END IF
   IF cl_null(tm.b) THEN LET tm.b = g_aza.aza81 END IF         

   CALL q010_tm()   
   CALL q010_menu()  
   DROP TABLE aglq010_tmp;
   CLOSE WINDOW q010_w  
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN


FUNCTION q010_menu()
   DEFINE   l_cmd   LIKE type_file.chr1000
 
   WHILE TRUE
      CALL q010_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q010_tm()
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL q010_out()
            END IF

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

FUNCTION q010_bp(p_ud)
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
 
FUNCTION q010_tm()
   DEFINE p_row,p_col    LIKE type_file.num5,          
          l_sw           LIKE type_file.chr1,          #重要欄位是否空白 
          l_cmd          LIKE type_file.chr1000          
   DEFINE li_chk_bookno LIKE type_file.num5            
   DEFINE li_result      LIKE type_file.num5            
   CALL s_dsmark(g_bookno)
 
    CALL cl_ui_init()
 
   CALL s_shwact(0,0,g_bookno)
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                  #Default condition
   IF cl_null(tm.b) THEN LET tm.b = g_aza.aza81 END IF        
   #使用預設帳別之幣別
   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = tm.b     
   IF SQLCA.sqlcode THEN 
      CALL cl_err3("sel","aaa_file",tm.b,"",SQLCA.sqlcode,"","sel aaa:",0)   
   END IF
   LET tm.yy= YEAR(g_today)
   LET tm.bm= MONTH(g_today)
   LET tm.em= MONTH(g_today)
   LET tm.a = ' '
   LET tm.b = g_aza.aza81    
   LET tm.c = 'Y'
   LET tm.d = '1'
   LET tm.e = 'N'  
   LET tm.p = '2'  
   LET tm.f = 0
   LET tm.s = 'N'   
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
    LET l_sw = 1
 
    INPUT BY NAME tm.b,tm.a,tm.abe01,tm.yy,tm.bm,tm.em,tm.f,tm.d,tm.c,tm.s,tm.e   
		  WITHOUT DEFAULTS
         BEFORE INPUT
             CALL cl_qbe_init()
       ON ACTION locale
          CALL cl_dynamic_locale()                  
          CALL cl_show_fld_cont()                   
         LET g_action_choice = "locale"
 
 
      AFTER FIELD a
         IF cl_null(tm.a) THEN NEXT FIELD a END IF
         CALL s_chkmai(tm.a,'RGL') RETURNING li_result
         IF NOT li_result THEN
           CALL cl_err(tm.a,g_errno,1)
           NEXT FIELD a
         END IF
         SELECT mai02,mai03 INTO g_mai02,g_mai03 FROM mai_file
          WHERE mai01 = tm.a AND maiacti IN ('Y','y')
            AND mai00 = tm.b  
         IF STATUS THEN
            CALL cl_err3("sel","mai_file",tm.b,"",STATUS,"","sel mai:",0)   
            NEXT FIELD a
         END IF
 
      AFTER FIELD b
         IF cl_null(tm.b) THEN 
             NEXT FIELD b END IF
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
 
      AFTER FIELD abe01
         IF cl_null(tm.abe01) THEN NEXT FIELD abe01 END IF
 
         SELECT UNIQUE abe01 INTO g_abe01 FROM abe_file WHERE abe01=tm.abe01
         IF STATUS=100 THEN
           LET g_abe01 =' '
           SELECT UNIQUE abd01 INTO g_abd01 FROM abd_file WHERE abd01=tm.abe01
           IF STATUS=100 THEN
             LET g_abd01=' '
             SELECT gem05 INTO g_gem05 FROM gem_file WHERE gem01=tm.abe01
             IF STATUS THEN NEXT FIELD abe01 END IF
           END IF
         ELSE
           IF cl_chkabf(tm.abe01) THEN NEXT FIELD abe01 END IF
         END IF
 
      AFTER FIELD c
         IF cl_null(tm.c) OR tm.c NOT MATCHES "[YN]" THEN NEXT FIELD c END IF
 
      AFTER FIELD s
         IF cl_null(tm.s) OR tm.s NOT MATCHES "[YN]" THEN NEXT FIELD c END IF
 
      AFTER FIELD yy
         IF cl_null(tm.yy) OR tm.yy = 0 THEN NEXT FIELD yy END IF
 
      AFTER FIELD bm
         IF NOT cl_null(tm.bm) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.yy
            IF g_azm.azm02 = 1 THEN
               IF tm.bm > 12 OR tm.bm < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD bm
               END IF
            ELSE
               IF tm.bm > 13 OR tm.bm < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD bm
               END IF
            END IF
         END IF
         IF cl_null(tm.bm) THEN NEXT FIELD bm END IF
 
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
         IF cl_null(tm.em) THEN NEXT FIELD em END IF
         IF tm.bm > tm.em THEN CALL cl_err('','9011',0) NEXT FIELD bm END IF
 
      AFTER FIELD d
         IF cl_null(tm.d) OR tm.d NOT MATCHES'[123]' THEN NEXT FIELD d END IF
 
      AFTER FIELD f
         IF cl_null(tm.f) OR tm.f < 0  THEN
            LET tm.f = 0 DISPLAY BY NAME tm.f NEXT FIELD f
         END IF
 
      AFTER INPUT
         IF INT_FLAG THEN EXIT INPUT END IF
         IF cl_null(tm.yy) THEN
            LET l_sw = 0
            DISPLAY BY NAME tm.yy
            CALL cl_err('',9033,0)
         END IF
         IF cl_null(tm.bm) THEN
            LET l_sw = 0
            DISPLAY BY NAME tm.bm
         END IF
         IF cl_null(tm.em) THEN
            LET l_sw = 0
            DISPLAY BY NAME tm.em
        END IF
        CASE
           WHEN tm.d = '1'  LET g_unit = 1
           WHEN tm.d = '2'  LET g_unit = 1000
           WHEN tm.d = '3'  LET g_unit = 1000000
        END CASE
        IF l_sw = 0 THEN
            LET l_sw = 1
            NEXT FIELD a
            CALL cl_err('',9033,0)
        END IF
 
      ON ACTION CONTROLZ
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()    # Command execution
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(a)
               CALL cl_init_qry_var()
               LET g_qryparam.form = 'q_mai'
               LET g_qryparam.default1 = tm.a
               LET g_qryparam.where = " mai00 = '",tm.b,"'"   
               CALL cl_create_qry() RETURNING tm.a
               DISPLAY BY NAME tm.a
               NEXT FIELD a
 
            WHEN INFIELD(b)
               CALL cl_init_qry_var()
               LET g_qryparam.form = 'q_aaa'
               LET g_qryparam.default1 = tm.b
               CALL cl_create_qry() RETURNING tm.b
               DISPLAY BY NAME tm.b
               NEXT FIELD b
 
            WHEN INFIELD(abe01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = 'q_abe'
               LET g_qryparam.default1 = tm.abe01
               CALL cl_create_qry() RETURNING tm.abe01
               DISPLAY BY NAME tm.abe01
               NEXT FIELD abe01
      END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         
         CALL cl_about()     
 
      ON ACTION help          
         CALL cl_show_help() 

      ON ACTION CANCEL 
         LET INT_FLAG = 1
         EXIT INPUT 
 
          ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
 
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
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
             WHERE zz01='aglq010'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aglq010','9031',1)  
      ELSE
         LET l_cmd = l_cmd CLIPPED,       
                         " '",g_bookno CLIPPED,"'" ,
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.a CLIPPED,"'",
                         " '",tm.b CLIPPED,"'",   
                         " '",tm.abe01 CLIPPED,"'",
                         " '",tm.yy CLIPPED,"'",
                         " '",tm.bm CLIPPED,"'",
                         " '",tm.em CLIPPED,"'",
                         " '",tm.c CLIPPED,"'",
                         " '",tm.d CLIPPED,"'",
                         " '",tm.e CLIPPED,"'",    
                         " '",tm.f CLIPPED,"'" ,
                         " '",tm.s CLIPPED,"'" ,   
                         " '",g_rep_user CLIPPED,"'",           
                         " '",g_rep_clas CLIPPED,"'",           
                         " '",g_template CLIPPED,"'"            
         CALL cl_cmdat('aglq010',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW q010_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL q010()
   ERROR ""
   EXIT WHILE       
END WHILE

   IF INT_FLAG THEN    
      LET INT_FLAG = 0
      RETURN         
   END IF 
   IF tm.e = 'Y' THEN 
      CALL cl_set_comp_visible("maj20e",TRUE)
   END IF
   CALL q010_b_fill()   
   CALL cl_show_fld_cont()   
END FUNCTION
 
FUNCTION q010()
   DEFINE l_name    LIKE type_file.chr20             
   DEFINE l_name1   LIKE type_file.chr20         
   DEFINE l_sql     STRING                        
   DEFINE l_chr     LIKE type_file.chr1          
   DEFINE l_leng,l_leng2  LIKE type_file.num5    
   DEFINE l_abe03   LIKE abe_file.abe03
   DEFINE l_abd02   LIKE abd_file.abd02
   DEFINE l_gem02   LIKE gem_file.gem02
   DEFINE l_dept    LIKE gem_file.gem01
   DEFINE l_maj20   LIKE maj_file.maj20          
   DEFINE l_bal     LIKE type_file.num20_6      

   DEFINE sr  RECORD
              no    LIKE type_file.num5,       #No.FUN-680098   SMALLINT
              maj02     LIKE maj_file.maj02,
              maj03     LIKE maj_file.maj03,
              maj04     LIKE maj_file.maj04,
              maj05     LIKE maj_file.maj05,
              maj07     LIKE maj_file.maj07,
              maj20     LIKE maj_file.maj20,
              maj20e    LIKE maj_file.maj20e,
              maj21     LIKE maj_file.maj21,
              maj22     LIKE maj_file.maj22,
              bal1      LIKE type_file.num20_6    #實際   
              END RECORD

    DEFINE sr1 RECORD
              maj02     LIKE maj_file.maj02,
              maj03     LIKE maj_file.maj03,
              maj04     LIKE maj_file.maj04,
              maj05     LIKE maj_file.maj05,
              maj07     LIKE maj_file.maj07,
              maj20     LIKE maj_file.maj20,
              maj20e    LIKE maj_file.maj20e
              END RECORD
   DEFINE l_str1,l_str2,l_str3,l_str4,l_str5     LIKE type_file.chr20     
   DEFINE l_str6,l_str7,l_str8,l_str9,l_str10    LIKE type_file.chr20     
   DEFINE m_abd02 LIKE abd_file.abd02
   DEFINE l_no,l_cn,l_cnt,l_i,l_j LIKE type_file.num5      
   DEFINE l_cmd,l_cmd1,l_cmd2  LIKE type_file.chr1000           
   DEFINE l_amtstr                DYNAMIC ARRAY OF LIKE type_file.chr20   
   DEFINE l_amt                   DYNAMIC ARRAY OF LIKE type_file.num20_6  
   DEFINE l_gem02_o     LIKE gem_file.gem02
   DEFINE l_zero1       LIKE type_file.chr1,            
          l_zero2       LIKE type_file.chr1               
 
   SELECT aaf03 INTO g_company FROM aaf_file WHERE aaf01=tm.b AND aaf02=g_rlang
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'aglq010'

   CALL q010_table()
   DELETE FROM q010_file_1    #TQC-D10110 add
   LET g_sql = "INSERT INTO aglq010_tmp",                                                                
               " VALUES(?, ?, ?, ?, ?,    ?, ?, ?, ?, ?, ",
               "        ?, ?, ?, ?, ?,    ?, ?, ?, ?, ?, ",
               "        ?, ?, ?, ?, ?,    ?, ?, ?, ?, ?, ",
               "        ?, ?, ?, ?, ?,    ?, ?, ?, ?, ?, ",
               "        ?, ?, ?, ?, ?,    ?, ?, ?, ?, ?, ",
               "        ?, ?, ? )"  
   PREPARE insert_prep FROM g_sql                                                                                                  
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time        
      EXIT PROGRAM                                                                                                                 
   END IF
 
   LET l_sql = "SELECT * FROM maj_file",
               " WHERE maj01 = '",tm.a,"'",   
               " ORDER BY maj02"
   PREPARE q010_p FROM l_sql
   IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM 
   END IF
   DECLARE q010_c CURSOR FOR q010_p
  
   SELECT COUNT(*) INTO maj02_max FROM maj_file    
     WHERE maj01 = tm.a  
   IF cl_null(maj02_max) THEN LET maj02_max = 0 END IF
   LET g_mm = tm.em
   LET l_i = 1
   FOR l_i = 1 TO maj02_max
       LET g_total[l_i].maj02 = NULL
       LET g_total[l_i].amt = 0
   END FOR
   LET g_i = 1 FOR g_i = 1 TO maj02_max LET g_tot1[g_i] = 0 END FOR
   LET g_no = 1 
   FOR g_no = 1 TO maj02_max 
      INITIALIZE g_dept[g_no].* TO NULL 
   END FOR
 
#將部門填入array------------------------------------
   LET g_buf = ''
   IF g_abe01 = ' ' THEN
     IF g_abd01 = ' ' THEN                   #--- 部門
       LET g_no = 1
       LET g_dept[g_no].gem01 = tm.abe01
       LET g_dept[g_no].gem05 = g_gem05
     ELSE                                    #--- 部門層級
       LET g_no=0
       DECLARE r192_bom1 CURSOR FOR
         SELECT abd02,gem05 FROM abd_file,gem_file
          WHERE abd01=tm.abe01 AND gem01=abd02
          ORDER BY 1
       FOREACH r192_bom1 INTO l_abd02,l_chr
         IF SQLCA.SQLCODE THEN EXIT FOREACH END IF
         LET g_no = g_no + 1
         LET g_dept[g_no].gem01 = l_abd02
         LET g_dept[g_no].gem05 = l_chr
       END FOREACH
     END IF
 
   ELSE                                      #--- 族群
      LET g_no = 0
      DECLARE r192_bom2 CURSOR FOR
        SELECT abe03,gem05 FROM abe_file,gem_file
         WHERE abe01=tm.abe01 AND gem01=abe03
         ORDER BY 1
      FOREACH r192_bom2 INTO l_abe03,l_chr
         IF SQLCA.SQLCODE THEN EXIT FOREACH END IF
         LET g_no = g_no + 1
         LET g_dept[g_no].gem01 = l_abe03
         LET g_dept[g_no].gem05 = l_chr
      END FOREACH
   END IF

   CALL q010_not_page()

END FUNCTION

FUNCTION q010_table()
   DROP TABLE aglq010_tmp;
   CREATE TEMP TABLE aglq010_tmp(
                  maj20   LIKE maj_file.maj20,
                  maj20e  LIKE maj_file.maj20e,
                  dept1   LIKE type_file.num20_6,
                  dept2   LIKE type_file.num20_6,
                  dept3   LIKE type_file.num20_6,
                  dept4   LIKE type_file.num20_6,
                  dept5   LIKE type_file.num20_6,
                  dept6   LIKE type_file.num20_6,
                  dept7   LIKE type_file.num20_6,
                  dept8   LIKE type_file.num20_6,
                  dept9   LIKE type_file.num20_6,
                  dept10  LIKE type_file.num20_6,
                  dept11  LIKE type_file.num20_6,
                  dept12  LIKE type_file.num20_6,
                  dept13  LIKE type_file.num20_6,
                  dept14  LIKE type_file.num20_6,
                  dept15  LIKE type_file.num20_6,
                  dept16  LIKE type_file.num20_6,
                  dept17  LIKE type_file.num20_6,
                  dept18  LIKE type_file.num20_6,
                  dept19  LIKE type_file.num20_6,
                  dept20  LIKE type_file.num20_6,
                  dept21  LIKE type_file.num20_6,
                  dept22  LIKE type_file.num20_6,
                  dept23  LIKE type_file.num20_6,
                  dept24  LIKE type_file.num20_6,
                  dept25  LIKE type_file.num20_6,
                  dept26  LIKE type_file.num20_6,
                  dept27  LIKE type_file.num20_6,
                  dept28  LIKE type_file.num20_6,
                  dept29  LIKE type_file.num20_6,
                  dept30  LIKE type_file.num20_6,
                  dept31  LIKE type_file.num20_6,
                  dept32  LIKE type_file.num20_6,
                  dept33  LIKE type_file.num20_6,
                  dept34  LIKE type_file.num20_6,
                  dept35  LIKE type_file.num20_6,
                  dept36  LIKE type_file.num20_6,
                  dept37  LIKE type_file.num20_6,
                  dept38  LIKE type_file.num20_6,
                  dept39  LIKE type_file.num20_6,
                  dept40  LIKE type_file.num20_6,
                  dept41  LIKE type_file.num20_6,
                  dept42  LIKE type_file.num20_6,
                  dept43  LIKE type_file.num20_6,
                  dept44  LIKE type_file.num20_6,
                  dept45  LIKE type_file.num20_6,
                  dept46  LIKE type_file.num20_6,
                  dept47  LIKE type_file.num20_6,
                  dept48  LIKE type_file.num20_6,
                  dept49  LIKE type_file.num20_6,
                  dept50  LIKE type_file.num20_6,
                  SUM     LIKE type_file.num20_6);                                
END FUNCTION 

FUNCTION q010_not_page()
   DEFINE l_name1   LIKE type_file.chr20
   DEFINE l_chr     LIKE type_file.chr1  
   DEFINE l_leng,l_leng2  LIKE type_file.num5
   DEFINE l_gem02   LIKE gem_file.gem02
   DEFINE l_dept    LIKE gem_file.gem01  
   DEFINE l_maj20   LIKE maj_file.maj20           
   DEFINE l_maj20e  LIKE maj_file.maj20e           
   DEFINE l_m_dept  LIKE gem_file.gem02            
   DEFINE l_l_amt   LIKE type_file.num20_6         
   DEFINE l_zl,l_sr2      STRING                  
   DEFINE sr  RECORD
              no    LIKE type_file.num5,
              maj02     LIKE maj_file.maj02,
              maj03     LIKE maj_file.maj03,
              maj04     LIKE maj_file.maj04,
              maj05     LIKE maj_file.maj05,
              maj07     LIKE maj_file.maj07,
              maj20     LIKE maj_file.maj20,
              maj20e    LIKE maj_file.maj20e,
              maj21     LIKE maj_file.maj21,
              maj22     LIKE maj_file.maj22,
              bal1      LIKE type_file.num20_6
              END RECORD
    DEFINE sr1 RECORD
              maj02     LIKE maj_file.maj02,
              maj03     LIKE maj_file.maj03,
              maj04     LIKE maj_file.maj04,
              maj05     LIKE maj_file.maj05,
              maj07     LIKE maj_file.maj07,
              maj20     LIKE maj_file.maj20,
              maj20e    LIKE maj_file.maj20e
              END RECORD
   DEFINE l_cn,l_cnt,l_i,l_j,l_deptcnt LIKE type_file.num5
   DEFINE l_amt         LIKE type_file.num20_6
   DEFINE m_dept        LIKE gem_file.gem02
   DEFINE l_gem02_o     LIKE gem_file.gem02
   DEFINE l_zero1       LIKE type_file.chr1,
          l_zero2       LIKE type_file.chr1
   LET l_cnt = g_no
   LET l_i = 0
   FOR l_i = 1 TO l_cnt
      LET g_flag = 'n'
      LET l_name1='q010_1.out'
      LET g_pageno = 0
      LET g_cn = 0
      DELETE FROM q010_file
      LET m_dept = ''
      LET g_i = 1
      FOR g_i = 1 TO maj02_max LET g_tot1[g_i] = 0 END FOR
      LET g_buf = ''
      LET l_dept = g_dept[l_i].gem01
      LET l_chr  = g_dept[l_i].gem05
      LET l_gem02 = ''
      SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=l_dept
      LET l_leng2 = LENGTH(l_gem02_o)
      LET l_leng2 = 16 - l_leng2
      LET m_dept = l_gem02
      IF tm.s = 'Y' THEN
         CALL q010_bom(l_dept,l_chr)
      END IF
      IF g_buf IS NULL THEN LET g_buf="'",l_dept CLIPPED,"'," END IF
      LET l_leng = g_buf.getlength()
      LET g_buf = g_buf.substring(1,l_leng-1) CLIPPED
      CALL q010_process(l_i)
      LET g_cn = l_i
      LET l_gem02_o = l_gem02
      
      CALL q010_total()
      DECLARE tmp_curs1 CURSOR FOR
         SELECT * FROM q010_file ORDER BY maj02,no
      IF STATUS THEN CALL cl_err('tmp_curs',STATUS,1) EXIT FOR END IF
      LET l_j = 1
      FOREACH tmp_curs1 INTO sr.*
         IF sr.no = 1 THEN                             
            LET l_amt= 0                                
         END IF                                         
         IF STATUS THEN CALL cl_err('tmp_curs1',STATUS,1) EXIT FOREACH END IF
         IF cl_null(sr.bal1) THEN LET sr.bal1 = 0 END IF
         IF tm.d MATCHES '[23]' THEN             #換算金額單位
            IF g_unit!=0 THEN
               LET sr.bal1 = sr.bal1 / g_unit    #實際
            ELSE
               LET sr.bal1 = 0
            END IF
         END IF
         IF sr.maj03 = '%' THEN
            LET l_amt = sr.bal1
         ELSE
            LET l_amt = sr.bal1
         END IF
         IF sr.no = g_cn THEN
            LET l_zero1 = 'N'
            LET l_zero2 = 'N'
            IF (tm.c='N' OR sr.maj03='2') AND
               sr.maj03 MATCHES "[0125]" AND
               (l_amt=0  OR cl_null(l_amt)) THEN
               LET l_zero1 = 'Y'
            END IF
            IF g_flag = 'y' THEN
               IF sr.maj03 = '%' THEN
                  LET l_amt = g_total[l_j].amt
               ELSE
                  LET l_amt = g_total[l_j].amt
               END IF
               IF (tm.c='N' OR sr.maj03='2') AND
                  sr.maj03 MATCHES "[0125]"  AND g_total[l_j].amt = 0 THEN
                  LET l_zero2 = 'Y'
               END IF
               LET l_j = l_j + 1
            END IF
            IF (tm.c='N' OR sr.maj03='2') AND
               sr.maj03 MATCHES "[0125]" AND
               (l_amt=0  OR cl_null(l_amt)) THEN
               LET l_zero1 = 'Y'
            END IF
            IF sr.maj03 = 'H' OR sr.maj03= '4' THEN
               LET l_amt = ''
            END IF
            IF l_zero1 = 'Y' AND (g_flag = 'n' OR
               (g_flag = 'y' AND l_zero2 = 'Y')) THEN
               DISPLAY "CONTINUE FOREACH==============="
               CONTINUE FOREACH
            END IF
            LET sr.maj20 = sr.maj05 SPACES,sr.maj20
            LET sr.maj20e= sr.maj05 SPACES,sr.maj20e
            IF sr.maj04 = 0 THEN  
               INSERT INTO q010_file_1 VALUES(sr.maj02,sr.maj03,sr.maj04,sr.maj05,
                                            sr.maj07,sr.maj20,sr.maj20e,l_i,
                                            m_dept,l_amt,'2')
               IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
                  CALL cl_err3("ins","q010_file_1",sr.maj02,sr.maj03,SQLCA.sqlcode,"","ins q010_file_1",1)   
                  EXIT FOREACH
               END IF
            ELSE
               INSERT INTO q010_file_1 VALUES(sr.maj02,sr.maj03,sr.maj04,sr.maj05,
                                            sr.maj07,sr.maj20,sr.maj20e,l_i,
                                            m_dept,'','2')
               IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
                  CALL cl_err3("ins","q010_file_1",sr.maj02,sr.maj03,SQLCA.sqlcode,"","ins q010_file_1",1)   
                  EXIT FOREACH
               END IF
               #FUN-C80102--add--end--
               #空行的部份,以寫入同樣的maj20資料列進Temptable,
               #但line=1來區別(line=2表示是非空行的資料),再用排序的方式,
               #讓空行的這筆資料排在正常的資料前面印出
               FOR j = 1 TO sr.maj04
                  INSERT INTO q010_file_1 VALUES(sr.maj02,sr.maj03,sr.maj04,sr.maj05,
                                                 sr.maj07,sr.maj20,sr.maj20e,l_i,
                                                 m_dept,'','1')
                  IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
                     CALL cl_err3("ins","q010_file_1",sr.maj02,sr.maj03,SQLCA.sqlcode,"","ins q010_file_1",1)   
                     EXIT FOREACH
                  END IF
               END FOR
            END IF
         END IF
      END FOREACH
      CLOSE tmp_curs1
   END FOR
   
   LET l_sql = "SELECT distinct(maj20),maj20e,maj02 FROM q010_file_1 order by maj02"
   PREPARE q010_prepare FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('q010_prepare:',SQLCA.sqlcode,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
   END IF
   DECLARE q010_curs CURSOR FOR q010_prepare
   FOREACH q010_curs INTO l_maj20,l_maj20e
      LET l_sql = "SELECT m_dept,l_amt FROM q010_file_1 ",
                  " WHERE maj20 = '",l_maj20,"'"
      PREPARE q010_prepare1 FROM l_sql
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('q010_prepare1:',SQLCA.sqlcode,1) 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      DECLARE q010_curs1 CURSOR FOR q010_prepare1
      LET j = 1
      CALL q010_init_sr2()
      FOREACH q010_curs1 INTO l_m_dept,l_l_amt
         LET sr2.maj20 = l_maj20
         LET sr2.maj20e = l_maj20e
         LET l_zl = "dept",j USING "<<<<<<"
         CALL cl_set_comp_visible(l_zl,TRUE)
         CALL cl_set_comp_att_text(l_zl,l_m_dept CLIPPED)
         IF cl_null(l_l_amt) THEN 
            LET  l_l_amt = 0
         END IF  
         CASE WHEN j = 1 LET sr2.dept1 = l_l_amt
              WHEN j = 2 LET sr2.dept2 = l_l_amt
              WHEN j = 3 LET sr2.dept3 = l_l_amt
              WHEN j = 4 LET sr2.dept4 = l_l_amt
              WHEN j = 5 LET sr2.dept5 = l_l_amt
              WHEN j = 6 LET sr2.dept6 = l_l_amt
              WHEN j = 7 LET sr2.dept7 = l_l_amt
              WHEN j = 8 LET sr2.dept8 = l_l_amt
              WHEN j = 9 LET sr2.dept9 = l_l_amt
              WHEN j = 10 LET sr2.dept10 = l_l_amt
              WHEN j = 11 LET sr2.dept11 = l_l_amt
              WHEN j = 12 LET sr2.dept12 = l_l_amt
              WHEN j = 13 LET sr2.dept13 = l_l_amt
              WHEN j = 14 LET sr2.dept14 = l_l_amt
              WHEN j = 15 LET sr2.dept15 = l_l_amt
              WHEN j = 16 LET sr2.dept16 = l_l_amt
              WHEN j = 17 LET sr2.dept17 = l_l_amt
              WHEN j = 18 LET sr2.dept18 = l_l_amt
              WHEN j = 19 LET sr2.dept19 = l_l_amt
              WHEN j = 20 LET sr2.dept20 = l_l_amt
              WHEN j = 21 LET sr2.dept21 = l_l_amt
              WHEN j = 22 LET sr2.dept22 = l_l_amt
              WHEN j = 23 LET sr2.dept23 = l_l_amt
              WHEN j = 24 LET sr2.dept24 = l_l_amt
              WHEN j = 25 LET sr2.dept25 = l_l_amt
              WHEN j = 26 LET sr2.dept26 = l_l_amt
              WHEN j = 27 LET sr2.dept27 = l_l_amt
              WHEN j = 28 LET sr2.dept28 = l_l_amt
              WHEN j = 29 LET sr2.dept29 = l_l_amt
              WHEN j = 30 LET sr2.dept30 = l_l_amt
              WHEN j = 31 LET sr2.dept31 = l_l_amt
              WHEN j = 32 LET sr2.dept32 = l_l_amt
              WHEN j = 33 LET sr2.dept33 = l_l_amt
              WHEN j = 34 LET sr2.dept34 = l_l_amt
              WHEN j = 35 LET sr2.dept35 = l_l_amt
              WHEN j = 36 LET sr2.dept36 = l_l_amt
              WHEN j = 37 LET sr2.dept37 = l_l_amt
              WHEN j = 38 LET sr2.dept38 = l_l_amt
              WHEN j = 39 LET sr2.dept39 = l_l_amt
              WHEN j = 40 LET sr2.dept40 = l_l_amt
              WHEN j = 41 LET sr2.dept41 = l_l_amt
              WHEN j = 42 LET sr2.dept42 = l_l_amt
              WHEN j = 43 LET sr2.dept43 = l_l_amt
              WHEN j = 44 LET sr2.dept44 = l_l_amt
              WHEN j = 45 LET sr2.dept45 = l_l_amt
              WHEN j = 46 LET sr2.dept46 = l_l_amt
              WHEN j = 47 LET sr2.dept47 = l_l_amt
              WHEN j = 48 LET sr2.dept48 = l_l_amt
              WHEN j = 49 LET sr2.dept49 = l_l_amt
              WHEN j = 50 LET sr2.dept50 = l_l_amt
         OTHERWISE
         END CASE
         LET j = j + 1
      END FOREACH 
      EXECUTE insert_prep USING sr2.* 
   END FOREACH 
END FUNCTION

FUNCTION q010_init_sr2()
   LET sr2.dept1  = 0
   LET sr2.dept2  = 0
   LET sr2.dept3  = 0
   LET sr2.dept4  = 0
   LET sr2.dept5  = 0
   LET sr2.dept6  = 0
   LET sr2.dept7  = 0
   LET sr2.dept8  = 0
   LET sr2.dept9  = 0
   LET sr2.dept10 = 0
   LET sr2.dept11 = 0
   LET sr2.dept12 = 0
   LET sr2.dept13 = 0
   LET sr2.dept14 = 0
   LET sr2.dept15 = 0
   LET sr2.dept16 = 0
   LET sr2.dept17 = 0
   LET sr2.dept18 = 0
   LET sr2.dept19 = 0
   LET sr2.dept20 = 0
   LET sr2.dept21 = 0
   LET sr2.dept22 = 0
   LET sr2.dept23 = 0
   LET sr2.dept24 = 0
   LET sr2.dept25 = 0
   LET sr2.dept26 = 0
   LET sr2.dept27 = 0
   LET sr2.dept28 = 0
   LET sr2.dept29 = 0
   LET sr2.dept30 = 0
   LET sr2.dept31 = 0
   LET sr2.dept32 = 0
   LET sr2.dept33 = 0
   LET sr2.dept34 = 0
   LET sr2.dept35 = 0
   LET sr2.dept36 = 0
   LET sr2.dept37 = 0
   LET sr2.dept38 = 0
   LET sr2.dept39 = 0
   LET sr2.dept40 = 0
   LET sr2.dept41 = 0
   LET sr2.dept42 = 0
   LET sr2.dept43 = 0
   LET sr2.dept44 = 0
   LET sr2.dept45 = 0
   LET sr2.dept46 = 0
   LET sr2.dept47 = 0
   LET sr2.dept48 = 0
   LET sr2.dept49 = 0
   LET sr2.dept50 = 0
END FUNCTION 

FUNCTION q010_b_fill()
DEFINE   l_totle    LIKE alz_file.alz09

   LET g_sql = "SELECT * FROM aglq010_tmp "
   PREPARE aglq010_pb FROM g_sql
   DECLARE maj_curs  CURSOR FOR aglq010_pb
   CALL g_maj.clear()
   LET l_totle = 0
   LET g_cnt = 1
   LET g_rec_b = 0

   FOREACH maj_curs INTO g_maj[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF 
      LET g_maj[g_cnt].sum = 0
      LET g_maj[g_cnt].sum = g_maj[g_cnt].dept1+g_maj[g_cnt].dept2+g_maj[g_cnt].dept3+g_maj[g_cnt].dept4+g_maj[g_cnt].dept5
                            +g_maj[g_cnt].dept6+g_maj[g_cnt].dept7+g_maj[g_cnt].dept8+g_maj[g_cnt].dept9+g_maj[g_cnt].dept10
                            +g_maj[g_cnt].dept11+g_maj[g_cnt].dept12+g_maj[g_cnt].dept13+g_maj[g_cnt].dept14+g_maj[g_cnt].dept15
                            +g_maj[g_cnt].dept16+g_maj[g_cnt].dept17+g_maj[g_cnt].dept18+g_maj[g_cnt].dept19+g_maj[g_cnt].dept20
                            +g_maj[g_cnt].dept21+g_maj[g_cnt].dept22+g_maj[g_cnt].dept23+g_maj[g_cnt].dept24+g_maj[g_cnt].dept25
                            +g_maj[g_cnt].dept26+g_maj[g_cnt].dept27+g_maj[g_cnt].dept28+g_maj[g_cnt].dept29+g_maj[g_cnt].dept30
                            +g_maj[g_cnt].dept31+g_maj[g_cnt].dept32+g_maj[g_cnt].dept33+g_maj[g_cnt].dept34+g_maj[g_cnt].dept35
                            +g_maj[g_cnt].dept36+g_maj[g_cnt].dept37+g_maj[g_cnt].dept38+g_maj[g_cnt].dept39+g_maj[g_cnt].dept40
                            +g_maj[g_cnt].dept41+g_maj[g_cnt].dept42+g_maj[g_cnt].dept43+g_maj[g_cnt].dept44+g_maj[g_cnt].dept45
                            +g_maj[g_cnt].dept46+g_maj[g_cnt].dept47+g_maj[g_cnt].dept48+g_maj[g_cnt].dept49+g_maj[g_cnt].dept50
      LET l_totle = l_totle + g_maj[g_cnt].sum 
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	     EXIT FOREACH
      END IF
   END FOREACH 
   LET g_rec_b = g_cnt
   DISPLAY g_rec_b TO FORMONLY.cnt
END FUNCTION 

FUNCTION q010_process(l_cn)
   DEFINE l_sql,l_sql1   STRING                   
   DEFINE l_cn           LIKE type_file.num5      
   DEFINE l_temp         LIKE maj_file.maj21        
   DEFINE l_sun          LIKE type_file.num20_6    
   DEFINE l_mon          LIKE type_file.num20_6     
   DEFINE l_amt1,amt1,amt2,amt   LIKE type_file.num20_6  
   DEFINE maj             RECORD LIKE maj_file.*
   DEFINE m_bal1,m_bal2   LIKE type_file.num20_6      
   DEFINE l_amt           LIKE type_file.num20_6     
   DEFINE m_per1,m_per2   LIKE con_file.con06        
   DEFINE l_mm            LIKE type_file.num5         
   DEFINE l_CE_sum1       LIKE abb_file.abb07             #TQC-CC0122 add
   DEFINE l_CE_sum2       LIKE abb_file.abb07             #TQC-CC0122 add
   #No.FUN-D70095--start  
   DEFINE l_sw1        LIKE type_file.num5        
   DEFINE l_i          LIKE type_file.num5
   DEFINE g_cnt        LIKE type_file.num5            
   DEFINE l_maj08      LIKE maj_file.maj08  
   DEFINE l_CE         LIKE abb_file.abb07  
   #No.FUN-D70095--end
#FUN-D70095--mark--begin------------------
#    #----------- sql for sum(aao05-aao06)-----------------------------------
#    LET l_sql = "SELECT SUM(aao05-aao06) FROM aao_file,aag_file",
#                " WHERE aao00= ? AND aao01 BETWEEN ? AND ? ",
#                "   AND aao03 = ? ",
#                "   AND aao04 BETWEEN ? AND ? ",
#                "   AND aao01 = aag01 AND aag07 IN ('2','3')",
#                "   AND aao00 = aag00  ",                                 
#                "   AND aao02 IN (",g_buf CLIPPED,")"       #---- g_buf 部門族群
#    PREPARE q010_sum FROM l_sql
#    DECLARE q010_sumc CURSOR FOR q010_sum
#    IF STATUS THEN CALL cl_err('sum prepare',STATUS,1) 
#       CALL cl_used(g_prog,g_time,2) RETURNING g_time 
#       EXIT PROGRAM 
#    END IF
#FUN-D70095--mark--end------------------
    LET g_cnt = 1     #FUN-D70095    
    FOREACH q010_c INTO maj.*
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF       
       LET amt1 = 0 LET amt  = 0
       LET l_CE = 0   #FUN-D70095
#FUN-D70095--mark--begin------------------
#       IF NOT cl_null(maj.maj21) THEN
#          OPEN q010_sumc USING tm.b,maj.maj21,maj.maj22,tm.yy,tm.bm,g_mm
#          FETCH q010_sumc INTO amt1
#          IF cl_null(amt1) THEN LET amt1 = 0 END IF
#
#          #TQC-CC0122--add--str--
#          LET l_sql = "SELECT SUM(abb07) FROM abb_file,aba_file ",
#                      " WHERE abb00 = '",tm.b,"'",
#                      "   AND aba00 = abb00 AND aba01 = abb01",
#                      "   AND abb03 BETWEEN '",maj.maj21,"' AND '", maj.maj22,"'",
#                      "   AND abb05 IN (",g_buf CLIPPED,")",
#                      "   AND aba06 = 'CE'  AND abb06 = '2' AND aba03 = '",tm.yy,"'",
#                      "   AND aba04 BETWEEN '",tm.bm,"' AND '", tm.em,"'  AND abapost = 'Y'"
#          PREPARE q010_ce1 FROM l_sql
#          EXECUTE q010_ce1 INTO l_CE_sum1
#
#          LET l_sql = "SELECT SUM(abb07) FROM abb_file,aba_file ",
#                      " WHERE abb00 = '",tm.b,"'",
#                      "   AND aba00 = abb00 AND aba01 = abb01",
#                      "   AND abb03 BETWEEN '",maj.maj21,"' AND '", maj.maj22,"'",
#                      "   AND abb05 IN (",g_buf CLIPPED,")",
#                      "   AND aba06 = 'CE'  AND abb06 = '1' AND aba03 = '",tm.yy,"'",
#                      "   AND aba04 BETWEEN '",tm.bm,"' AND '", tm.em,"'  AND abapost = 'Y'"
#          PREPARE q010_ce2 FROM l_sql
#          EXECUTE q010_ce2 INTO l_CE_sum2
#          IF cl_null(l_CE_sum1) THEN LET l_CE_sum1 = 0 END IF
#          IF cl_null(l_CE_sum2) THEN LET l_CE_sum2 = 0 END IF
#          LET amt1 = amt1 + l_CE_sum1 - l_CE_sum2
#          #TQC-CC0122--add--end--
#FUN-D70095--mark--end------------------
       #---------------FUN-D70095----------(S)
       IF NOT cl_null(maj.maj21) THEN
           CALL s_aao_amt(tm.b,maj.maj21,maj.maj22,g_buf,tm.yy,tm.bm,tm.em,maj.maj06,g_plant)
                RETURNING amt1
           CALL s_ce_abb07(tm.b,maj.maj21,maj.maj22,g_buf,tm.yy,tm.bm,tm.em,maj.maj06,g_plant)
                RETURNING l_CE
           LET amt1 = amt1 - l_CE
                  
           IF maj.maj06 MATCHES '[123468]' AND maj.maj07 = '2' THEN
              LET amt1 = amt1 * -1                  
           END IF          
           IF maj.maj06 MATCHES '[579]' AND maj.maj07 = '1' THEN
              LET amt1 = amt1 * -1                  
           END IF
        END IF
       #---------------FUN-D70095----------(E)
       IF maj.maj03 MATCHES "[012]" AND maj.maj08 > 0 THEN   #合計階數處理
          #---------------FUN-D70095----------(S)
               IF maj.maj08 = '1' THEN
                  LET g_bal_a[g_cnt].maj02 = maj.maj02
                  LET g_bal_a[g_cnt].maj03 = maj.maj03
                  LET g_bal_a[g_cnt].bal1  = amt1                
                  LET g_bal_a[g_cnt].maj08 = maj.maj08
                  LET g_bal_a[g_cnt].maj09 = maj.maj09
               ELSE
                  LET g_bal_a[g_cnt].maj02 = maj.maj02
                  LET g_bal_a[g_cnt].maj03 = maj.maj03
                  LET g_bal_a[g_cnt].maj08 = maj.maj08
                  LET g_bal_a[g_cnt].maj09 = maj.maj09                  
                  LET g_bal_a[g_cnt].bal1  = amt1                  
                  
                  FOR l_i = g_cnt - 1 TO 1 STEP -1       
                      IF maj.maj08 <= g_bal_a[l_i].maj08 THEN
                         EXIT FOR
                      END IF
                      IF g_bal_a[l_i].maj03 NOT MATCHES "[012]" THEN
                         CONTINUE FOR
                      END IF                    
                      IF l_i = g_cnt - 1 THEN       
                         LET l_maj08 = g_bal_a[l_i].maj08
                      END IF
                      IF g_bal_a[l_i].maj09 = '+' THEN
                         LET l_sw1 = 1
                      ELSE
                         LET l_sw1 = -1
                      END IF
                      IF g_bal_a[l_i].maj08 >= l_maj08 THEN   
                         LET g_bal_a[g_cnt].bal1 = g_bal_a[g_cnt].bal1 + 
                             g_bal_a[l_i].bal1 * l_sw1                        
                      END IF
                      IF g_bal_a[l_i].maj08 > l_maj08 THEN
                         LET l_maj08 = g_bal_a[l_i].maj08
                      END IF
                  END FOR
               END IF
          ELSE
          	 IF maj.maj03 = '%' THEN
	              LET l_temp = maj.maj21
	              SELECT bal1 INTO l_sun FROM q010_file WHERE no=l_cn
	                     AND maj02=l_temp
	              LET l_temp = maj.maj22
	              SELECT bal1 INTO l_mon FROM q010_file WHERE no=l_cn
	                     AND maj02=l_temp
	              IF cl_null(l_sun) OR cl_null(l_mon) OR l_mon = 0 THEN
	              ELSE
                   LET m_bal1 = l_sun / l_mon * 100
                END IF
            ELSE
             IF maj.maj03='5' THEN
                 LET g_bal_a[g_cnt].maj02 = maj.maj02
                 LET g_bal_a[g_cnt].maj03 = maj.maj03
                 LET g_bal_a[g_cnt].bal1  = amt1              
                 LET g_bal_a[g_cnt].maj08 = maj.maj08
                 LET g_bal_a[g_cnt].maj09 = maj.maj09
             ELSE
                 LET g_bal_a[g_cnt].maj02 = maj.maj02
                 LET g_bal_a[g_cnt].maj03 = maj.maj03
                 LET g_bal_a[g_cnt].bal1  = 0              
                 LET g_bal_a[g_cnt].maj08 = maj.maj08
                 LET g_bal_a[g_cnt].maj09 = maj.maj09
             END IF
          END IF 
       END IF
       LET m_bal1 = g_bal_a[g_cnt].bal1       
       LET g_cnt = g_cnt + 1
       #---------------FUN-D70095----------(E)
       #---------------FUN-D70095---mark-------(S)
#          FOR i = 1 TO maj02_max
#              LET l_amt1 = amt1
#              IF maj.maj09 = '-' THEN  
#                 LET g_tot1[i]=g_tot1[i]-l_amt1     #科目餘額
#              ELSE
#                 LET g_tot1[i]=g_tot1[i]+l_amt1     #科目餘額
#              END IF
#          END FOR
#          LET k=maj.maj08
#          LET m_bal1=g_tot1[k]
#          IF maj.maj07='2' THEN
#             LET m_bal1 = m_bal1*-1
#          END IF
#          FOR i = 1 TO k LET g_tot1[i]=0 END FOR
#       ELSE
#	        IF maj.maj03 = '%' THEN
#	           LET l_temp = maj.maj21
#	           SELECT bal1 INTO l_sun FROM q010_file WHERE no=l_cn
#	                  AND maj02=l_temp
#	           LET l_temp = maj.maj22
#	           SELECT bal1 INTO l_mon FROM q010_file WHERE no=l_cn
#	                  AND maj02=l_temp
#	           IF cl_null(l_sun) OR cl_null(l_mon) OR l_mon = 0 THEN
#	           ELSE
#                LET m_bal1 = l_sun / l_mon * 100
#             END IF
#          ELSE
#             IF maj.maj03 = '5' THEN
#                LET m_bal1 = amt1
#             ELSE
#                LET m_bal1 = NULL
#             END IF
#          END IF
#       END IF
       #---------------FUN-D70095---mark-------(E)
       IF maj.maj03='0' THEN CONTINUE FOREACH END IF #本行不印出
 
       IF maj.maj03 !='%' THEN
         IF maj.maj07='2' THEN
            IF NOT cl_null(maj.maj21) THEN
               IF m_bal1 > 0 AND amt1 < 0 THEN
                  LET m_bal1=m_bal1
               END IF
            END IF
         END IF
       END IF
       IF tm.f > 0 AND maj.maj08 < tm.f THEN
          CONTINUE FOREACH                              #最小階數起列印
       END IF
       INSERT INTO q010_file VALUES(l_cn,maj.maj02,maj.maj03,maj.maj04,
                                    maj.maj05,maj.maj07,maj.maj20,maj.maj20e,
                                    maj.maj21,maj.maj22,m_bal1)
       IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
          CALL cl_err3("ins","q010_file",l_cn,maj.maj02,SQLCA.sqlcode,"","ins q010_file",1)   #No.FUN-660123
          EXIT FOREACH
       END IF
    END FOREACH
END FUNCTION
 
FUNCTION q010_bom(l_dept,l_sw)
    DEFINE l_dept   LIKE abd_file.abd01      
    DEFINE l_sw     LIKE type_file.chr1        
    DEFINE l_abd02  LIKE abd_file.abd02           
    DEFINE l_cnt1,l_cnt2 LIKE type_file.num5          
    DEFINE l_arr DYNAMIC ARRAY OF RECORD
             gem01 LIKE gem_file.gem01,
             gem05 LIKE gem_file.gem05
           END RECORD
 
    LET l_cnt1 = 1
    DECLARE a_curs CURSOR FOR
     SELECT abd02,gem05 FROM abd_file,gem_file
      WHERE abd01 = l_dept
        AND abd02 = gem01
    FOREACH a_curs INTO l_arr[l_cnt1].*
       LET l_cnt1 = l_cnt1 + 1
    END FOREACH
 
    FOR l_cnt2 = 1 TO l_cnt1 - 1
        IF l_arr[l_cnt2].gem01 IS NOT NULL THEN
           CALL q010_bom(l_arr[l_cnt2].*)
        END IF
    END FOR
    IF l_sw = 'Y' THEN
       LET g_buf=g_buf CLIPPED,"'",l_dept CLIPPED,"',"
    END IF
END FUNCTION
 
FUNCTION q010_total()
    DEFINE  l_i,l_y  LIKE type_file.num5,        
	    l_maj02  LIKE maj_file.maj02,
	    l_maj03  LIKE maj_file.maj03,
	    l_maj21  LIKE maj_file.maj21,
	    l_maj22  LIKE maj_file.maj22,
	    l_t1,l_t2  LIKE type_file.num5,      
	    l_bal      LIKE type_file.num20_6      
 
    DECLARE tot_curs CURSOR FOR
      SELECT maj02,maj03,maj21,maj22,SUM(bal1)
        FROM q010_file
       GROUP BY maj02,maj03,maj21,maj22 ORDER BY maj02
    IF STATUS THEN CALL cl_err('tot_curs',STATUS,1) END IF
    LET l_i = 1
    LET l_maj02 = ' '
    LET l_bal = 0
    FOREACH tot_curs INTO l_maj02,l_maj03,l_maj21,l_maj22,l_bal
       IF STATUS THEN CALL cl_err('tot_curs',STATUS,1) EXIT FOREACH END IF
       IF cl_null(l_bal) THEN LET l_bal = 0 END IF
       IF tm.d MATCHES '[23]' THEN             #換算金額單位
          IF g_unit!=0 THEN
             LET l_bal = l_bal / g_unit    #實際
          ELSE
             LET l_bal = 0
          END IF
       END IF
       IF l_maj03 = '%' THEN
          LET l_t1 = l_maj21
          LET l_t2 = l_maj22
          FOR l_y = 1 TO maj02_max
              IF g_total[l_y].maj02 = l_t1 THEN LET l_t1 = l_y END IF
              IF g_total[l_y].maj02 = l_t2 THEN LET l_t2 = l_y END IF
          END FOR
          IF g_total[l_t2].amt != 0 THEN
             LET g_total[l_i].amt = g_total[l_t1].amt / g_total[l_t2].amt * 100
          ELSE
             LET g_total[l_i].amt = 0
          END IF
       ELSE
          LET g_total[l_i].amt = g_total[l_i].amt + l_bal
       END IF
       LET g_total[l_i].maj02 = l_maj02
       LET l_i = l_i + 1
       IF l_i > maj02_max THEN   
          EXIT FOREACH
       END IF
    END FOREACH
END FUNCTION

FUNCTION q010_out()
   DEFINE l_cmd        LIKE type_file.chr1000, 
          l_wc         LIKE type_file.chr1000 

   CALL cl_wait()
   IF tm.wc IS NULL THEN CALL cl_err('','9057',0) END IF
   LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
   LET l_cmd = "aglr100",
               " '",g_bookno CLIPPED,"' ", 
               " '",g_today CLIPPED,"' ''", 
               " '",g_lang CLIPPED,"' 'Y' '' '1'", 
               " '",tm.a CLIPPED,"' ", 
               " '",tm.b CLIPPED,"' ", 
               " '",tm.abe01 CLIPPED,"' ", 
               " '",tm.yy CLIPPED,"' ",
               " '",tm.bm CLIPPED,"' ",
               " '",tm.em CLIPPED,"' ",
               " '",tm.c CLIPPED,"' ",
               " '",tm.d CLIPPED,"' ",
               " '",tm.f CLIPPED,"' ",
               " '",tm.s CLIPPED,"' '' '' ''",
               " '",tm.e CLIPPED,"' '1'"    
   CALL cl_cmdrun(l_cmd)
   ERROR ' '
END FUNCTION
