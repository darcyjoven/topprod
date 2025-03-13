# Prog. Version..: '5.30.07-13.05.16(00000)'     #
#
# Pattern name...: aimq110
# Descriptions...: 倉庫料件數量查詢
# Date & Author..: 12/10/23 By zm  #No.FUN-C90076
# Modify.........: No.TQC-D30072 13/03/28 By fengrui 修正優化SQL問題
# Modify.........: No.TQC-D40066 13/05/23 By fengmy 修正匯出EXCEL時欄位顯示的問題
# Modify.........: No.MOD-D90033 13/09/06 By fengmy 起始日期不为第一天，期初數量要加入上月imk結存
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
           p       LIKE type_file.chr1000,  
           total   LIKE type_file.chr1,     
           c       LIKE type_file.chr1
           END RECORD,
       i,g_yy,g_mm      LIKE type_file.num5,   
       last_y,last_m	LIKE type_file.num5,   
       m_bdate	        LIKE type_file.dat     
  DEFINE  l_bdate,l_edate LIKE type_file.dat 
       
    DEFINE g_img       DYNAMIC ARRAY OF RECORD
                azp02   LIKE azp_file.azp02, 
                img02   LIKE img_file.img02,
                img03   LIKE img_file.img03,
                ime03   LIKE ime_file.ime03,
                img04   LIKE img_file.img04,
                imd02   LIKE imd_file.imd02,  
                img19   LIKE img_file.img19,  
                ima12   LIKE ima_file.ima12,
                ima01   LIKE ima_file.ima01,
                ima02   LIKE ima_file.ima02,
                ima021  LIKE ima_file.ima021,
                img09   LIKE img_file.img09,  
                q0   LIKE img_file.img10, #期初
                p0   LIKE ccc_file.ccc23,
                s0   LIKE ccc_file.ccc23,
                n0   LIKE ccc_file.ccc23,
                r0   LIKE ccc_file.ccc23,
                m0   LIKE ccc_file.ccc23,
                q1   LIKE img_file.img19, #出
                p1   LIKE ccc_file.ccc23,
                s1   LIKE ccc_file.ccc23,
                n1   LIKE ccc_file.ccc23,
                r1   LIKE ccc_file.ccc23,
                m1   LIKE ccc_file.ccc23,
                q2   LIKE img_file.img10, #入 
                p2   LIKE ccc_file.ccc23,
                s2   LIKE ccc_file.ccc23,
                n2   LIKE ccc_file.ccc23,
                r2   LIKE ccc_file.ccc23,
                m2   LIKE ccc_file.ccc23,
                q3   LIKE img_file.img10, 
                p3   LIKE ccc_file.ccc23,
                s3   LIKE ccc_file.ccc23,
                n3   LIKE ccc_file.ccc23,
                r3   LIKE ccc_file.ccc23,
                m3   LIKE ccc_file.ccc23
       END RECORD
    DEFINE g_img_attr   DYNAMIC ARRAY OF RECORD
                azp02   STRING ,
                img02   STRING ,
                img03   STRING ,
                ime03   STRING ,
                img04   STRING ,
                imd02   STRING ,
                img19   STRING ,
                ima12   STRING ,
                ima01   STRING ,
                ima02   STRING ,
                ima021  STRING ,
                img09   STRING ,
                q0      STRING ,
                p0      STRING ,
                s0      STRING ,
                n0      STRING , 
                r0      STRING ,
                m0      STRING ,
                q1      STRING ,
                p1      STRING ,
                s1      STRING ,
                n1      STRING ,
                r1      STRING ,
                m1      STRING ,
                q2      STRING ,
                p2      STRING ,
                s2      STRING ,
                n2      STRING ,
                r2      STRING ,
                m2      STRING ,
                q3      STRING ,
                p3      STRING ,
                s3      STRING ,
                n3      STRING ,
                r3      STRING ,
                m3      STRING  
       END RECORD
DEFINE g_chr            LIKE type_file.chr1    
DEFINE g_i              LIKE type_file.num5     

DEFINE l_table     STRING                       
DEFINE g_sql       STRING                       
DEFINE g_str       STRING                       
DEFINE g_cnt       LIKE type_file.num10  
DEFINE g_argv1     LIKE imd_file.imd01,      #INPUT ARGUMENT - 1
       g_img02     LIKE img_file.img02,
#      g_imd_rowid LIKE type_file.chr18,    
       g_rec_b     LIKE type_file.num5           #單身筆數 
  
DEFINE p_row,p_col     LIKE type_file.num5   
DEFINE g_msg           LIKE type_file.chr1000 
DEFINE g_row_count     LIKE type_file.num10  
DEFINE g_curs_index    LIKE type_file.num10   
DEFINE g_jump          LIKE type_file.num10   
DEFINE mi_no_ask       LIKE type_file.num5  
DEFINE g_ac            LIKE type_file.num5    
DEFINE g_azp01         STRING                   
#DEFINE lwin_curr       ui.Window,
#       lfrm_curr       ui.Form

MAIN

   OPTIONS                                 #改變一些系統預設值
#       FORM LINE       FIRST + 2,         #畫面開始的位置
#       MESSAGE LINE    LAST,              #訊息顯示的位置
#       PROMPT LINE     LAST,              #提示訊息的位置
        INPUT NO WRAP                      #輸入的方式: 不打轉
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time 

    LET l_bdate = NULL   
    LET l_edate = NULL  
    OPEN WINDOW aimq110_w AT p_row,p_col
         WITH FORM "aim/42f/aimq110" 
          ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()
    IF NOT cl_null(g_argv1) THEN CALL q110_q() END IF

    CALL cl_set_comp_visible('m0,m1,m2,m3,n0,n1,n2,n3,p1,p2,p3,r0,r1,r2,r3',FALSE)
   
    CALL q110_menu()
    CLOSE WINDOW aimq110_w
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time      #計算使用時間 (退出使間) 
             
END MAIN

