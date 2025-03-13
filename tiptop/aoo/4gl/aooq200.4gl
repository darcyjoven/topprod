# Prog. Version..: '5.30.06-13.03.26(00005)'     #
#
# Pattern name...: aooq200
# Descriptions...: 庫存進出查詢作業
# Date & Author..: 12/12/18 By xujing #No.FUN-CB0087
# Modify.........: No.TQC-D10103 13/02/04 By xujing 調整資料抓取錯誤的問題 
# Modify.........: No.TQC-D20038 13/02/21 By xujing 調整數量抓取錯誤的問題
# Modify.........: No.TQC-D30039 13/03/14 By xujing 處理aooq200單身動態顯示新規格
# Modify.........: No.TQC-D30056 13/03/21 By xujing 處理aooq200單身抓去欄位類型說明順序錯誤

DATABASE ds

GLOBALS "../../config/top.global"

#模組變數(Module Variables)
 DEFINE 
    tm  RECORD
           wc      STRING ,    
           bdate,edate LIKE type_file.dat,    
           price   LIKE type_file.chr1,
           viewall LIKE type_file.chr1,   
           yy,mm   LIKE type_file.num5,  
           azp01   LIKE azp_file.azp01,    
           c       LIKE type_file.chr1,
           gge01   LIKE gge_file.gge01,
           gge02   LIKE gge_file.gge02
           END RECORD,
       i,g_yy,g_mm      LIKE type_file.num5,   
       last_y,last_m	LIKE type_file.num5,   
       m_bdate	        LIKE type_file.dat     
  DEFINE  l_bdate,l_edate LIKE type_file.dat 
       
    DEFINE g_img,g_img_excel DYNAMIC ARRAY OF RECORD
                azp02   LIKE azp_file.azp02, 
                img02   LIKE img_file.img02,
                imd02   LIKE imd_file.imd02,
                img03   LIKE img_file.img03,
                ime03   LIKE ime_file.ime03,
                img04   LIKE img_file.img04,
                img19   LIKE img_file.img19,  
                ima12   LIKE ima_file.ima12,
                ima01   LIKE ima_file.ima01,
                ima02   LIKE ima_file.ima02,
                ima021  LIKE ima_file.ima021,
                img09   LIKE img_file.img09,  
                p0      LIKE ccc_file.ccc23, #計畫單價
                q0      LIKE img_file.img10, #期初數量
                s0      LIKE ccc_file.ccc23, #期初金額
                tq1     LIKE img_file.img10, #異動類別1數量
                ts1     LIKE ccc_file.ccc23, #异动类别1金額
                tq2     LIKE img_file.img10, 
                ts2     LIKE ccc_file.ccc23, 
                tq3     LIKE img_file.img10, 
                ts3     LIKE ccc_file.ccc23,
                tq4     LIKE img_file.img10, 
                ts4     LIKE ccc_file.ccc23,
                tq5     LIKE img_file.img10, 
                ts5     LIKE ccc_file.ccc23,
                tq6     LIKE img_file.img10, 
                ts6     LIKE ccc_file.ccc23,
                tq7     LIKE img_file.img10, 
                ts7     LIKE ccc_file.ccc23,
                tq8     LIKE img_file.img10, 
                ts8     LIKE ccc_file.ccc23,
                tq9     LIKE img_file.img10, 
                ts9     LIKE ccc_file.ccc23,
                tq10    LIKE img_file.img10, 
                ts10    LIKE ccc_file.ccc23,
                tq11    LIKE img_file.img10, 
                ts11    LIKE ccc_file.ccc23,
                tq12    LIKE img_file.img10, 
                ts12    LIKE ccc_file.ccc23, 
                tq13    LIKE img_file.img10, 
                ts13    LIKE ccc_file.ccc23,
                tq14    LIKE img_file.img10, 
                ts14    LIKE ccc_file.ccc23,
                tq15    LIKE img_file.img10, 
                ts15    LIKE ccc_file.ccc23,
                tq16    LIKE img_file.img10, 
                ts16    LIKE ccc_file.ccc23,
                tq17    LIKE img_file.img10, 
                ts17    LIKE ccc_file.ccc23,
                tq18    LIKE img_file.img10, 
                ts18    LIKE ccc_file.ccc23,
                tq19    LIKE img_file.img10, 
                ts19    LIKE ccc_file.ccc23,
                tq20    LIKE img_file.img10, 
                ts20    LIKE ccc_file.ccc23,
                tq21    LIKE img_file.img10, 
                ts21    LIKE ccc_file.ccc23,
                tq22    LIKE img_file.img10, 
                ts22    LIKE ccc_file.ccc23, 
                tq23    LIKE img_file.img10, 
                ts23    LIKE ccc_file.ccc23,
                tq24    LIKE img_file.img10, 
                ts24    LIKE ccc_file.ccc23,
                tq25    LIKE img_file.img10, 
                ts25    LIKE ccc_file.ccc23,
                tq26    LIKE img_file.img10, 
                ts26    LIKE ccc_file.ccc23,
                tq27    LIKE img_file.img10, 
                ts27    LIKE ccc_file.ccc23,
                tq28    LIKE img_file.img10, 
                ts28    LIKE ccc_file.ccc23,
                tq29    LIKE img_file.img10, 
                ts29    LIKE ccc_file.ccc23,
                tq30    LIKE img_file.img10, 
                ts30    LIKE ccc_file.ccc23,
                tq31    LIKE img_file.img10, 
                ts31    LIKE ccc_file.ccc23,
                tq32    LIKE img_file.img10, 
                ts32    LIKE ccc_file.ccc23, 
                tq33    LIKE img_file.img10, 
                ts33    LIKE ccc_file.ccc23,
                tq34    LIKE img_file.img10, 
                ts34    LIKE ccc_file.ccc23,
                tq35    LIKE img_file.img10, 
                ts35    LIKE ccc_file.ccc23,
                tq36    LIKE img_file.img10, 
                ts36    LIKE ccc_file.ccc23,
                tq37    LIKE img_file.img10, 
                ts37    LIKE ccc_file.ccc23,
                tq38    LIKE img_file.img10, 
                ts38    LIKE ccc_file.ccc23,
                tq39    LIKE img_file.img10, 
                ts39    LIKE ccc_file.ccc23,
                tq40    LIKE img_file.img10, 
                ts40    LIKE ccc_file.ccc23,
                tq41    LIKE img_file.img10, 
                ts41    LIKE ccc_file.ccc23,
                tq42    LIKE img_file.img10, 
                ts42    LIKE ccc_file.ccc23, 
                tq43    LIKE img_file.img10, 
                ts43    LIKE ccc_file.ccc23,
                tq44    LIKE img_file.img10, 
                ts44    LIKE ccc_file.ccc23,
                tq45    LIKE img_file.img10, 
                ts45    LIKE ccc_file.ccc23,
                tq46    LIKE img_file.img10, 
                ts46    LIKE ccc_file.ccc23,
                tq47    LIKE img_file.img10, 
                ts47    LIKE ccc_file.ccc23,
                tq48    LIKE img_file.img10, 
                ts48    LIKE ccc_file.ccc23,
                tq49    LIKE img_file.img10, 
                ts49    LIKE ccc_file.ccc23,
                tq50    LIKE img_file.img10, 
                ts50    LIKE ccc_file.ccc23,
                q3      LIKE ccc_file.ccc23, #結存數量
                s3      LIKE ccc_file.ccc23, #結存金額 
                ima06_desc  LIKE imz_file.imz02,
                ima09_desc  LIKE imz_file.imz02,
                ima10_desc  LIKE imz_file.imz02,
                ima11_desc  LIKE imz_file.imz02,
                ima12_desc  LIKE imz_file.imz02,
                ima131_desc LIKE oba_file.oba02
            END RECORD

    DEFINE g_img_sum   DYNAMIC ARRAY OF RECORD
                ima01   LIKE ima_file.ima01,
                ima02   LIKE ima_file.ima02,
                ima021  LIKE ima_file.ima021,
                img02   LIKE img_file.img02,
                imd02   LIKE imd_file.imd02,
                img03   LIKE img_file.img03,
                ime03   LIKE ime_file.ime03,
                ima06_desc  LIKE imz_file.imz02,
                ima09_desc  LIKE imz_file.imz02,
                ima10_desc  LIKE imz_file.imz02,
                ima11_desc  LIKE imz_file.imz02,
                ima12_desc  LIKE imz_file.imz02,
                ima131_desc LIKE oba_file.oba02,
                p0      LIKE ccc_file.ccc23, #計畫單價
                q0      LIKE img_file.img10, #期初數量
                s0      LIKE ccc_file.ccc23, #期初金額
                tq1     LIKE img_file.img10, #異動類別1數量
                ts1     LIKE ccc_file.ccc23, #异动类别1金額
                tq2     LIKE img_file.img10, 
                ts2     LIKE ccc_file.ccc23, 
                tq3     LIKE img_file.img10, 
                ts3     LIKE ccc_file.ccc23,
                tq4     LIKE img_file.img10, 
                ts4     LIKE ccc_file.ccc23,
                tq5     LIKE img_file.img10, 
                ts5     LIKE ccc_file.ccc23,
                tq6     LIKE img_file.img10, 
                ts6     LIKE ccc_file.ccc23,
                tq7     LIKE img_file.img10, 
                ts7     LIKE ccc_file.ccc23,
                tq8     LIKE img_file.img10, 
                ts8     LIKE ccc_file.ccc23,
                tq9     LIKE img_file.img10, 
                ts9     LIKE ccc_file.ccc23,
                tq10    LIKE img_file.img10, 
                ts10    LIKE ccc_file.ccc23,
                tq11    LIKE img_file.img10, 
                ts11    LIKE ccc_file.ccc23,
                tq12    LIKE img_file.img10, 
                ts12    LIKE ccc_file.ccc23, 
                tq13    LIKE img_file.img10, 
                ts13    LIKE ccc_file.ccc23,
                tq14    LIKE img_file.img10, 
                ts14    LIKE ccc_file.ccc23,
                tq15    LIKE img_file.img10, 
                ts15    LIKE ccc_file.ccc23,
                tq16    LIKE img_file.img10, 
                ts16    LIKE ccc_file.ccc23,
                tq17    LIKE img_file.img10, 
                ts17    LIKE ccc_file.ccc23,
                tq18    LIKE img_file.img10, 
                ts18    LIKE ccc_file.ccc23,
                tq19    LIKE img_file.img10, 
                ts19    LIKE ccc_file.ccc23,
                tq20    LIKE img_file.img10, 
                ts20    LIKE ccc_file.ccc23,
                tq21    LIKE img_file.img10, 
                ts21    LIKE ccc_file.ccc23,
                tq22    LIKE img_file.img10, 
                ts22    LIKE ccc_file.ccc23, 
                tq23    LIKE img_file.img10, 
                ts23    LIKE ccc_file.ccc23,
                tq24    LIKE img_file.img10, 
                ts24    LIKE ccc_file.ccc23,
                tq25    LIKE img_file.img10, 
                ts25    LIKE ccc_file.ccc23,
                tq26    LIKE img_file.img10, 
                ts26    LIKE ccc_file.ccc23,
                tq27    LIKE img_file.img10, 
                ts27    LIKE ccc_file.ccc23,
                tq28    LIKE img_file.img10, 
                ts28    LIKE ccc_file.ccc23,
                tq29    LIKE img_file.img10, 
                ts29    LIKE ccc_file.ccc23,
                tq30    LIKE img_file.img10, 
                ts30    LIKE ccc_file.ccc23,
                tq31    LIKE img_file.img10, 
                ts31    LIKE ccc_file.ccc23,
                tq32    LIKE img_file.img10, 
                ts32    LIKE ccc_file.ccc23, 
                tq33    LIKE img_file.img10, 
                ts33    LIKE ccc_file.ccc23,
                tq34    LIKE img_file.img10, 
                ts34    LIKE ccc_file.ccc23,
                tq35    LIKE img_file.img10, 
                ts35    LIKE ccc_file.ccc23,
                tq36    LIKE img_file.img10, 
                ts36    LIKE ccc_file.ccc23,
                tq37    LIKE img_file.img10, 
                ts37    LIKE ccc_file.ccc23,
                tq38    LIKE img_file.img10, 
                ts38    LIKE ccc_file.ccc23,
                tq39    LIKE img_file.img10, 
                ts39    LIKE ccc_file.ccc23,
                tq40    LIKE img_file.img10, 
                ts40    LIKE ccc_file.ccc23,
                tq41    LIKE img_file.img10, 
                ts41    LIKE ccc_file.ccc23,
                tq42    LIKE img_file.img10, 
                ts42    LIKE ccc_file.ccc23, 
                tq43    LIKE img_file.img10, 
                ts43    LIKE ccc_file.ccc23,
                tq44    LIKE img_file.img10, 
                ts44    LIKE ccc_file.ccc23,
                tq45    LIKE img_file.img10, 
                ts45    LIKE ccc_file.ccc23,
                tq46    LIKE img_file.img10, 
                ts46    LIKE ccc_file.ccc23,
                tq47    LIKE img_file.img10, 
                ts47    LIKE ccc_file.ccc23,
                tq48    LIKE img_file.img10, 
                ts48    LIKE ccc_file.ccc23,
                tq49    LIKE img_file.img10, 
                ts49    LIKE ccc_file.ccc23,
                tq50    LIKE img_file.img10, 
                ts50    LIKE ccc_file.ccc23,
                q3      LIKE ccc_file.ccc23, #結存數量
                s3      LIKE ccc_file.ccc23  #結存金額 
       END RECORD