#QBE 查詢資料
FUNCTION q110_cs()
DEFINE  l_cnt        LIKE type_file.num5    
DEFINE  lc_qbe_sn    LIKE gbm_file.gbm01    
DEFINE  l_azp06      LIKE azp_file.azp06    


   INITIALIZE tm.* TO NULL
   CALL g_img.clear() 
   CALL g_img_attr.clear() 
   LET g_cnt = ''
   CLEAR FORM 
   LET tm.price = 'Y'
   LET tm.viewall = 'Y'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1' 
   LET tm.total = 'N'
   LET tm.c = '1'
#  SELECT trunc(sysdate,'MM') INTO tm.bdate FROM DUAL
   SELECT (YEAR(sysdate)||'/'||Month(sysdate)||'/01') INTO tm.bdate FROM DUAL #FUN-C90076 xj
   LET tm.edate = g_today  
   WHILE TRUE
      CONSTRUCT BY NAME tm.p  ON azp01
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
            LET tm.p = g_plant
            DISPLAY tm.p TO azp01
             
      AFTER FIELD azp01                     
         LET g_azp01 = GET_FLDBUF(azp01)       
         IF g_azp01.trim() = '*' THEN 
            CALL cl_err(g_azp01,'aim-397',1) 
            NEXT FIELD azp01
         END IF 
         IF cl_null(g_azp01) OR g_azp01.trim() = '' THEN 
            CALL cl_err('','asm-609',1)
            NEXT FIELD azp01
         END IF 
         
      ON ACTION locale
         CALL cl_show_fld_cont()                  
         LET g_action_choice = "locale"
         EXIT CONSTRUCT

      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(azp01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azp"
               LET g_qryparam.state = 'c' 
               SELECT azp06 INTO l_azp06
                 FROM azp_file
                WHERE azp01=g_plant 
               LET g_qryparam.arg1=l_azp06
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO azp01
               NEXT FIELD azp01
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
 
      IF INT_FLAG THEN
         INITIALIZE tm.* TO NULL
         RETURN 
      END IF

   
   INPUT BY NAME tm.bdate,tm.edate,
                 tm.price,tm.viewall,tm.yy,tm.mm,tm.total,tm.c WITHOUT DEFAULTS  
      BEFORE INPUT
         CALL cl_qbe_display_condition(lc_qbe_sn)
         IF NOT cl_null(tm.p)THEN 
          #   LET tm.total='Y'
             DISPLAY BY NAME tm.total
         END IF  
         CALL cl_set_comp_entry('c',tm.total='Y')

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
 
      ON CHANGE total
         IF tm.total = 'N' THEN 
            LET tm.c = ''
         ELSE 
            LET tm.c = '1'
         END IF 
         CALL cl_set_comp_entry('c',tm.total = 'Y')
         DISPLAY BY NAME tm.c

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
      RETURN 
   END IF

   CONSTRUCT tm.wc ON img02,img03,img04,img19,ima12,ima01,ima02,ima021,img09   
                #FROM s_img[1].b_img02,s_img[1].b_img03,s_img[1].b_img04, #TQC-D40066 mark
                #     s_img[1].b_img19,s_img[1].b_ima12,s_img[1].b_ima01, #TQC-D40066 mark
                #     s_img[1].b_ima02,s_img[1].b_ima021,s_img[1].b_img09 #TQC-D40066 mark                             
                 FROM s_img[1].img02,s_img[1].img03,s_img[1].img04, #TQC-D40066 add
                      s_img[1].img19,s_img[1].ima12,s_img[1].ima01, #TQC-D40066 add
                      s_img[1].ima02,s_img[1].ima021,s_img[1].img09 #TQC-D40066 add                             
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
         IF tm.price='Y' THEN 
            CALL cl_set_comp_visible('p0,s0,s1,s2,s3',TRUE)
         ELSE
            CALL cl_set_comp_visible('p0,s0,s1,s2,s3',FALSE)
         END IF
   
      ON ACTION locale
         CALL cl_show_fld_cont()                   #No:FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
   
      ON ACTION CONTROLP
         CASE
           #WHEN INFIELD(b_ima01)  #TQC-D40066 mark
            WHEN INFIELD(ima01)    #TQC-D40066 add
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima01a"
               LET g_qryparam.state = 'c'
               CALL cl_create_qry() RETURNING g_qryparam.multiret
              #DISPLAY g_qryparam.multiret TO b_ima01   #TQC-D40066 mark
              #NEXT FIELD b_ima01                       #TQC-D40066 mark
               DISPLAY g_qryparam.multiret TO ima01     #TQC-D40066 add
               NEXT FIELD ima01                         #TQC-D40066 add
            #WHEN INFIELD(b_img02)  #TQC-D40066 mark
             WHEN INFIELD(img02)    #TQC-D40066 add
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_imd"
               LET g_qryparam.state = 'c'
               LET g_qryparam.arg1     = 'SW'
               CALL cl_create_qry() RETURNING g_qryparam.multiret
              #DISPLAY g_qryparam.multiret TO b_img02   #TQC-D40066 mark
              #NEXT FIELD b_img02                       #TQC-D40066 mark
               DISPLAY g_qryparam.multiret TO img02     #TQC-D40066 add
               NEXT FIELD img02                         #TQC-D40066 add
            #WHEN INFIELD(b_img03)  #TQC-D40066 mark
             WHEN INFIELD(img03)    #TQC-D40066 add
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_img03"
               LET g_qryparam.state = 'c'
               CALL cl_create_qry() RETURNING g_qryparam.multiret
              #DISPLAY g_qryparam.multiret TO b_img03   #TQC-D40066 mark
              #NEXT FIELD b_img03                       #TQC-D40066 mark
               DISPLAY g_qryparam.multiret TO img03     #TQC-D40066 add
               NEXT FIELD img03                         #TQC-D40066 add
            #WHEN INFIELD(b_img04)  #TQC-D40066 mark
             WHEN INFIELD(img04)    #TQC-D40066 add
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_img04"
               LET g_qryparam.state = 'c'
               CALL cl_create_qry() RETURNING g_qryparam.multiret
              #DISPLAY g_qryparam.multiret TO b_img04   #TQC-D40066 mark
              #NEXT FIELD b_img04                       #TQC-D40066 mark
               DISPLAY g_qryparam.multiret TO img04     #TQC-D40066 add
               NEXT FIELD img04                         #TQC-D40066 add
            #WHEN INFIELD(b_img09)  #TQC-D40066 mark
             WHEN INFIELD(img09)    #TQC-D40066 add
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_img09"
               LET g_qryparam.state = 'c'
               CALL cl_create_qry() RETURNING g_qryparam.multiret
              #DISPLAY g_qryparam.multiret TO b_img09   #TQC-D40066 mark
              #NEXT FIELD b_img09                       #TQC-D40066 mark
               DISPLAY g_qryparam.multiret TO img09     #TQC-D40066 add
               NEXT FIELD img09                         #TQC-D40066 add
            #WHEN INFIELD(b_ima12)  #TQC-D40066 mark
             WHEN INFIELD(ima12)    #TQC-D40066 add
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azf"
               LET g_qryparam.state = "c"
               LET g_qryparam.arg1 = "G"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
              #DISPLAY g_qryparam.multiret TO b_ima12  #TQC-D40066 mark
              #NEXT FIELD b_ima12                      #TQC-D40066 mark
               DISPLAY g_qryparam.multiret TO ima12    #TQC-D40066 add
               NEXT FIELD ima12                        #TQC-D40066 add   
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
         RETURN 
      END IF
      IF NOT cl_null(tm.wc) THEN EXIT WHILE END IF
      #IF tm.wc = " 1=1" THEN
      #   CALL cl_err('','9046',0)
      #   CONTINUE WHILE
      #END IF
      #IF tm.wc != ' 1=1' THEN EXIT WHILE END IF
      #CALL cl_err('',9046,0)
   END WHILE
   
   CALL s_azm(g_yy,g_mm) RETURNING g_chr,m_bdate,i
   LET last_y = g_yy LET last_m = g_mm - 1
   IF last_m = 0 THEN LET last_y = last_y - 1 LET last_m = 12 END IF
   
   CALL q110_b_fill() #單身
END FUNCTION

FUNCTION q110_menu()
DEFINE l_cnt LIKE type_file.num5

   WHILE TRUE
      CALL q110_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q110_q()
            END IF

         WHEN "aimq231_r"
            LET l_cnt = ARR_CURR()
            LET g_ac = l_cnt 
            LET g_img02 = g_img[l_cnt].img02
            IF cl_null(tm.yy) THEN
               LET tm.yy = YEAR(tm.edate)
               LET tm.mm = MONTH(tm.edate)
            END IF
            IF NOT cl_null(g_img[l_cnt].ima01) AND NOT cl_null(g_img[l_cnt].img02) THEN
               LET g_msg = "aimq231 '",g_img[l_cnt].ima01,"' '",g_img[l_cnt].img02,"'"
               CALL cl_cmdrun(g_msg)
            END IF

         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel" 
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_img),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION

FUNCTION q110_q()

    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    DISPLAY '   ' TO FORMONLY.cn2
    CALL q110_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    DISPLAY g_row_count TO FORMONLY.cn2
END FUNCTION

FUNCTION q110_show()
   CALL q110_b_fill() #單身
   CALL cl_show_fld_cont()                  
END FUNCTION


FUNCTION q110_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1   

   IF p_ud <> "G" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   IF NOT cl_null(g_rec_b) AND g_rec_b > 0 THEN
      CALL cl_set_act_visible("aimq231_r",TRUE)
   END IF
   IF cl_null(g_rec_b) OR g_rec_b = 0 THEN
      CALL cl_set_act_visible("aimq231_r",FALSE)
   END IF
   DIALOG ATTRIBUTES(UNBUFFERED=TRUE)
      DISPLAY ARRAY g_img TO s_img.* 

         BEFORE DISPLAY
            CALL cl_navigator_setting( g_curs_index, g_row_count )
            CALL fgl_set_arr_curr(g_ac) 
            IF tm.price='Y' THEN 
               CALL cl_set_comp_visible('p0,s0,s1,s2,s3',TRUE)
            ELSE
               CALL cl_set_comp_visible('p0,s0,s1,s2,s3',FALSE)
            END IF
            CALL cl_show_fld_cont()         
            CALL DIALOG.setArrayAttributes("s_img",g_img_attr) 
      END DISPLAY         

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

      ON ACTION aimq231_r
         LET g_action_choice="aimq231_r"
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