DEFINE g_chr            LIKE type_file.chr1    
DEFINE g_i              LIKE type_file.num5     

DEFINE l_table     STRING                       
DEFINE g_sql       STRING                       
DEFINE g_str       STRING                       
DEFINE g_cnt       LIKE type_file.num10  
DEFINE g_argv1     LIKE imd_file.imd01,      #INPUT ARGUMENT - 1
       g_img02     LIKE img_file.img02,
       g_rec_b     LIKE type_file.num5,           #單身筆數 
       g_rec_b2    LIKE type_file.num5
  
DEFINE p_row,p_col     LIKE type_file.num5   
DEFINE g_msg           LIKE type_file.chr1000 
DEFINE g_row_count     LIKE type_file.num10  
DEFINE g_curs_index    LIKE type_file.num10   
DEFINE g_jump          LIKE type_file.num10   
DEFINE mi_no_ask       LIKE type_file.num5  
DEFINE g_ac            LIKE type_file.num5      
DEFINE g_flag         LIKE type_file.chr1    #FUN-C80102 
DEFINE g_action_flag  LIKE type_file.chr100
DEFINE g_filter_wc  STRING 
DEFINE l_ac,l_ac1     LIKE type_file.num5
DEFINE   f    ui.Form
DEFINE   page om.DomNode
DEFINE   w    ui.Window                


MAIN

   OPTIONS                                 #改變一些系統預設值
        INPUT NO WRAP                      #輸入的方式: 不打轉
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("aoo")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
   CALL q200_table()
   LET l_bdate = NULL   
   LET l_edate = NULL  
   OPEN WINDOW aooq200_w AT p_row,p_col
         WITH FORM "aoo/42f/aooq200" 
          ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()
   CALL q200_tq_visible()
   CALL q200_tq_1_visible()
   CALL q200_q() 
   CALL cl_set_act_visible("revert_filter",FALSE)
   CALL q200_menu()
   DROP TABLE aooq200_tmp;
   CLOSE WINDOW aooq200_w
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time      #計算使用時間 (退出使間) 
             
END MAIN