FUNCTION q110_b_fill()              
   DEFINE l_sql      STRING
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
   DEFINE l_wc          LIKE azp_file.azp01
   DEFINE l_azp02       LIKE azp_file.azp02  #free add
   DEFINE l_tlf907      LIKE tlf_file.tlf907
   DEFINE l_first       LIKE tlf_file.tlf06
   DEFINE l_day         LIKE type_file.num5
   DEFINE    lp_q0   LIKE img_file.img10, #期初
             lp_s0   LIKE ccc_file.ccc23,
             lp_r0   LIKE ccc_file.ccc23,
             lp_m0   LIKE ccc_file.ccc23,
             lp_q1   LIKE img_file.img19, #出
             lp_s1   LIKE ccc_file.ccc23,
             lp_r1   LIKE ccc_file.ccc23,
             lp_m1   LIKE ccc_file.ccc23,
             lp_q2   LIKE img_file.img10, #入 
             lp_s2   LIKE ccc_file.ccc23,
             lp_r2   LIKE ccc_file.ccc23,
             lp_m2   LIKE ccc_file.ccc23,
             lp_q3   LIKE img_file.img10, # 
             lp_s3   LIKE ccc_file.ccc23,
             lp_r3   LIKE ccc_file.ccc23,
             lp_m3   LIKE ccc_file.ccc23,    
             lg_q0   LIKE img_file.img10, #期初
             lg_s0   LIKE ccc_file.ccc23,
             lg_r0   LIKE ccc_file.ccc23,
             lg_m0   LIKE ccc_file.ccc23,
             lg_q1   LIKE img_file.img19, #出
             lg_s1   LIKE ccc_file.ccc23,
             lg_r1   LIKE ccc_file.ccc23,
             lg_m1   LIKE ccc_file.ccc23,
             lg_q2   LIKE img_file.img10, #入 
             lg_s2   LIKE ccc_file.ccc23,
             lg_r2   LIKE ccc_file.ccc23,
             lg_m2   LIKE ccc_file.ccc23,
             lg_q3   LIKE img_file.img10, # 
             lg_s3   LIKE ccc_file.ccc23,
             lg_r3   LIKE ccc_file.ccc23,
             lg_m3   LIKE ccc_file.ccc23    

  LET lp_q0 =0 LET lp_q1 =0 LET lp_q2 =0 LET lp_q3 =0 LET lp_s0 =0  LET lp_s1 =0 LET lp_s2 =0  LET lp_s3 =0          
  LET lp_r0 =0 LET lp_r1 =0 LET lp_r2 =0 LET lp_r3 =0 LET lp_m0 =0  LET lp_m1 =0 LET lp_m2 =0  LET lp_m3 =0

  LET lg_q0 =0 LET lg_q1 =0 LET lg_q2 =0 LET lg_q3 =0 LET lg_s0 =0  LET lg_s1 =0 LET lg_s2 =0  LET lg_m3 =0       
  LET lg_s3 =0 LET lg_r0 =0 LET lg_r1 =0 LET lg_r2 =0 LET lg_r3 =0  LET lg_m0 =0 LET lg_m1 =0  LET lg_m2 =0

  CALL g_img.clear()
  LET g_rec_b=0
  LET g_cnt = 1
  LET tok = base.StringTokenizer.create(g_azp01,"|")
  WHILE tok.hasMoreTokens()
     LET l_wc = tok.nextToken()
     LET l_dbs = ''
     SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01=l_wc  #free add
     SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01=l_wc
     LET l_dbs=s_dbstring(l_dbs CLIPPED)
     IF cl_null(l_dbs) THEN CONTINUE WHILE END IF  
     #free--mark--str--
     #LET l_sql = "SELECT NVL(SUM(tlf10*tlf60),0) FROM ",l_dbs CLIPPED,"tlf_file ",
     #            " WHERE tlf01=?  AND tlf902=?  AND tlf903=?  AND tlf904=?  AND tlf907=? ",
     #            "   AND tlf06 BETWEEN '",tm.bdate,"' AND  '",tm.edate,"' "
     #PREPARE tlf_pre FROM l_sql

     #LET l_sql = "SELECT NVL(SUM(tlf907*tlf10*tlf60),0) FROM ",l_dbs CLIPPED,"tlf_file ",
     #            " WHERE tlf01=?  AND tlf902=?  AND tlf903=?  AND tlf904=?   ",
     #            "   AND tlf06 BETWEEN ? AND ? "
     #PREPARE tlf_pre1 FROM l_sql

     #LET l_sql = "SELECT stb04 FROM ",l_dbs CLIPPED,"stb_file  ",
     #            " WHERE stb01=? and stb02=",tm.yy," and stb03=",tm.mm," "
     #PREPARE stb_pre FROM l_sql

     #LET l_sql = " SELECT '",l_wc,"',img02,img03,ime03,img04,imd02,img19,ima12,img01,ima02,ima021,img09, ",
     #            "        nvl(imk09,0),0,0,0,0,0,0,0,0,0,0,0, ",    
     #            "        0,0,0,0,0,0,0,0,0,0,0,0 ",
     #            "   FROM ",l_dbs CLIPPED,"img_file,",l_dbs CLIPPED,"imk_file,",l_dbs CLIPPED,"ima_file,",
     #            "        ",l_dbs CLIPPED,"imd_file,",l_dbs CLIPPED,"ime_file ",
     #            "  WHERE img01=ima01 AND img01=imk01(+) AND img02=imk02(+) AND img03=imk03(+) AND img04=imk04(+) ",
     #            "    AND img02=imd01(+) AND img02=ime01(+) AND img03=ime02(+) ",
     #            "    AND imk05(+)=",last_y," AND imk06(+)=",last_m," ",
     #            "    AND ", tm.wc CLIPPED
             #    "  ORDER BY img01,img02,img03,img04 "
     #free--add--str--