#QBE 查詢資料
FUNCTION q200_cs()
DEFINE  l_cnt        LIKE type_file.num5    
DEFINE  lc_qbe_sn    LIKE gbm_file.gbm01    
DEFINE  l_azp06      LIKE azp_file.azp06    
DEFINE  l_n          LIKE type_file.num5

   INITIALIZE tm.* TO NULL
   LET g_cnt = ''
   CLEAR FORM 
   LET tm.price = 'Y'
   LET tm.viewall = 'Y'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1' 
   LET tm.c = '1'
   SELECT (YEAR(sysdate)||'/'||Month(sysdate)||'/01') INTO tm.bdate FROM DUAL 
   LET tm.edate = g_today  
   WHILE TRUE
   
   INPUT BY NAME tm.azp01,tm.bdate,tm.edate,tm.c,tm.gge01,
                 tm.price,tm.yy,tm.mm,tm.viewall WITHOUT DEFAULTS  
      BEFORE INPUT
         CALL cl_qbe_display_condition(lc_qbe_sn)
         LET tm.azp01 = g_plant   
         DISPLAY tm.azp01 TO azp01     

      AFTER FIELD azp01                       
         LET l_n = 0
         IF NOT cl_null(tm.azp01) THEN
            SELECT COUNT(*) INTO l_n FROM azp_file
               WHERE azp01 = tm.azp01
            IF l_n < 1 THEN
               CALL cl_err(tm.azp01,'art-238',0)
               NEXT FIELD azp01
            END IF 
         END IF 
      AFTER FIELD gge01
         IF NOT cl_null(tm.gge01) THEN
            LET l_n = 0
            SELECT COUNT(*) INTO l_n FROM gge_file
               WHERE gge01 = tm.gge01
            IF l_n < 1 THEN
               CALL cl_err(tm.gge01,'aoo-431',0)
               NEXT FIELD gge01
            END IF
         END IF 
         IF NOT cl_null(tm.gge01) THEN
            SELECT gge02 INTO tm.gge02 FROM gge_file
               WHERE gge01 = tm.gge01
            DISPLAY tm.gge02 TO gge02
         END IF 
         
      AFTER FIELD bdate
         LET g_yy=YEAR(tm.bdate)
         LET g_mm=MONTH(tm.bdate)
         IF tm.edate IS NULL THEN
            LET tm.edate = tm.bdate DISPLAY BY NAME tm.edate
         END IF
         LET tm.yy=g_yy
         LET tm.mm=g_mm
         DISPLAY BY NAME tm.yy
         DISPLAY BY NAME tm.mm

      AFTER FIELD mm
         IF NOT cl_null(tm.mm) THEN
            IF tm.mm > 12 OR tm.mm < 1 THEN
               CALL cl_err('','agl-020',0)
               NEXT FIELD mm
            END IF
         END IF

      AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
         IF tm.edate < tm.bdate THEN
            CALL cl_err('','agl-031',0)
            NEXT FIELD edate
         END IF
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(azp01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azp"
               LET g_qryparam.default1 = tm.azp01
               SELECT azp06 INTO l_azp06
                 FROM azp_file
                WHERE azp01=g_plant 
               LET g_qryparam.arg1=l_azp06
               CALL cl_create_qry() RETURNING tm.azp01
               DISPLAY  tm.azp01 TO azp01
               NEXT FIELD azp01
            WHEN INFIELD(gge01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gge01"
               LET g_qryparam.default1 = tm.gge01
               CALL cl_create_qry() RETURNING tm.gge01
               DISPLAY  tm.gge01 TO gge01
               NEXT FIELD gge01
         END CASE

      ON ACTION CONTROLZ
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

      ON ACTION exit
         LET INT_FLAG = 1
         EXIT INPUT
      ON ACTION qbe_save
         CALL cl_qbe_save()
   END INPUT
   LET l_bdate = tm.bdate
   LET l_edate = tm.edate
    
   IF INT_FLAG THEN
      INITIALIZE tm.* TO NULL
      IF cl_null(g_action_flag) THEN
         LET g_action_flag = "page1"
      END IF 
      RETURN 
   END IF

   CONSTRUCT tm.wc ON img02,img03,img04,img19,ima12,ima01,ima02,ima021,img09   
                 FROM s_img[1].b_img02,s_img[1].b_img03,s_img[1].b_img04,
                      s_img[1].b_img19,s_img[1].b_ima12,s_img[1].b_ima01,
                      s_img[1].b_ima02,s_img[1].b_ima021,s_img[1].b_img09                              
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
         IF tm.price='Y' THEN 
            CALL cl_set_comp_visible('p0,s0,s3',TRUE)
         ELSE
            CALL cl_set_comp_visible('p0,s0,s3',FALSE)
         END IF
   
      ON ACTION locale
         CALL cl_show_fld_cont()                   #No:FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
   
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(b_ima01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima01a"
               LET g_qryparam.state = 'c'
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO b_ima01
               NEXT FIELD b_ima01
             WHEN INFIELD(b_img02)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_imd"
               LET g_qryparam.state = 'c'
               LET g_qryparam.arg1     = 'SW'
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO b_img02
               NEXT FIELD b_img02
             WHEN INFIELD(b_img03)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_img03"
               LET g_qryparam.state = 'c'
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO b_img03
               NEXT FIELD b_img03
             WHEN INFIELD(b_img04)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_img04"
               LET g_qryparam.state = 'c'
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO b_img04
               NEXT FIELD b_img04
             WHEN INFIELD(b_img09)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_img09"
               LET g_qryparam.state = 'c'
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO b_img09
               NEXT FIELD b_img09
             WHEN INFIELD(b_ima12)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azf"
               LET g_qryparam.state = "c"
               LET g_qryparam.arg1 = "G"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO b_ima12
               NEXT FIELD b_ima12
          END CASE
   
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
    
         ON ACTION about        
            CALL cl_about()      
      
         ON ACTION help         
            CALL cl_show_help() 
     
         ON ACTION controlg    
            CALL cl_cmdask()    
    
         ON ACTION EXIT
            LET INT_FLAG = 1
            EXIT CONSTRUCT  
         ON ACTION qbe_select
            CALL cl_qbe_select()
      END CONSTRUCT
    
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
    
      IF INT_FLAG THEN
         INITIALIZE tm.* TO NULL
         IF cl_null(g_action_flag) THEN
            LET g_action_flag = "page1"
         END IF
         RETURN 
      END IF
      IF NOT cl_null(tm.wc) THEN EXIT WHILE END IF
   END WHILE
   
   CALL s_azm(g_yy,g_mm) RETURNING g_chr,m_bdate,i
   LET last_y = g_yy LET last_m = g_mm - 1
   IF last_m = 0 THEN LET last_y = last_y - 1 LET last_m = 12 END IF
   
   CALL q200()  
END FUNCTION

FUNCTION q200_menu()
DEFINE l_cnt LIKE type_file.num5

   WHILE TRUE
      IF cl_null(g_action_choice) THEN 
         IF g_action_flag = "page1" THEN  
            CALL q200_bp("G")
         END IF
         IF g_action_flag = "page2" THEN  
            CALL q200_bp2()
         END IF
      END IF
      CASE g_action_choice
         WHEN "page1"
               CALL q200_bp("G")
         
         WHEN "page2"
               CALL q200_bp2()
         WHEN "data_filter"       #資料過濾
            IF cl_chk_act_auth() THEN
               CALL q200_filter_askkey()
               CALL q200()        #重填充新臨時表
               CALL q200_show()
            END IF            
            LET g_action_choice = " "
         WHEN "revert_filter"     # 過濾還原
            IF cl_chk_act_auth() THEN
               LET g_filter_wc = ''
               CALL cl_set_act_visible("revert_filter",FALSE) 
               CALL q200()        #重填充新臨時表
               CALL q200_show() 
            END IF             
            LET g_action_choice = " "
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q200_q()
            END IF
            LET g_action_choice = " " 
         WHEN "help"
            CALL cl_show_help()
            LET g_action_choice = " "
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
            LET g_action_choice = " " 
         WHEN "exporttoexcel" 
            LET w = ui.Window.getCurrent()
             LET f = w.getForm()
             IF g_action_flag = "page1" THEN  
                IF cl_chk_act_auth() THEN
                   LET page = f.FindNode("Page","page1")
                   CALL cl_export_to_excel(page,base.TypeInfo.create(g_img_excel),'','')
                END IF
             END IF  
             IF g_action_flag = "page2" THEN
                IF cl_chk_act_auth() THEN
                   LET page = f.FindNode("Page","page2")
                   CALL cl_export_to_excel(page,base.TypeInfo.create(g_img_sum),'','')
                END IF
             END IF
            LET g_action_choice = " "  #FUN-C80102 "
      END CASE
   END WHILE
END FUNCTION

FUNCTION q200_q()

    CALL cl_opmsg('q')
    CALL cl_set_comp_visible("page2", FALSE)
    CALL ui.interface.refresh()
    CALL cl_set_comp_visible("page2", TRUE)
    CALL g_img.clear()
    CALL g_img_excel.clear()
    CALL g_img_sum.clear()
    LET g_action_choice = " "
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL q200_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
END FUNCTION

FUNCTION q200_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1   

   IF p_ud <> "G" THEN
      RETURN
   END IF
   
   LET g_action_flag = 'page1'
   IF g_action_choice = "page1"  AND g_flag != '1' THEN
      CALL q200_b_fill_1()
   END IF
   LET g_action_choice = " "
   LET g_flag = ' ' 
   DISPLAY g_rec_b TO FORMONLY.cnt
   CALL cl_set_act_visible("accept,cancel", FALSE)

   DIALOG ATTRIBUTES(UNBUFFERED=TRUE)
      INPUT tm.c FROM c ATTRIBUTE(WITHOUT DEFAULTS) 
           
         ON CHANGE c 
            IF NOT cl_null(tm.c)  THEN 
               CALL q200_b_fill_2()
               CALL q200_set_visible()
               CALL cl_set_comp_visible("page1", FALSE)
               CALL ui.interface.refresh()
               CALL cl_set_comp_visible("page1", TRUE)
               LET g_action_choice = "page2"
            END IF 
            DISPLAY BY NAME tm.c
            EXIT DIALOG

      END INPUT
      DISPLAY ARRAY g_img TO s_img.* ATTRIBUTE(COUNT=g_rec_b)

         BEFORE ROW
            LET l_ac = ARR_CURR()
            CALL cl_show_fld_cont()
         BEFORE DISPLAY
            CALL cl_navigator_setting( g_curs_index, g_row_count )
            CALL fgl_set_arr_curr(g_ac) 
            IF tm.price='Y' THEN 
               CALL cl_set_comp_visible('p0,s0,s3',TRUE)
            ELSE
               CALL cl_set_comp_visible('p0,s0,s3',FALSE)
            END IF
            CALL cl_show_fld_cont()         

      END DISPLAY         

      ON ACTION page2
         LET g_action_choice = 'page2'
         EXIT DIALOG

      ON ACTION data_filter
         LET g_action_choice="data_filter"
         EXIT DIALOG     

      ON ACTION revert_filter         
         LET g_action_choice="revert_filter"
         EXIT DIALOG 

      ON ACTION refresh_detail          #明細資料刷新
         CALL q200_b_fill_1()
         CALL cl_set_comp_visible("page2", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page2", TRUE)
         LET g_action_choice = 'page1' 
         EXIT DIALOG
         
      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG
         
      ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG

      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()               

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG


      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG

      ON ACTION accept
#        LET l_ac = ARR_CURR()
         EXIT DIALOG
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 		
         LET g_action_choice="exit"
         EXIT DIALOG

      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
 
      ON ACTION about       
         CALL cl_about()       

      AFTER DIALOG
         CONTINUE DIALOG

     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        

   END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION


FUNCTION q200()              
   DEFINE l_sql,l_sql1      STRING
   DEFINE l_flag     LIKE type_file.num5,     
          l_factor   LIKE ima_file.ima31_fac,  
          l_ima01    LIKE ima_file.ima01, 
          l_img02    LIKE img_file.img02,  
          l_ima12    LIKE ima_file.ima12, 
          l_img03    LIKE img_file.img03,  
          l_img04    LIKE img_file.img04,  
          l_img19    LIKE img_file.img19   
   DEFINE tok           base.StringTokenizer
   DEFINE l_dbs         LIKE azp_file.azp03
   DEFINE l_azp02       LIKE azp_file.azp02  #free add
   DEFINE l_tlf907      LIKE tlf_file.tlf907
   DEFINE l_first       LIKE tlf_file.tlf06
   DEFINE l_day         LIKE type_file.num5
   DEFINE l_gge03    LIKE gge_file.gge03,
          l_gge04    LIKE gge_file.gge04,
          l_gge05    LIKE gge_file.gge05,    ##TQC-D30039---ad
          l_gge06    LIKE gge_file.gge06,
          l_ggd02    LIKE ggd_file.ggd02,
          l_i,l_i1   LIKE type_file.num5,
          l_n,l_n1   LIKE type_file.chr100,
          l_tq,l_tq1,l_ts,l_ts1,
          l_tq_1,l_ts_1
                     LIKE type_file.chr1000
   DEFINE l_str      STRING,        #TQC-D30039 add
          l_num,l_cnt LIKE type_file.num5    #TQC-D30039 add 
   DEFINE l_gge04_t  LIKE gge_file.gge04     #TQC-D30056 add
   DEFINE l_gge05_t  LIKE gge_file.gge05     #TQC-D30056 add

     DELETE FROM aooq200_tmp
     LET g_rec_b=0
     LET g_cnt = 1
     LET l_dbs = ''
     SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01=tm.azp01
     SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01=tm.azp01
     LET l_dbs=s_dbstring(l_dbs CLIPPED)
     IF cl_null(g_filter_wc) THEN LET g_filter_wc=" 1=1" END IF
     LET l_sql = " SELECT '",l_azp02,"',img02,imd02,img03,ime03,img04,img19,ima12,img01,ima02,ima021,img09, ",
                 "        NVL(stb04,0) p0,NVL(imk09,0) q0,NVL(stb04,0)*NVL(imk09,0) s0,",
                 "        0 tq1, 0 ts1, 0 tq2, 0 ts2, 0 tq3, 0 ts3, 0 tq4, 0 ts4, 0 tq5, 0 ts5, 0 tq6, 0 ts6, 0 tq7, 0 ts7, 0 tq8, 0 ts8, 0 tq9, 0 ts9, 0 tq10,0 ts10,0 tq11,0 ts11,0 tq12,0 ts12,",
                 "        0 tq13,0 ts13,0 tq14,0 ts14,0 tq15,0 ts15,0 tq16,0 ts16,0 tq17,0 ts17,0 tq18,0 ts18,0 tq19,0 ts19,0 tq20,0 ts20,0 tq21,0 ts21,0 tq22,0 ts22,0 tq23,0 ts23,0 tq24,0 ts24,0 tq25,0 ts25,",
                 "        0 tq26,0 ts26,0 tq27,0 ts27,0 tq28,0 ts28,0 tq29,0 ts29,0 tq30,0 ts30,0 tq31,0 ts31,0 tq32,0 ts32,0 tq33,0 ts33,0 tq34,0 ts34,0 tq35,0 ts35,0 tq36,0 ts36,0 tq37,0 ts37,0 tq38,0 ts38,",
                 "        0 tq39,0 ts39,0 tq40,0 ts40,0 tq41,0 ts41,0 tq42,0 ts42,0 tq43,0 ts43,0 tq44,0 ts44,0 tq45,0 ts45,0 tq46,0 ts46,0 tq47,0 ts47,0 tq48,0 ts48,0 tq49,0 ts49,0 tq50,0 ts50,",
                 "        NVL(imk09,0)+NVL(b.tlf_sum,0)-NVL(c.tlf_sum,0) q3,(NVL(imk09,0)+NVL(b.tlf_sum,0)-NVL(c.tlf_sum,0))*NVL(stb04,0) s3,",
                 "        nvl(trim(d.imz02),'') ima06_desc,nvl(trim(e.imz02),'') ima09_desc,nvl(trim(f.imz02),'') ima10_desc,nvl(trim(g.imz02),'') ima11_desc,nvl(trim(azf03),'') ima12_desc,nvl(trim(oba02),'') ima131_desc",
                 "   FROM ",l_dbs CLIPPED,"ima_file",
                 "        LEFT OUTER JOIN ",l_dbs CLIPPED,"imz_file d ON ima06=d.imz01",
                 "        LEFT OUTER JOIN ",l_dbs CLIPPED,"imz_file e ON ima09=e.imz01",
                 "        LEFT OUTER JOIN ",l_dbs CLIPPED,"imz_file f ON ima10=f.imz01",
                 "        LEFT OUTER JOIN ",l_dbs CLIPPED,"imz_file g ON ima11=g.imz01",
                 "        LEFT OUTER JOIN ",l_dbs CLIPPED,"azf_file   ON ima12=azf01 AND azf02='G'",
                 "        LEFT OUTER JOIN ",l_dbs CLIPPED,"oba_file   ON ima131=oba01,",
                            l_dbs CLIPPED,"img_file",
                 "        LEFT OUTER JOIN ",l_dbs CLIPPED,"imk_file ON img01=imk01",
                 "                                                 AND img02=imk02",
                 "                                                 AND img03=imk03",
                 "                                                 AND img04=imk04",
                 "                                                 AND imk05=",last_y,
                 "                                                 AND imk06=",last_m,
                 "        LEFT OUTER JOIN ",l_dbs CLIPPED,"stb_file ON img01=stb01",
                 "                                                 AND stb02=",tm.yy,
                 "                                                 AND stb03=",tm.mm,
                 "        LEFT OUTER JOIN ",l_dbs CLIPPED,"imd_file ON img02=imd01",
                 "        LEFT OUTER JOIN ",l_dbs CLIPPED,"ime_file ON img02=ime01",
                 "                                                 AND img03=ime02",
                 "        LEFT OUTER JOIN (SELECT tlf01,tlf902,tlf903,tlf904,SUM(tlf10*tlf60) tlf_sum ",
                 "                           FROM ",l_dbs CLIPPED,"tlf_file WHERE tlf907=1", 
                 "                            AND tlf06 BETWEEN '",tm.bdate,"' AND  '",tm.edate,"'",
                 "                       GROUP BY tlf01,tlf902,tlf903,tlf904) b",
                 "                                                  ON img01=b.tlf01",
                 "                                                 AND img02=b.tlf902",
                 "                                                 AND img03=b.tlf903",
                 "                                                 AND img04=b.tlf904",
                 "        LEFT OUTER JOIN (SELECT tlf01,tlf902,tlf903,tlf904,SUM(tlf10*tlf60) tlf_sum ",
                 "                           FROM ",l_dbs CLIPPED,"tlf_file WHERE tlf907=-1 ",
                 "                            AND tlf06 BETWEEN '",tm.bdate,"' AND  '",tm.edate,"'",
                 "                       GROUP BY tlf01,tlf902,tlf903,tlf904) c",
                 "                                                  ON img01=c.tlf01",
                 "                                                 AND img02=c.tlf902",
                 "                                                 AND img03=c.tlf903",
                 "                                                 AND img04=c.tlf904",
                 "  WHERE img01=ima01",
                 "    AND ", tm.wc CLIPPED,
                 "    AND ",g_filter_wc CLIPPED
     #如果起始日期不为第一天,则期初数量要推算至起始日期
     LET l_day=DAY(tm.bdate) 
     IF l_day<>1 THEN 
        LET l_first = s_first(tm.bdate) 
#TQC-D10103---mark---str
#    LET l_sql = " SELECT '",l_azp02,"',NVL(TRIM(img02),''),imd02,NVL(TRIM(img03),''),ime03,img04,img19,ima12,NVL(TRIM(img01),''),ima02,ima021,img09, ",
#                "        NVL(stb04,0),NVL(imk09,0),NVL(stb04,0)*NVL(imk09,0),",
#                "        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,",
#                "        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,",
#                "        NVL(imk09,0)+NVL(b.tlf_sum,0)-NVL(c.tlf_sum,0),(NVL(imk09,0)+NVL(b.tlf_sum,0)-NVL(c.tlf_sum,0))*NVL(stb04,0),",
#                "        nvl(trim(d.imz02),''),nvl(trim(e.imz02),''),nvl(trim(f.imz02),''),nvl(trim(g.imz02),''),nvl(trim(azf03),''),nvl(trim(oba02),'') ",
#TQC-D10103---mark---end
     LET l_sql = " SELECT '",l_azp02,"',img02,imd02,img03,ime03,img04,img19,ima12,img01,ima02,ima021,img09, ",
                 "        NVL(stb04,0) p0,NVL(imk09,0) q0,NVL(stb04,0)*NVL(imk09,0) s0,",
                 "        0 tq1, 0 ts1, 0 tq2, 0 ts2, 0 tq3, 0 ts3, 0 tq4, 0 ts4, 0 tq5, 0 ts5, 0 tq6, 0 ts6, 0 tq7, 0 ts7, 0 tq8, 0 ts8, 0 tq9, 0 ts9, 0 tq10,0 ts10,0 tq11,0 ts11,0 tq12,0 ts12,",
                 "        0 tq13,0 ts13,0 tq14,0 ts14,0 tq15,0 ts15,0 tq16,0 ts16,0 tq17,0 ts17,0 tq18,0 ts18,0 tq19,0 ts19,0 tq20,0 ts20,0 tq21,0 ts21,0 tq22,0 ts22,0 tq23,0 ts23,0 tq24,0 ts24,0 tq25,0 ts25,",
                 "        0 tq26,0 ts26,0 tq27,0 ts27,0 tq28,0 ts28,0 tq29,0 ts29,0 tq30,0 ts30,0 tq31,0 ts31,0 tq32,0 ts32,0 tq33,0 ts33,0 tq34,0 ts34,0 tq35,0 ts35,0 tq36,0 ts36,0 tq37,0 ts37,0 tq38,0 ts38,",
                 "        0 tq39,0 ts39,0 tq40,0 ts40,0 tq41,0 ts41,0 tq42,0 ts42,0 tq43,0 ts43,0 tq44,0 ts44,0 tq45,0 ts45,0 tq46,0 ts46,0 tq47,0 ts47,0 tq48,0 ts48,0 tq49,0 ts49,0 tq50,0 ts50,",
                 "        NVL(imk09,0)+NVL(b.tlf_sum,0)-NVL(c.tlf_sum,0) q3,(NVL(imk09,0)+NVL(b.tlf_sum,0)-NVL(c.tlf_sum,0))*NVL(stb04,0) s3,",
                 "        nvl(trim(d.imz02),'') ima06_desc,nvl(trim(e.imz02),'') ima09_desc,nvl(trim(f.imz02),'') ima10_desc,nvl(trim(g.imz02),'') ima11_desc,nvl(trim(azf03),'') ima12_desc,nvl(trim(oba02),'') ima131_desc",
                 "   FROM ",l_dbs CLIPPED,"ima_file,",
                 "        LEFT OUTER JOIN ",l_dbs CLIPPED,"imz_file d ON ima06=d.imz01",
                 "        LEFT OUTER JOIN ",l_dbs CLIPPED,"imz_file e ON ima09=e.imz01",
                 "        LEFT OUTER JOIN ",l_dbs CLIPPED,"imz_file f ON ima10=f.imz01",
                 "        LEFT OUTER JOIN ",l_dbs CLIPPED,"imz_file g ON ima11=g.imz01",
                 "        LEFT OUTER JOIN ",l_dbs CLIPPED,"azf_file   ON ima12=azf01 AND azf02='G'",
                 "        LEFT OUTER JOIN ",l_dbs CLIPPED,"oba_file   ON ima131=oba01,",
                            l_dbs CLIPPED,"img_file",
                 "        LEFT OUTER JOIN ",l_dbs CLIPPED,"imk_file ON img01=imk01",
                 "                                                 AND img02=imk02",
                 "                                                 AND img03=imk03",
                 "                                                 AND img04=imk04",
                 "                                                 AND imk05=",last_y,
                 "                                                 AND imk06=",last_m,
                 "        LEFT OUTER JOIN ",l_dbs CLIPPED,"stb_file ON img01=stb01",
                 "                                                 AND stb02=",tm.yy,
                 "                                                 AND stb03=",tm.mm,
                 "        LEFT OUTER JOIN ",l_dbs CLIPPED,"imd_file ON img02=imd01",
                 "        LEFT OUTER JOIN ",l_dbs CLIPPED,"ime_file ON img02=ime01",
                 "                                                 AND img03=ime02",
                 "        LEFT OUTER JOIN (SELECT tlf01,tlf902,tlf903,tlf904,SUM(tlf907*tlf10*tlf60) tlf_sum ",
                 "                           FROM ",l_dbs CLIPPED,"tlf_file  ",
                 "                          WHERE tlf06 BETWEEN '",l_first,"' AND '",tm.bdate,"'",
                 "                       GROUP BY tlf01,tlf902,tlf903,tlf904) a",
                 "                                                  ON img01=a.tlf01",
                 "                                                 AND img02=a.tlf902",
                 "                                                 AND img03=a.tlf903",
                 "                                                 AND img04=a.tlf904",
                 "        LEFT OUTER JOIN (SELECT tlf01,tlf902,tlf903,tlf904,SUM(tlf10*tlf60) tlf_sum ",
                 "                           FROM ",l_dbs CLIPPED,"tlf_file WHERE tlf907=1", 
                 "                            AND tlf06 BETWEEN '",tm.bdate,"' AND  '",tm.edate,"'",
                 "                       GROUP BY tlf01,tlf902,tlf903,tlf904) b",
                 "                                                  ON img01=b.tlf01",
                 "                                                 AND img02=b.tlf902",
                 "                                                 AND img03=b.tlf903",
                 "                                                 AND img04=b.tlf904",
                 "        LEFT OUTER JOIN (SELECT tlf01,tlf902,tlf903,tlf904,SUM(tlf10*tlf60) tlf_sum ",
                 "                           FROM ",l_dbs CLIPPED,"tlf_file WHERE tlf907=-1 ",
                 "                            AND tlf06 BETWEEN '",tm.bdate,"' AND  '",tm.edate,"'",
                 "                       GROUP BY tlf01,tlf902,tlf903,tlf904) c",
                 "                                                  ON img01=c.tlf01",
                 "                                                 AND img02=c.tlf902",
                 "                                                 AND img03=c.tlf903",
                 "                                                 AND img04=c.tlf904",
                 "  WHERE img01=ima01",
                 "    AND ", tm.wc CLIPPED
     END IF
 
     LET l_sql = l_sql CLIPPED," ORDER BY img01,img02,img03,img04 "

     LET l_sql1 = " INSERT INTO aooq200_tmp ",
                  l_sql CLIPPED
     PREPARE q200_p FROM l_sql1
     EXECUTE q200_p
     IF tm.viewall='N'  THEN
        DELETE FROM aooq200_tmp WHERE q0 = 0 
                                  AND q3 = 0
     END IF

#TQC-D30039---mark---start---
#    LET l_sql = "SELECT gge03 FROM ",l_dbs CLIPPED,"gge_file",
#                " WHERE gge01='",tm.gge01 CLIPPED,"'", 
#                " ORDER BY gge03"
#TQC-D30039---mark---end---
#TQC-D30039---add---start---
#    LET l_sql = "SELECT DISTINCT gge04,gge05,ggd02 FROM ",l_dbs CLIPPED,"gge_file",  #TQC-D30056 mark
     LET l_sql = "SELECT gge04,gge05,ggd02 FROM ",l_dbs CLIPPED,"gge_file",       #TQC-D30056 add
                 " LEFT OUTER JOIN ",l_dbs CLIPPED,"ggd_file ON gge05=ggd01",
                 " WHERE gge01='",tm.gge01 CLIPPED,"'",
                 " ORDER BY gge04,gge03"   #TQC-D30056 add
#TQC-D30039---add---end---
     PREPARE q200_p1 FROM l_sql
     DECLARE q200_curs1 CURSOR FOR q200_p1
  
#TQC-D30039---mark---start---
#    LET l_sql = "SELECT gge04,gge06,ggd02 FROM ",l_dbs CLIPPED,"gge_file",
#                " LEFT OUTER JOIN ",l_dbs CLIPPED," ggd_file ON gge05=ggd01",
#                " WHERE gge01='",tm.gge01 CLIPPED,"'", 
#                "   AND gge03 = ? "
#TQC-D30039---mark---end---
#TQC-D30039---add---start---
     LET l_sql = "SELECT gge06 FROM ",l_dbs CLIPPED,"gge_file",
                 " WHERE gge01='",tm.gge01 CLIPPED,"'",
                 "  AND  gge04=? AND gge05=? " 
#TQC-D30039---add---end---
     PREPARE q200_p2 FROM l_sql
     DECLARE q200_curs2 CURSOR FOR q200_p2                 #TQC-D30039 add

#TQC-D30039---add----str---
     LET l_sql = "SELECT COUNT(*) FROM ",l_dbs CLIPPED,"gge_file",
                 " WHERE gge01='",tm.gge01 CLIPPED,"'",
                 "  AND  gge04=? AND gge05=? "
     PREPARE q200_p7 FROM l_sql
#TQC-D30039---add---end---
#TQC-D30039---add---end---
     LET l_i  = 0
     LET l_i1 = 25
#    FOREACH q200_curs1 INTO l_gge03                       #TQC-D30039 mark
     FOREACH q200_curs1 INTO l_gge04,l_gge05,l_ggd02 
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach_gge:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        #TQC-D30056---add---str--
        IF NOT cl_null(l_gge04_t) AND NOT cl_null(l_gge05_t) THEN
           IF l_gge04_t = l_gge04 AND l_gge05_t = l_gge05 THEN
              CONTINUE FOREACH
           END IF 
        END IF 
        #TQC-D30056---add---end--
#       EXECUTE q200_p2 USING l_gge03 INTO l_gge04,l_gge06,l_ggd02  #TQC-D30039 mark
        
        IF l_i = 25 OR l_i1 = 50 THEN
           EXIT FOREACH
        END IF 
#TQC-D30039---add---str---       
        LET l_num = 0           
        LET l_cnt = 1
        EXECUTE q200_p7 USING l_gge04,l_gge05 INTO  l_num  
        LET l_str = '' 
        FOREACH q200_curs2 USING l_gge04,l_gge05 INTO l_gge06
           IF l_num != l_cnt THEN
              LET l_str = l_str,l_gge06,"','"
           ELSE
              LET l_str = l_str,l_gge06
           END IF
           LET l_cnt = l_cnt + 1 
        END FOREACH   
#TQC-D30039---add---end---
        IF l_gge04 = '1' THEN            #入库
           LET l_i = l_i + 1
           LET l_n  = l_i
#TQC-D10103 mark---str
#          LET l_sql = "MERGE INTO aooq200_tmp o",
#                      "           USING (SELECT tlf01,tlf902,tlf903,tlf904,SUM(tlf10) tlf10_sum,SUM(tlf10*tlf907*tlf60) tlf_sum ",  #TQC-D10103 tlf10
#                      "                    FROM ",l_dbs CLIPPED,"tlf_file ",
#                      "                   WHERE  tlf030 = '",tm.azp01 CLIPPED,"'",                                #TQC-D10103 mark
#                      "                   WHERE  tlf14  = '",l_gge06 CLIPPED,"'",
#                      "                     AND tlf06 BETWEEN '",tm.bdate,"' AND  '",tm.edate,"'",                #TQC-D10103
#                      "                   GROUP BY tlf01,tlf902,tlf903,tlf904 ) a",                               #TQC-D10103
#                      "         ON (o.ima01 = a.tlf01 AND o.img02 = a.tlf902 ",
#                      "             AND o.img03 = a.tlf903 AND o.img04 = a.tlf904 )",
#                      " WHEN MATCHED ",
#                      " THEN ",
#                      "    UPDATE ",
#                      "       SET o.tq",l_n," = a.tlf10_sum ,",                                                   #TQC-D10103 tfl10
#                      "           o.ts",l_n," = o.p0 * a.tlf_sum "
#TQC-D10103 mark---end
#TQC-D10103---add---str---
#          LET l_sql = "UPDATE aooq200_tmp o SET o.tq",l_n," = NVL((SELECT SUM(tlf10) tlf10_sum FROM ",l_dbs CLIPPED,"tlf_file x",   #TQC-D20038 mark
           LET l_sql = "UPDATE aooq200_tmp o SET o.tq",l_n," = NVL((SELECT SUM(tlf10*tlf907*tlf60) tlf10_sum FROM ",l_dbs CLIPPED,"tlf_file x",   #TQC-D20038 add
#                      "                                        WHERE x.tlf14 = '",l_gge06 CLIPPED,"'",              #TQC-D30039 mark
                       "                                        WHERE x.tlf14 IN ('",l_str CLIPPED,"')",             #TQC-D30039 add
                       "                                          AND x.tlf06 BETWEEN '",tm.bdate,"' AND '", tm.edate,"'",
                       "                                          AND o.ima01=x.tlf01 AND o.img02 = x.tlf902 ",
                       "                                          AND o.img03=x.tlf903 AND o.img04 = x.tlf904),0) "
           PREPARE q200_p3 FROM l_sql
           EXECUTE q200_p3
           LET l_sql = "UPDATE aooq200_tmp o SET o.ts",l_n," = o.p0 * NVL((SELECT SUM(tlf10*tlf907*tlf60) FROM ",l_dbs CLIPPED,"tlf_file x",
#                      "                                        WHERE x.tlf14 = '",l_gge06 CLIPPED,"'",              #TQC-D30039 mark
                       "                                        WHERE x.tlf14 IN ('",l_str CLIPPED,"')",             #TQC-D30039 add
                       "                                          AND x.tlf06 BETWEEN '",tm.bdate,"' AND '", tm.edate,"'",
                       "                                          AND o.ima01=x.tlf01 AND o.img02 = x.tlf902 ",
                       "                                          AND o.img03=x.tlf903 AND o.img04 = x.tlf904),0) " 
           PREPARE q200_p5 FROM l_sql
           EXECUTE q200_p5
#TQC-D10103---add---end---

           LET l_tq = "tq",l_n CLIPPED
           LET l_ts = "ts",l_n CLIPPED
           LET l_tq_1 = "tq",l_n CLIPPED,"_1"
           LET l_ts_1 = "ts",l_n CLIPPED,"_1"
        END IF 
         
        IF l_gge04 = '0' THEN            #出库
           LET l_i1 = l_i1 + 1
           LET l_n1 = l_i1
#TQC-D10103---mark---str---
#          LET l_sql = "MERGE INTO aooq200_tmp o",
#                      "           USING (SELECT tlf01,tlf902,tlf903,tlf904,SUM(tlf10) tlf10_sum,-1*SUM(tlf10*tlf907*tlf60) tlf_sum ", #TQC-D10103 tlf10
#                      "                    FROM ",l_dbs CLIPPED,"tlf_file", 
#                      "                   WHERE  tlf030 = '",tm.azp01 CLIPPED,"'",                                  #TQC-D10103 mark
#                      "                   WHERE  tlf14  = '",l_gge06 CLIPPED,"'",
#                      "                     AND tlf06 BETWEEN '",tm.bdate,"' AND  '",tm.edate,"'",                  #TQC-D10103
#                      "                   GROUP BY tlf01,tlf902,tlf903,tlf904 ) a",
#                      "         ON (o.ima01 = a.tlf01 AND o.img02 = a.tlf902 ",
#                      "             AND o.img03 = a.tlf903 AND o.img04 = a.tlf904 )",
#                      " WHEN MATCHED ",
#                      " THEN ",
#                      "    UPDATE ",
#                      "       SET o.tq",l_n1," = a.tlf10_sum ,",                                   #TQC-D10103 tlf10
#                      "           o.ts",l_n1," = o.p0 * a.tlf_sum "
#TQC-D10103---mark---end---
#TQC-D10103---add---str---

#          LET l_sql = "UPDATE aooq200_tmp o SET o.tq",l_n1," = NVL((SELECT SUM(tlf10) tlf10_sum FROM ",l_dbs CLIPPED,"tlf_file x",  #TQC-D20038 mark
           LET l_sql = "UPDATE aooq200_tmp o SET o.tq",l_n1," = NVL((SELECT -1*SUM(tlf10*tlf907*tlf60) tlf10_sum FROM ",l_dbs CLIPPED,"tlf_file x",  #TQC-D20038 add
#                      "                                        WHERE x.tlf14 = '",l_gge06 CLIPPED,"'",              #TQC-D30039 mark
                       "                                        WHERE x.tlf14 IN ('",l_str CLIPPED,"')",             #TQC-D30039 add
                       "                                          AND x.tlf06 BETWEEN '",tm.bdate,"' AND '", tm.edate,"'",
                       "                                          AND o.ima01=x.tlf01 AND o.img02 = x.tlf902 ",
                       "                                          AND o.img03=x.tlf903 AND o.img04 = x.tlf904),0) "
           PREPARE q200_p4 FROM l_sql
           EXECUTE q200_p4
           LET l_sql = "UPDATE aooq200_tmp o SET o.ts",l_n1," = o.p0 * NVL((SELECT -1*SUM(tlf10*tlf907*tlf60) FROM ",l_dbs CLIPPED,"tlf_file x",
#                      "                                        WHERE x.tlf14 = '",l_gge06 CLIPPED,"'",              #TQC-D30039 mark
                       "                                        WHERE x.tlf14 IN ('",l_str CLIPPED,"')",             #TQC-D30039 add
                       "                                          AND x.tlf06 BETWEEN '",tm.bdate,"' AND '", tm.edate,"'",
                       "                                          AND o.ima01=x.tlf01 AND o.img02 = x.tlf902 ",
                       "                                          AND o.img03=x.tlf903 AND o.img04 = x.tlf904),0) " 
           PREPARE q200_p6 FROM l_sql
           EXECUTE q200_p6
#TQC-D10103---add---end---
           LET l_tq = "tq",l_n1 CLIPPED
           LET l_ts = "ts",l_n1 CLIPPED
           LET l_tq_1 = "tq",l_n1 CLIPPED,"_1"
           LET l_ts_1 = "ts",l_n1 CLIPPED,"_1"
        END IF  
        
        LET l_tq1 = cl_getmsg('afa-331',g_lang)
        LET l_tq1 = l_ggd02 CLIPPED,l_tq1 CLIPPED
        LET l_ts1 = cl_getmsg('aws-028',g_lang)
        LET l_ts1 = l_ggd02 CLIPPED,l_ts1 CLIPPED 
        CALL cl_set_comp_att_text(l_tq,l_tq1)
        CALL cl_set_comp_att_text(l_ts,l_ts1)
        CALL cl_set_comp_visible(l_tq,TRUE)
        CALL cl_set_comp_visible(l_ts,TRUE) 
        CALL cl_set_comp_att_text(l_tq_1,l_tq1)
        CALL cl_set_comp_att_text(l_ts_1,l_ts1)
        CALL cl_set_comp_visible(l_tq_1,TRUE)
        CALL cl_set_comp_visible(l_ts_1,TRUE)  
        
        LET l_gge04_t = l_gge04     #TQC-D30056 add
        LET l_gge05_t = l_gge05     #TQC-D30056 add
     END FOREACH 

 CALL q200_show()
END FUNCTION

FUNCTION q200_table()
DEFINE l_sql STRING
LET l_sql = "CREATE TEMP TABLE aooq200_tmp(",
            "   azp02   LIKE azp_file.azp02,",
            "   img02   LIKE img_file.img02,",
            "   imd02   LIKE imd_file.imd02,",
            "   img03   LIKE img_file.img03,",
            "   ime03   LIKE ime_file.ime03,",
            "   img04   LIKE img_file.img04,",
            "   img19   LIKE img_file.img19,", 
            "   ima12   LIKE ima_file.ima12,",
            "   ima01   LIKE ima_file.ima01,",
            "   ima02   LIKE ima_file.ima02,",
            "   ima021  LIKE ima_file.ima021,",
            "   img09   LIKE img_file.img09,",
            "   p0      LIKE ccc_file.ccc23,", #計畫單價
            "   q0      LIKE img_file.img10,", #期初數量
            "   s0      LIKE ccc_file.ccc23,", #期初金額
            "   tq1     LIKE img_file.img10,", #異動類別1數量
            "   ts1     LIKE ccc_file.ccc23,", #异动类别1金額
            "   tq2     LIKE img_file.img10,",
            "   ts2     LIKE ccc_file.ccc23,",
            "   tq3     LIKE img_file.img10,",
            "   ts3     LIKE ccc_file.ccc23,",
            "   tq4     LIKE img_file.img10,",
            "   ts4     LIKE ccc_file.ccc23,",
            "   tq5     LIKE img_file.img10,",
            "   ts5     LIKE ccc_file.ccc23,",
            "   tq6     LIKE img_file.img10,",
            "   ts6     LIKE ccc_file.ccc23,",
            "   tq7     LIKE img_file.img10,",
            "   ts7     LIKE ccc_file.ccc23,",
            "   tq8     LIKE img_file.img10,",
            "   ts8     LIKE ccc_file.ccc23,",
            "   tq9     LIKE img_file.img10,",
            "   ts9     LIKE ccc_file.ccc23,",
            "   tq10    LIKE img_file.img10,",
            "   ts10    LIKE ccc_file.ccc23,",
            "   tq11    LIKE img_file.img10,",
            "   ts11    LIKE ccc_file.ccc23,",
            "   tq12    LIKE img_file.img10,",
            "   ts12    LIKE ccc_file.ccc23,",
            "   tq13    LIKE img_file.img10,",
            "   ts13    LIKE ccc_file.ccc23,",
            "   tq14    LIKE img_file.img10,",
            "   ts14    LIKE ccc_file.ccc23,",
            "   tq15    LIKE img_file.img10,", 
            "   ts15    LIKE ccc_file.ccc23,",
            "   tq16    LIKE img_file.img10,", 
            "   ts16    LIKE ccc_file.ccc23,",
            "   tq17    LIKE img_file.img10,",
            "   ts17    LIKE ccc_file.ccc23,",
            "   tq18    LIKE img_file.img10,",
            "   ts18    LIKE ccc_file.ccc23,",
            "   tq19    LIKE img_file.img10,",
            "   ts19    LIKE ccc_file.ccc23,",
            "   tq20    LIKE img_file.img10,",
            "   ts20    LIKE ccc_file.ccc23,",
            "   tq21    LIKE img_file.img10,",
            "   ts21    LIKE ccc_file.ccc23,",
            "   tq22    LIKE img_file.img10,",
            "   ts22    LIKE ccc_file.ccc23,",
            "   tq23    LIKE img_file.img10,",
            "   ts23    LIKE ccc_file.ccc23,",
            "   tq24    LIKE img_file.img10,",
            "   ts24    LIKE ccc_file.ccc23,",
            "   tq25    LIKE img_file.img10,",
            "   ts25    LIKE ccc_file.ccc23,",
            "   tq26    LIKE img_file.img10,",
            "   ts26    LIKE ccc_file.ccc23,",
            "   tq27    LIKE img_file.img10,",
            "   ts27    LIKE ccc_file.ccc23,",
            "   tq28    LIKE img_file.img10,",
            "   ts28    LIKE ccc_file.ccc23,",
            "   tq29    LIKE img_file.img10,",
            "   ts29    LIKE ccc_file.ccc23,",
            "   tq30    LIKE img_file.img10,",
            "   ts30    LIKE ccc_file.ccc23,",
            "   tq31    LIKE img_file.img10,",
            "   ts31    LIKE ccc_file.ccc23,",
            "   tq32    LIKE img_file.img10,",
            "   ts32    LIKE ccc_file.ccc23,",
            "   tq33    LIKE img_file.img10,",
            "   ts33    LIKE ccc_file.ccc23,",
            "   tq34    LIKE img_file.img10,",
            "   ts34    LIKE ccc_file.ccc23,",
            "   tq35    LIKE img_file.img10,",
            "   ts35    LIKE ccc_file.ccc23,",
            "   tq36    LIKE img_file.img10,",
            "   ts36    LIKE ccc_file.ccc23,",
            "   tq37    LIKE img_file.img10,",
            "   ts37    LIKE ccc_file.ccc23,",
            "   tq38    LIKE img_file.img10,",
            "   ts38    LIKE ccc_file.ccc23,",
            "   tq39    LIKE img_file.img10,",
            "   ts39    LIKE ccc_file.ccc23,",
            "   tq40    LIKE img_file.img10,",
            "   ts40    LIKE ccc_file.ccc23,",
            "   tq41    LIKE img_file.img10,",
            "   ts41    LIKE ccc_file.ccc23,",
            "   tq42    LIKE img_file.img10,",
            "   ts42    LIKE ccc_file.ccc23,",
            "   tq43    LIKE img_file.img10,",
            "   ts43    LIKE ccc_file.ccc23,",
            "   tq44    LIKE img_file.img10,",
            "   ts44    LIKE ccc_file.ccc23,",
            "   tq45    LIKE img_file.img10,",
            "   ts45    LIKE ccc_file.ccc23,",
            "   tq46    LIKE img_file.img10,",
            "   ts46    LIKE ccc_file.ccc23,",
            "   tq47    LIKE img_file.img10,",
            "   ts47    LIKE ccc_file.ccc23,",
            "   tq48    LIKE img_file.img10,",
            "   ts48    LIKE ccc_file.ccc23,",
            "   tq49    LIKE img_file.img10,",
            "   ts49    LIKE ccc_file.ccc23,",
            "   tq50    LIKE img_file.img10,",
            "   ts50    LIKE ccc_file.ccc23,",
            "   q3      LIKE ccc_file.ccc23,", #結存數量
            "   s3      LIKE ccc_file.ccc23,", #結存金額 
            "   ima06_desc  LIKE imz_file.imz02,",
            "   ima09_desc  LIKE imz_file.imz02,",
            "   ima10_desc  LIKE imz_file.imz02,",
            "   ima11_desc  LIKE imz_file.imz02,",
            "   ima12_desc  LIKE imz_file.imz02,",
            "   ima131_desc LIKE oba_file.oba02 )"
PREPARE tmp_pre FROM l_sql
EXECUTE tmp_pre
END FUNCTION 

FUNCTION q200_show()
   

   IF cl_null(g_action_flag) OR g_action_flag = "page2" THEN
      CALL q200_b_fill_1()
      CALL q200_b_fill_2()
      LET g_action_choice = "page2"
      CALL cl_set_comp_visible("page1", FALSE)
      CALL ui.interface.refresh()
      CALL cl_set_comp_visible("page1", TRUE)
   ELSE
      CALL q200_b_fill_2()
      CALL q200_b_fill_1()
      LET g_action_choice = "page1"
      CALL cl_set_comp_visible("page2", FALSE)
      CALL ui.interface.refresh()
      CALL cl_set_comp_visible("page2", TRUE)
   END IF 
   
   CALL q200_set_visible()
   CALL cl_show_fld_cont()
END FUNCTION 

FUNCTION q200_set_visible()
CALL cl_set_comp_visible("b_ima01_1,b_ima02_1,b_ima021_1,b_img02_1,b_imd02_1,b_img03_1,b_ime03_1",FALSE)
CALL cl_set_comp_visible("ima06_desc_1,ima09_desc_1,ima10_desc_1,ima11_desc_1,ima12_desc_1,ima131_desc_1",FALSE)
CASE tm.c
   WHEN "1"
      CALL cl_set_comp_visible("b_ima01_1,b_ima02_1,b_ima021_1",TRUE)
   WHEN "2"
      CALL cl_set_comp_visible("b_ima01_1,b_ima02_1,b_ima021_1,b_img02_1,b_imd02_1",TRUE)
   WHEN "3"
      CALL cl_set_comp_visible("b_ima01_1,b_ima02_1,b_ima021_1,b_img02_1,b_imd02_1,b_img03_1,b_ime03_1",TRUE)
   WHEN "4"
      CALL cl_set_comp_visible("ima06_desc_1",TRUE)
   WHEN "5"
      CALL cl_set_comp_visible("ima09_desc_1",TRUE)
   WHEN "6"
      CALL cl_set_comp_visible("ima10_desc_1",TRUE)
   WHEN "7"
      CALL cl_set_comp_visible("ima11_desc_1",TRUE)
   WHEN "8"
      CALL cl_set_comp_visible("ima12_desc_1",TRUE)
   WHEN "9"
      CALL cl_set_comp_visible("ima131_desc_1",TRUE)
END CASE
END FUNCTION 

FUNCTION q200_tq_visible()
DEFINE l_str STRING,
       i     LIKE type_file.num5,
       l_i   LIKE type_file.chr100 
LET l_str = ''
FOR i=1 TO 50
   LET l_i = i
   LET l_str = l_str,"tq",l_i CLIPPED,",ts",l_i CLIPPED
   IF i < 50 THEN
      LET l_str = l_str,","
   END IF 
END FOR 
CALL cl_set_comp_visible(l_str,FALSE)
END FUNCTION 

FUNCTION q200_tq_1_visible()
DEFINE l_str STRING,
       i     LIKE type_file.num5,
       l_i   LIKE type_file.chr100 
LET l_str = ''
FOR i=1 TO 50
   LET l_i = i
   LET l_str = l_str,"tq",l_i CLIPPED,"_1,ts",l_i CLIPPED,"_1"
   IF i < 50 THEN
      LET l_str = l_str,","
   END IF 
END FOR 
CALL cl_set_comp_visible(l_str,FALSE)
END FUNCTION 

FUNCTION q200_b_fill_1()

   LET g_sql = "SELECT * FROM aooq200_tmp "

   PREPARE aooq200_pb1 FROM g_sql
   DECLARE img_curs1  CURSOR FOR aooq200_pb1        #CURSOR

   CALL g_img.clear()
   CALL g_img_excel.clear()
   LET g_cnt = 1
   LET g_rec_b = 0

   FOREACH img_curs1 INTO g_img_excel[g_cnt].*
     IF SQLCA.sqlcode THEN
        CALL cl_err('foreach_img:',SQLCA.sqlcode,1)
        EXIT FOREACH
     END IF
     IF g_cnt <= g_max_rec THEN
        LET g_img[g_cnt].* = g_img_excel[g_cnt].*
     END IF
     LET g_cnt = g_cnt + 1

   END FOREACH
   IF g_cnt <= g_max_rec THEN
      CALL g_img.deleteElement(g_cnt)
   END IF
   CALL g_img_excel.deleteElement(g_cnt)
   LET g_rec_b = g_cnt - 1
   IF g_rec_b > g_max_rec THEN
      CALL cl_err_msg(NULL,"axc-131",g_rec_b||"|"||g_max_rec,10)
      LET g_rec_b = g_max_rec
   END IF
   DISPLAY g_rec_b TO FORMONLY.cnt
END FUNCTION

FUNCTION q200_b_fill_2()

   CALL g_img_sum.clear()
   LET g_rec_b2 = 0
   LET g_cnt = 1
  
   CALL q200_get_sum()
 
END FUNCTION

FUNCTION q200_get_sum()
DEFINE l_sql   STRING
DEFINE l_str   STRING 
DEFINE i       LIKE type_file.num5
DEFINE l_i     LIKE type_file.chr100

LET l_str = ''
FOR i=1 TO 50
   LET l_i = i
   LET l_str = l_str CLIPPED,"SUM(tq",l_i CLIPPED,"),SUM(ts",l_i CLIPPED,")"
   IF i < 50 THEN
      LET l_str = l_str,","
   END IF 
END FOR 
CASE tm.c
   WHEN "1"
      LET l_sql = "SELECT ima01,ima02,ima021,'','','','','','','','','','',",
                  "SUM(p0),SUM(q0),SUM(s0),",l_str CLIPPED,",SUM(q3),SUM(s3)",
                  " FROM aooq200_tmp",
                  " GROUP BY ima01,ima02,ima021",
                  " ORDER BY ima01,ima02,ima021"
   WHEN "2"
      LET l_sql = "SELECT ima01,ima02,ima021,img02,imd02,'','','','','','','','',",
                  "SUM(p0),SUM(q0),SUM(s0),",l_str CLIPPED,",SUM(q3),SUM(s3)",
                  " FROM aooq200_tmp",
                  " GROUP BY ima01,ima02,ima021,img02,imd02",
                  " ORDER BY ima01,ima02,ima021,img02,imd02"
   WHEN "3"
      LET l_sql = "SELECT ima01,ima02,ima021,img02,imd02,img03,ime03,'','','','','','',",
                  "SUM(p0),SUM(q0),SUM(s0),",l_str CLIPPED,",SUM(q3),SUM(s3)",
                  " FROM aooq200_tmp",
                  " GROUP BY ima01,ima02,ima021,img02,imd02,img03,ime03",
                  " ORDER BY ima01,ima02,ima021,img02,imd02,img03,ime03"
   WHEN "4"
      LET l_sql = "SELECT '','','','','','','',ima06_desc,'','','','','',",
                  "SUM(p0),SUM(q0),SUM(s0),",l_str CLIPPED,",SUM(q3),SUM(s3)",
                  " FROM aooq200_tmp",
                  " GROUP BY ima06_desc",
                  " ORDER BY ima06_desc"
   WHEN "5"
      LET l_sql = "SELECT '','','','','','','','',ima09_desc,'','','','',",
                  "SUM(p0),SUM(q0),SUM(s0),",l_str CLIPPED,",SUM(q3),SUM(s3)",
                  " FROM aooq200_tmp",
                  " GROUP BY ima09_desc",
                  " ORDER BY ima09_desc"
   WHEN "6"
      LET l_sql = "SELECT '','','','','','','','','',ima10_desc,'','','',",
                  "SUM(p0),SUM(q0),SUM(s0),",l_str CLIPPED,",SUM(q3),SUM(s3)",
                  " FROM aooq200_tmp",
                  " GROUP BY ima10_desc",
                  " ORDER BY ima10_desc"
   WHEN "7"
      LET l_sql = "SELECT '','','','','','','','','','',ima11_desc,'','',",
                  "SUM(p0),SUM(q0),SUM(s0),",l_str CLIPPED,",SUM(q3),SUM(s3)",
                  " FROM aooq200_tmp",
                  " GROUP BY ima11_desc",
                  " ORDER BY ima11_desc"
   WHEN "8"
      LET l_sql = "SELECT '','','','','','','','','','','',ima12_desc,'',",
                  "SUM(p0),SUM(q0),SUM(s0),",l_str CLIPPED,",SUM(q3),SUM(s3)",
                  " FROM aooq200_tmp",
                  " GROUP BY ima12_desc",
                  " ORDER BY ima12_desc"
   WHEN "9"
      LET l_sql = "SELECT '','','','','','','','','','','','',ima131_desc,",
                  "SUM(p0),SUM(q0),SUM(s0),",l_str CLIPPED,",SUM(q3),SUM(s3)",
                  " FROM aooq200_tmp",
                  " GROUP BY ima131_desc",
                  " ORDER BY ima131_desc"
END CASE
PREPARE q200_sum_prep FROM l_sql
DECLARE q200_sum_curs CURSOR FOR q200_sum_prep

FOREACH q200_sum_curs INTO g_img_sum[g_cnt].*
   IF SQLCA.sqlcode THEN
      CALL cl_err('foreach_img_sum:',SQLCA.sqlcode,1)
      EXIT FOREACH
   END IF    
   LET g_cnt = g_cnt + 1
END FOREACH

DISPLAY ARRAY g_img_sum TO s_img_sum.* ATTRIBUTE(COUNT=g_cnt)
      BEFORE DISPLAY
         EXIT DISPLAY
      END DISPLAY  
      CALL g_img_sum.deleteElement(g_cnt)
      LET g_rec_b2 = g_cnt - 1

    DISPLAY g_rec_b2 TO FORMONLY.cnt
END FUNCTION 

FUNCTION q200_bp2()
   DEFINE   p_ud   LIKE type_file.chr1   

   
   LET g_action_flag = 'page2'
   LET g_flag = ' ' 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY g_rec_b2 TO FORMONLY.cnt
   DIALOG ATTRIBUTES(UNBUFFERED=TRUE)
      INPUT tm.c FROM c ATTRIBUTE(WITHOUT DEFAULTS) 
           
         ON CHANGE c 
            IF NOT cl_null(tm.c)  THEN 
               CALL q200_b_fill_2()
               CALL cl_set_comp_visible("page1", FALSE)
               CALL ui.interface.refresh()
               CALL cl_set_comp_visible("page1", TRUE)
               CALL q200_set_visible()
               LET g_action_choice = "page2"
            END IF 
            DISPLAY BY NAME tm.c
            EXIT DIALOG

      END INPUT
      DISPLAY ARRAY g_img_sum TO s_img_sum.* ATTRIBUTE(COUNT=g_rec_b2)

         BEFORE ROW
            LET l_ac1 = ARR_CURR()
            CALL cl_show_fld_cont()
         BEFORE DISPLAY
            CALL cl_navigator_setting( g_curs_index, g_row_count )
            CALL fgl_set_arr_curr(g_ac) 
            IF tm.price='Y' THEN 
               CALL cl_set_comp_visible('p0_1,s0_1,s3_1',TRUE)
            ELSE
               CALL cl_set_comp_visible('p0_1,s0_1,s3_1',FALSE)
            END IF
            CALL cl_show_fld_cont()         
      END DISPLAY         

      ON ACTION page1
         LET g_action_choice = 'page1'
         EXIT DIALOG
      
      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG
         
      ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG

      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()               

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG


      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG

      ON ACTION ACCEPT
         LET l_ac1 = ARR_CURR()
         IF NOT cl_null(g_action_choice) AND l_ac1 > 0  THEN
            CALL q200_detail_fill(l_ac1)
            CALL cl_set_comp_visible("page2", FALSE)
            CALL ui.interface.refresh()
            CALL cl_set_comp_visible("page2", TRUE)
            LET g_action_choice= "page1" 
            LET g_flag = '1'            
            EXIT DIALOG 
         END IF
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 		
         LET g_action_choice="exit"
         EXIT DIALOG

      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
 
      ON ACTION about       
         CALL cl_about()       

      AFTER DIALOG
         CONTINUE DIALOG

     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        

   END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION q200_detail_fill(p_ac)
DEFINE p_ac   LIKE type_file.num5
DEFINE l_sql  STRING 
DEFINE l_tmp,l_tmp1,l_tmp2  STRING
CASE tm.c
   WHEN "1"
      IF cl_null(g_img_sum[p_ac].ima01) THEN 
         LET l_tmp = " OR ima01 IS NULL "
      ELSE 
         LET l_tmp = ''
      END IF
      LET l_sql = "SELECT * FROM aooq200_tmp ",
                  " WHERE ima01 = '",g_img_sum[p_ac].ima01,"'",l_tmp,
                  " ORDER BY ima01,ima02,ima021"
   WHEN "2"
      IF cl_null(g_img_sum[p_ac].ima01) THEN
         LET l_tmp = " OR ima01 IS NULL "
      ELSE   
         LET l_tmp = ''
      END IF
      IF cl_null(g_img_sum[p_ac].img02) THEN
         LET g_img_sum[p_ac].img02 = ''
         LET l_tmp1= " OR img02 IS NULL "
      ELSE
         LET l_tmp1= ''
      END IF
      LET l_sql = "SELECT * FROM aooq200_tmp",
                  " WHERE (ima01 = '",g_img_sum[p_ac].ima01,"'",l_tmp,")",
                  "   AND (img02 = '",g_img_sum[p_ac].img02,"'",l_tmp1,")",
                  " ORDER BY ima01,ima02,ima021,img02,imd02"
   WHEN "3"
      IF cl_null(g_img_sum[p_ac].ima01) THEN
         LET l_tmp = " OR ima01 IS NULL "
      ELSE   
         LET l_tmp = ''
      END IF 
      IF cl_null(g_img_sum[p_ac].img02) THEN
         LET g_img_sum[p_ac].img02 = ''
         LET l_tmp1= " OR img02 IS NULL "
      ELSE
         LET l_tmp1= ''
      END IF
      IF cl_null(g_img_sum[p_ac].img03) THEN
         LET g_img_sum[p_ac].img03 = ''
         LET l_tmp2= " OR img03 IS NULL "
      ELSE
         LET l_tmp2= ''
      END IF 
      LET l_sql = "SELECT * FROM aooq200_tmp",
                  " WHERE (ima01 = '",g_img_sum[p_ac].ima01,"'",l_tmp,")",
                  "   AND (img02 = '",g_img_sum[p_ac].img02,"'",l_tmp1,")",
                  "   AND (img03 = '",g_img_sum[p_ac].img03,"'",l_tmp2,")",
                  " ORDER BY ima01,ima02,ima021,img02,imd02,img03,ime03"
   WHEN "4"
      IF cl_null(g_img_sum[p_ac].ima06_desc) THEN
         LET l_tmp= " OR ima06_desc IS NULL "
      ELSE
         LET l_tmp= ''
      END IF
      LET l_sql = "SELECT * FROM aooq200_tmp",
                  " WHERE ima06_desc = '",g_img_sum[p_ac].ima06_desc,"'",l_tmp,
                  " ORDER BY ima06_desc"
   WHEN "5"
      IF cl_null(g_img_sum[p_ac].ima09_desc) THEN
         LET l_tmp= " OR ima09_desc IS NULL "
      ELSE
         LET l_tmp= ''
      END IF
      LET l_sql = "SELECT * FROM aooq200_tmp",
                  " WHERE ima09_desc = '",g_img_sum[p_ac].ima09_desc,"'",l_tmp,
                  " ORDER BY ima09_desc"
   WHEN "6"
      IF cl_null(g_img_sum[p_ac].ima10_desc) THEN
         LET l_tmp= " OR ima10_desc IS NULL "
      ELSE
         LET l_tmp= ''
      END IF
      LET l_sql = "SELECT * FROM aooq200_tmp",
                  " WHERE ima10_desc = '",g_img_sum[p_ac].ima10_desc,"'",l_tmp,
                  " ORDER BY ima10_desc"
   WHEN "7"
      IF cl_null(g_img_sum[p_ac].ima11_desc) THEN
         LET l_tmp= " OR ima11_desc IS NULL "
      ELSE
         LET l_tmp= ''
      END IF
      LET l_sql = "SELECT * FROM aooq200_tmp",
                  " WHERE ima11_desc = '",g_img_sum[p_ac].ima11_desc,"'",l_tmp,
                  " ORDER BY ima11_desc"
   WHEN "8"
      IF cl_null(g_img_sum[p_ac].ima12_desc) THEN
         LET l_tmp= " OR ima12_desc IS NULL "
      ELSE
         LET l_tmp= ''
      END IF
      LET l_sql = "SELECT * FROM aooq200_tmp",
                  " WHERE ima12_desc = '",g_img_sum[p_ac].ima12_desc,"'",l_tmp,
                  " ORDER BY ima12_desc"
   WHEN "9"
      IF cl_null(g_img_sum[p_ac].ima131_desc) THEN
         LET l_tmp= " OR ima131_desc IS NULL "
      ELSE
         LET l_tmp= ''
      END IF
      LET l_sql = "SELECT * FROM aooq200_tmp",
                  " WHERE ima131_desc = '",g_img_sum[p_ac].ima131_desc,"'",l_tmp,
                  " ORDER BY ima131_desc"
END CASE 
PREPARE aooq200_pb_detail FROM l_sql
DECLARE img_curs_detail  CURSOR FOR aooq200_pb_detail        
CALL g_img.clear()
LET g_cnt = 1
LET g_rec_b = 0

FOREACH img_curs_detail INTO g_img[g_cnt].*
   IF SQLCA.sqlcode THEN
      CALL cl_err('foreach:',SQLCA.sqlcode,1)
      EXIT FOREACH
   END IF
   LET g_cnt = g_cnt + 1
END FOREACH
CALL g_img.deleteElement(g_cnt)
LET g_rec_b = g_cnt -1
DISPLAY g_rec_b TO FORMONLY.cnt
END FUNCTION 

FUNCTION q200_filter_askkey()
DEFINE l_wc   STRING
   CLEAR FORM

   CONSTRUCT l_wc ON img02,img03,img04,img19,ima12,ima01,ima02,ima021,img09   
                 FROM s_img[1].b_img02,s_img[1].b_img03,s_img[1].b_img04,
                      s_img[1].b_img19,s_img[1].b_ima12,s_img[1].b_ima01,
                      s_img[1].b_ima02,s_img[1].b_ima021,s_img[1].b_img09 
      BEFORE CONSTRUCT
         DISPLAY BY NAME tm.bdate,tm.edate,tm.price,tm.viewall,   
                         tm.yy,tm.mm,tm.azp01,tm.c,tm.gge01,tm.gge02  
         CALL cl_qbe_init()

     ON ACTION CONTROLP
         CASE
            WHEN INFIELD(b_ima01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima01a"
               LET g_qryparam.state = 'c'
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO b_ima01
               NEXT FIELD b_ima01
             WHEN INFIELD(b_img02)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_imd"
               LET g_qryparam.state = 'c'
               LET g_qryparam.arg1     = 'SW'
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO b_img02
               NEXT FIELD b_img02
             WHEN INFIELD(b_img03)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_img03"
               LET g_qryparam.state = 'c'
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO b_img03
               NEXT FIELD b_img03
             WHEN INFIELD(b_img04)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_img04"
               LET g_qryparam.state = 'c'
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO b_img04
               NEXT FIELD b_img04
             WHEN INFIELD(b_img09)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_img09"
               LET g_qryparam.state = 'c'
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO b_img09
               NEXT FIELD b_img09
             WHEN INFIELD(b_ima12)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azf"
               LET g_qryparam.state = "c"
               LET g_qryparam.arg1 = "G"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO b_ima12
               NEXT FIELD b_ima12
          END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
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

   END CONSTRUCT
   
   IF INT_FLAG THEN 
      LET g_filter_wc = ''
      CALL cl_set_act_visible("revert_filter",FALSE)
      LET INT_FLAG = 0
      RETURN 
   END IF
   IF cl_null(l_wc) THEN LET l_wc =" 1=1" END IF 
   IF l_wc !=" 1=1" THEN
      CALL cl_set_act_visible("revert_filter",TRUE)
   END IF 
   IF cl_null(g_filter_wc) THEN LET g_filter_wc = " 1=1" END IF
   LET g_filter_wc = g_filter_wc CLIPPED," AND ",l_wc CLIPPED
END FUNCTION
#FUN-CB0087