#     LET l_sql = " SELECT '",l_azp02,"',img02,img03,ime03,img04,imd02,img19,ima12,img01,ima02,ima021,img09, ",
#                 "        NVL(imk09,0),NVL(stb04,0),0,0,0,0, NVL(b.tlf_sum,0),0,0,0,0,0, ",    
#                 "        NVL(c.tlf_sum,0),0,0,0,0,0, 0,0,0,0,0,0 ",
#                 "   FROM ",l_dbs CLIPPED,"img_file,",l_dbs CLIPPED,"imk_file,",l_dbs CLIPPED,"ima_file ,",
#                 "        ",l_dbs CLIPPED,"stb_file,",l_dbs CLIPPED,"imd_file,",l_dbs CLIPPED,"ime_file ,",
#                 "        (SELECT tlf01,tlf902,tlf903,tlf904,SUM(tlf10*tlf60) tlf_sum ",
#                 "           FROM ",l_dbs CLIPPED,"tlf_file  ",
#                 "          WHERE tlf907=1 AND tlf06 BETWEEN '",tm.bdate,"' AND  '",tm.edate,"' ",
#                 "          GROUP BY tlf01,tlf902,tlf903,tlf904) b ,",
#                 "        (SELECT tlf01,tlf902,tlf903,tlf904,SUM(tlf10*tlf60) tlf_sum ",
#                 "           FROM ",l_dbs CLIPPED,"tlf_file  ",
#                 "          WHERE tlf907=-1 AND tlf06 BETWEEN '",tm.bdate,"' AND  '",tm.edate,"' ",
#                 "          GROUP BY tlf01,tlf902,tlf903,tlf904) c  ",
#                 "  WHERE img01=ima01 AND img01=imk01(+) AND img02=imk02(+) AND img03=imk03(+) AND img04=imk04(+) ",
#                 "    AND img02=imd01(+) AND img02=ime01(+) AND img03=ime02(+) ",
#                 "    AND img01=b.tlf01(+) AND img02=b.tlf902(+) AND img03=b.tlf903(+) AND img04=b.tlf904(+) ",
#                 "    AND img01=c.tlf01(+) AND img02=c.tlf902(+) AND img03=c.tlf903(+) AND img04=c.tlf904(+) ",
#                 "    AND img01=stb01(+) AND stb02(+)=",tm.yy," AND stb03(+)=",tm.mm," ",
#                 "    AND imk05(+)=",last_y," AND imk06(+)=",last_m," ",
#                 "    AND ", tm.wc CLIPPED
     LET l_sql = " SELECT '",l_azp02,"',img02,img03,ime03,img04,imd02,img19,ima12,img01,ima02,ima021,img09, ",
                 "        NVL(imk09,0),NVL(stb04,0),0,0,0,0, NVL(b.tlf_sum,0),0,0,0,0,0, ",    
                 "        NVL(c.tlf_sum,0),0,0,0,0,0, 0,0,0,0,0,0 ",
                 "   FROM ",l_dbs CLIPPED,"ima_file,",l_dbs CLIPPED,"img_file",
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
                 "    AND ", tm.wc CLIPPED
     #如果起始日期不为第一天,则期初数量要推算至起始日期
     LET l_day=DAY(tm.bdate) 
     IF l_day<>1 THEN 
        LET l_first = s_first(tm.bdate)
#        LET l_sql =
#                 " SELECT '",l_azp02,"',img02,img03,ime03,img04,imd02,img19,ima12,img01,ima02,ima021,img09, ",
#                 "        NVL(a.tlf_sum,0),NVL(stb04,0),0,0,0,0,NVL(b.tlf_sum,0),0,0,0,0,0, ",    
#                 "        NVL(c.tlf_sum,0),0,0,0,0,0,0,0,0,0,0,0 ",
#                 "   FROM ",l_dbs CLIPPED,"img_file,",l_dbs CLIPPED,"imk_file,",l_dbs CLIPPED,"ima_file,",
#                 "        ",l_dbs CLIPPED,"stb_file,",l_dbs CLIPPED,"imd_file,",l_dbs CLIPPED,"ime_file,",
#                 "        (SELECT tlf01,tlf902,tlf903,tlf904,SUM(tlf907*tlf10*tlf60) tlf_sum ",
#                 "           FROM ",l_dbs CLIPPED,"tlf_file  ",
#                 "          WHERE tlf06 BETWEEN '",l_first,"' AND '",tm.bdate,"' ",
#                 "          GROUP BY tlf01,tlf902,tlf903,tlf904) a ,",
#                 "        (SELECT tlf01,tlf902,tlf903,tlf904,SUM(tlf10*tlf60) tlf_sum ",
#                 "           FROM ",l_dbs CLIPPED,"tlf_file  ",
#                 "          WHERE tlf907=1 AND tlf06 tlf06 BETWEEN '",tm.bdate,"' AND  '",tm.edate,"' ",
#                 "          GROUP BY tlf01,tlf902,tlf903,tlf904) b ,",
#                 "        (SELECT tlf01,tlf902,tlf903,tlf904,SUM(tlf10*tlf60) tlf_sum ",
#                 "           FROM ",l_dbs CLIPPED,"tlf_file  ",
#                 "          WHERE tlf907=-1 AND tlf06 tlf06 BETWEEN '",tm.bdate,"' AND  '",tm.edate,"' ",
#                 "          GROUP BY tlf01,tlf902,tlf903,tlf904) c  ",
#                 "  WHERE img01=ima01 AND img01=imk01(+) AND img02=imk02(+) AND img03=imk03(+) AND img04=imk04(+) ",
#                 "    AND img02=imd01(+) AND img02=ime01(+) AND img03=ime02(+) ",
#                 "    AND img01=a.tlf01(+) AND img02=a.tlf902(+) AND img03=a.tlf903(+) AND img04=a.tlf904(+) ",
#                 "    AND img01=b.tlf01(+) AND img02=b.tlf902(+) AND img03=b.tlf903(+) AND img04=b.tlf904(+) ",
#                 "    AND img01=c.tlf01(+) AND img02=c.tlf902(+) AND img03=c.tlf903(+) AND img04=c.tlf904(+) ",
#                 "    AND img01=stb01(+) AND stb02(+)=",tm.yy," AND stb03(+)=",tm.mm," ",
#                 "    AND imk05(+)=",last_y," AND imk06(+)=",last_m," ",
#                 "    AND ", tm.wc CLIPPED   
         LET l_sql = " SELECT '",l_azp02,"',img02,img03,ime03,img04,imd02,img19,ima12,img01,ima02,ima021,img09, ",
                 #"        NVL(imk09,0),NVL(stb04,0),0,0,0,0, NVL(b.tlf_sum,0),0,0,0,0,0, ",        #TQC-D30072
                 #"        NVL(a.tlf_sum,0),NVL(stb04,0),0,0,0,0, NVL(b.tlf_sum,0),0,0,0,0,0, ",     #TQC-D30072 #MOD-D90033 mark
                 "        NVL(imk09,0)+NVL(a.tlf_sum,0),NVL(stb04,0),0,0,0,0, NVL(b.tlf_sum,0),0,0,0,0,0, ",     #MOD-D90033 
                 "        NVL(c.tlf_sum,0),0,0,0,0,0, 0,0,0,0,0,0 ",
                 "   FROM ",l_dbs CLIPPED,"ima_file,",l_dbs CLIPPED,"img_file",                 
                 #TQC-D30072--mark--str--
                 #MOD-D90033--remark--------
                 "        LEFT OUTER JOIN ",l_dbs CLIPPED,"imk_file ON img01=imk01",
                 "                                                 AND img02=imk02",
                 "                                                 AND img03=imk03",   
                 "                                                 AND img04=imk04",  
                 "                                                 AND imk05=",last_y,
                 "                                                 AND imk06=",last_m,
                 #MOD-D90033--remark--end---
                 #TQC-D30072--mark--end--                 
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
    #free--add--end--
             
    CASE WHEN tm.c='1' LET l_sql = l_sql CLIPPED," ORDER BY img01,img02,img03,img04 "
         WHEN tm.c='2' LET l_sql = l_sql CLIPPED," ORDER BY img02,img01,img03,img04 "
    END CASE
    
    PREPARE q110_pb1 FROM l_sql
    DECLARE q110_bcs1 CURSOR FOR q110_pb1
    FOREACH q110_bcs1 INTO g_img[g_cnt].*    
       #free--mark--str--   
       #IF cl_null(g_img[g_cnt].q0) THEN LET g_img[g_cnt].q0=0 END IF 
       #IF cl_null(g_img[g_cnt].s0) THEN LET g_img[g_cnt].s0=0 END IF
       #IF cl_null(g_img[g_cnt].n0) THEN LET g_img[g_cnt].n0=0 END IF
       #IF cl_null(g_img[g_cnt].r0) THEN LET g_img[g_cnt].r0=0 END IF
       #IF cl_null(g_img[g_cnt].m0) THEN LET g_img[g_cnt].m0=0 END IF
       #IF cl_null(g_img[g_cnt].p1) THEN LET g_img[g_cnt].p1=0 END IF
       #IF cl_null(g_img[g_cnt].s1) THEN LET g_img[g_cnt].s1=0 END IF
       #IF cl_null(g_img[g_cnt].n1) THEN LET g_img[g_cnt].n1=0 END IF
       #IF cl_null(g_img[g_cnt].r1) THEN LET g_img[g_cnt].r1=0 END IF
       #IF cl_null(g_img[g_cnt].m1) THEN LET g_img[g_cnt].m1=0 END IF
       #IF cl_null(g_img[g_cnt].p2) THEN LET g_img[g_cnt].p2=0 END IF
       #IF cl_null(g_img[g_cnt].s2) THEN LET g_img[g_cnt].s2=0 END IF
       #IF cl_null(g_img[g_cnt].n2) THEN LET g_img[g_cnt].n2=0 END IF
       #IF cl_null(g_img[g_cnt].r2) THEN LET g_img[g_cnt].r2=0 END IF
       #IF cl_null(g_img[g_cnt].m2) THEN LET g_img[g_cnt].m2=0 END IF
       #IF cl_null(g_img[g_cnt].q3) THEN LET g_img[g_cnt].q3=0 END IF
       #IF cl_null(g_img[g_cnt].p3) THEN LET g_img[g_cnt].p3=0 END IF
       #IF cl_null(g_img[g_cnt].s3) THEN LET g_img[g_cnt].s3=0 END IF
       #IF cl_null(g_img[g_cnt].n3) THEN LET g_img[g_cnt].n3=0 END IF
       #IF cl_null(g_img[g_cnt].r3) THEN LET g_img[g_cnt].r3=0 END IF
       #IF cl_null(g_img[g_cnt].m3) THEN LET g_img[g_cnt].m3=0 END IF
          

       # #如果起始日期不为第一天,则期初数量要推算至起始日期
       # LET l_day=DAY(tm.bdate) 
       # IF l_day<>1 THEN 
       #    LET l_first = s_first(tm.bdate)
       #    EXECUTE tlf_pre1 USING g_img[g_cnt].ima01,g_img[g_cnt].img02,g_img[g_cnt].img03,g_img[g_cnt].img04,l_first,tm.bdate INTO g_img[g_cnt].q0
       # END IF

       # EXECUTE stb_pre USING g_img[g_cnt].ima01 INTO g_img[g_cnt].p0
       # IF cl_null(g_img[g_cnt].p0) THEN LET g_img[g_cnt].p0=0 END IF

       # LET l_tlf907=1
       # EXECUTE tlf_pre USING g_img[g_cnt].ima01,g_img[g_cnt].img02,g_img[g_cnt].img03,g_img[g_cnt].img04,l_tlf907 INTO g_img[g_cnt].q1

       # LET l_tlf907=-1
       # EXECUTE tlf_pre USING g_img[g_cnt].ima01,g_img[g_cnt].img02,g_img[g_cnt].img03,g_img[g_cnt].img04,l_tlf907 INTO g_img[g_cnt].q2
       # IF cl_null(g_img[g_cnt].q1) THEN LET g_img[g_cnt].q1=0 END IF
       # IF cl_null(g_img[g_cnt].q2) THEN LET g_img[g_cnt].q2=0 END IF
       #free--mark--end--
        IF tm.viewall='N' AND g_img[g_cnt].q0 = 0 AND g_img[g_cnt].q1 = 0 AND g_img[g_cnt].q2 = 0 AND g_img[g_cnt].q3 = 0 THEN
           CONTINUE FOREACH
        END IF
 
        LET g_img[g_cnt].s0=g_img[g_cnt].q0*g_img[g_cnt].p0
        LET g_img[g_cnt].s1=g_img[g_cnt].q1*g_img[g_cnt].p0
        LET g_img[g_cnt].s2=g_img[g_cnt].q2*g_img[g_cnt].p0 
        LET g_img[g_cnt].q3=g_img[g_cnt].q0+g_img[g_cnt].q1-g_img[g_cnt].q2
        LET g_img[g_cnt].s3=g_img[g_cnt].q3*g_img[g_cnt].p0  

        # ---抓取实际单价、成本、差异--
        LET lg_q0=g_img[g_cnt].q0+lg_q0
        LET lg_q1=g_img[g_cnt].q1+lg_q1
        LET lg_q2=g_img[g_cnt].q2+lg_q2
        LET lg_q3=g_img[g_cnt].q3+lg_q3
        LET lg_s0=g_img[g_cnt].s0+lg_s0 
        LET lg_s1=g_img[g_cnt].s1+lg_s1
        LET lg_s2=g_img[g_cnt].s2+lg_s2 
        LET lg_s3=g_img[g_cnt].s3+lg_s3 

        IF tm.total='Y' AND tm.c='1' AND l_ima01 IS NOT NULL THEN
           IF g_img[g_cnt].ima01<> l_ima01 THEN 
              LET g_img[g_cnt+1].*=g_img[g_cnt].*
              INITIALIZE g_img[g_cnt].* TO NULL
              LET g_img[g_cnt].ima01=l_ima01
              LET g_img[g_cnt].ima02=g_img[g_cnt-1].ima02   #free add
              LET g_img[g_cnt].ima021=g_img[g_cnt-1].ima021 #free add
              LET g_img[g_cnt].azp02='合计'
              LET g_img[g_cnt].q0=lp_q0 
              LET g_img[g_cnt].q1=lp_q1 
              LET g_img[g_cnt].q2=lp_q2            
              LET g_img[g_cnt].q3=lp_q3            
              LET g_img[g_cnt].s0=lp_s0           
              LET g_img[g_cnt].s1=lp_s1           
              LET g_img[g_cnt].s2=lp_s2           
              LET g_img[g_cnt].s3=lp_s3            

              LET lp_q0 =g_img[g_cnt+1].q0
              LET lp_q1 =g_img[g_cnt+1].q1
              LET lp_q2 =g_img[g_cnt+1].q2           
              LET lp_q3 =g_img[g_cnt+1].q3           
              LET lp_s0 =g_img[g_cnt+1].s0          
              LET lp_s1 =g_img[g_cnt+1].s1         
              LET lp_s2 =g_img[g_cnt+1].s2          
              LET lp_s3 =g_img[g_cnt+1].s3 
              IF g_img[g_cnt].q1 <> 0 THEN 
                 LET g_img_attr[g_cnt].q1 = "green reverse "
              END IF 
              IF g_img[g_cnt].s2 <> 0 THEN 
                 LET g_img_attr[g_cnt].s2 = "yellow reverse "
              END IF 
              LET g_cnt=g_cnt+1
           ELSE 
              LET lp_q0=lp_q0+g_img[g_cnt].q0 
              LET lp_q1=lp_q1+g_img[g_cnt].q1             
              LET lp_q2=lp_q2+g_img[g_cnt].q2 
              LET lp_q3=lp_q3+g_img[g_cnt].q3 
              LET lp_s0=lp_s0+g_img[g_cnt].s0 
              LET lp_s1=lp_s1+g_img[g_cnt].s1 
              LET lp_s2=lp_s2+g_img[g_cnt].s2 
              LET lp_s3=lp_s3+g_img[g_cnt].s3 
           END IF 
        END IF
        IF tm.total='Y' AND tm.c='2' AND l_img02 IS NOT NULL THEN
           IF g_img[g_cnt].img02<> l_img02 THEN 
              LET g_img[g_cnt+1].*=g_img[g_cnt].*
              INITIALIZE g_img[g_cnt].* TO NULL
              LET g_img[g_cnt].img02=l_img02
              LET g_img[g_cnt].imd02=g_img[g_cnt-1].imd02  #free add
              #SELECT imd02 INTO g_img[g_cnt].imd02 FROM imd_file WHERE imd01=g_img[g_cnt].img02
              LET g_img[g_cnt].azp02='合计'
              LET g_img[g_cnt].q0=lp_q0 
              LET g_img[g_cnt].q1=lp_q1 
              LET g_img[g_cnt].q2=lp_q2            
              LET g_img[g_cnt].q3=lp_q3            
              LET g_img[g_cnt].s0=lp_s0           
              LET g_img[g_cnt].s1=lp_s1           
              LET g_img[g_cnt].s2=lp_s2           
              LET g_img[g_cnt].s3=lp_s3            

              LET lp_q0 =g_img[g_cnt+1].q0
              LET lp_q1 =g_img[g_cnt+1].q1
              LET lp_q2 =g_img[g_cnt+1].q2           
              LET lp_q3 =g_img[g_cnt+1].q3           
              LET lp_s0 =g_img[g_cnt+1].s0          
              LET lp_s1 =g_img[g_cnt+1].s1         
              LET lp_s2 =g_img[g_cnt+1].s2          
              LET lp_s3 =g_img[g_cnt+1].s3 
              IF g_img[g_cnt].q1 <> 0 THEN 
                 LET g_img_attr[g_cnt].q1 = "green reverse "
              END IF 
              IF g_img[g_cnt].s2 <> 0 THEN 
                 LET g_img_attr[g_cnt].s2 = "yellow reverse "
              END IF 
              LET g_cnt=g_cnt+1
           ELSE 
              LET lp_q0=lp_q0+g_img[g_cnt].q0 
              LET lp_q1=lp_q1+g_img[g_cnt].q1             
              LET lp_q2=lp_q2+g_img[g_cnt].q2 
              LET lp_q3=lp_q3+g_img[g_cnt].q3 
              LET lp_s0=lp_s0+g_img[g_cnt].s0 
              LET lp_s1=lp_s1+g_img[g_cnt].s1 
              LET lp_s2=lp_s2+g_img[g_cnt].s2 
              LET lp_s3=lp_s3+g_img[g_cnt].s3 
           END IF 
        END IF
        IF tm.total='Y' AND (l_ima01 IS NULL OR l_img02 IS NULL) THEN 
              LET lp_q0=lp_q0+g_img[g_cnt].q0 
              LET lp_q1=lp_q1+g_img[g_cnt].q1             
              LET lp_q2=lp_q2+g_img[g_cnt].q2 
              LET lp_q3=lp_q3+g_img[g_cnt].q3 
              LET lp_s0=lp_s0+g_img[g_cnt].s0 
              LET lp_s1=lp_s1+g_img[g_cnt].s1 
              LET lp_s2=lp_s2+g_img[g_cnt].s2 
              LET lp_s3=lp_s3+g_img[g_cnt].s3 
        END IF
        LET l_ima01= g_img[g_cnt].ima01
        LET l_img02= g_img[g_cnt].img02
   
       CALL cl_digcut(g_img[g_cnt].s0,2) RETURNING g_img[g_cnt].s0
       CALL cl_digcut(g_img[g_cnt].r0,2) RETURNING g_img[g_cnt].r0
       CALL cl_digcut(g_img[g_cnt].m0,2) RETURNING g_img[g_cnt].m0
       CALL cl_digcut(g_img[g_cnt].s1,2) RETURNING g_img[g_cnt].s1
       CALL cl_digcut(g_img[g_cnt].r1,2) RETURNING g_img[g_cnt].r1
       CALL cl_digcut(g_img[g_cnt].m1,2) RETURNING g_img[g_cnt].m1
       CALL cl_digcut(g_img[g_cnt].s2,2) RETURNING g_img[g_cnt].s2
       CALL cl_digcut(g_img[g_cnt].r2,2) RETURNING g_img[g_cnt].r2
       CALL cl_digcut(g_img[g_cnt].m2,2) RETURNING g_img[g_cnt].m2
       CALL cl_digcut(g_img[g_cnt].s3,2) RETURNING g_img[g_cnt].s3
       CALL cl_digcut(g_img[g_cnt].r3,2) RETURNING g_img[g_cnt].r3
       CALL cl_digcut(g_img[g_cnt].m3,2) RETURNING g_img[g_cnt].m3

       IF g_img[g_cnt].q1 <> 0 THEN 
          LET g_img_attr[g_cnt].q1 = "green reverse "
       END IF 
       IF g_img[g_cnt].s2 <> 0 THEN 
          LET g_img_attr[g_cnt].s2 = "yellow reverse "
       END IF 
        LET g_cnt = g_cnt + 1
        IF g_cnt > 20000  THEN   
           CALL cl_err( '', 9035, 0 )
           #EXIT FOREACH #free mark
           EXIT WHILE    #free add
        END IF 
        DISPLAY BY NAME g_img[g_cnt].img02
    END FOREACH
 END WHILE
 CALL g_img.deleteElement(g_cnt)  #free add
 LET g_cnt = g_cnt-1              #free add
 IF g_cnt<=0 THEN RETURN END IF   #free add
 IF tm.total='Y'  THEN 
    #free--modify--str--
    #LET g_img[g_cnt].ima01=l_ima01
    LET g_cnt = g_cnt + 1
    IF tm.c = '1' THEN
       LET g_img[g_cnt].ima01=l_ima01
       LET g_img[g_cnt].ima02=g_img[g_cnt-1].ima02   #free add
       LET g_img[g_cnt].ima021=g_img[g_cnt-1].ima021 #free add
    ELSE 
       LET g_img[g_cnt].img02=l_img02
       LET g_img[g_cnt].imd02=g_img[g_cnt-1].imd02
    END IF 
    #free--modify--end--
    LET g_img[g_cnt].azp02='合计'
    LET g_img[g_cnt].q0=lp_q0 
    LET g_img[g_cnt].q1=lp_q1 
    LET g_img[g_cnt].q2=lp_q2            
    LET g_img[g_cnt].q3=lp_q3            
    LET g_img[g_cnt].s0=lp_s0           
    LET g_img[g_cnt].s1=lp_s1           
    LET g_img[g_cnt].s2=lp_s2           
    LET g_img[g_cnt].s3=lp_s3            
 END IF
    LET g_img[g_cnt+1].azp02='总计'           
    LET g_img[g_cnt+1].q0=lg_q0
    LET g_img[g_cnt+1].q1=lg_q1
    LET g_img[g_cnt+1].q2=lg_q2           
    LET g_img[g_cnt+1].q3=lg_q3           
    LET g_img[g_cnt+1].s0=lg_s0           
    LET g_img[g_cnt+1].s1=lg_s1           
    LET g_img[g_cnt+1].s2=lg_s2           
    LET g_img[g_cnt+1].s3=lg_s3           
    LET g_rec_b=g_cnt+1

    CALL cl_digcut(g_img[g_cnt].s0,2) RETURNING g_img[g_cnt].s0
    CALL cl_digcut(g_img[g_cnt].s1,2) RETURNING g_img[g_cnt].s1
    CALL cl_digcut(g_img[g_cnt].s2,2) RETURNING g_img[g_cnt].s2
    CALL cl_digcut(g_img[g_cnt].s3,2) RETURNING g_img[g_cnt].s3
    CALL cl_digcut(g_img[g_cnt+1].s0,2) RETURNING g_img[g_cnt+1].s0
    CALL cl_digcut(g_img[g_cnt+1].s1,2) RETURNING g_img[g_cnt+1].s1
    CALL cl_digcut(g_img[g_cnt+1].s2,2) RETURNING g_img[g_cnt+1].s2
    CALL cl_digcut(g_img[g_cnt+1].s3,2) RETURNING g_img[g_cnt+1].s3
    IF g_img[g_cnt].q1 <> 0 THEN 
       LET g_img_attr[g_cnt].q1 = "green reverse "
    END IF 
    IF g_img[g_cnt].s2 <> 0 THEN 
       LET g_img_attr[g_cnt].s2 = "yellow reverse "
    END IF 
    IF g_img[g_cnt+1].q1 <> 0 THEN 
       LET g_img_attr[g_cnt+1].q1 = "green reverse "
    END IF 
    IF g_img[g_cnt+1].s2 <> 0 THEN 
       LET g_img_attr[g_cnt+1].s2 = "yellow reverse "
    END IF 
    DISPLAY g_rec_b TO FORMONLY.cnt
END FUNCTION
