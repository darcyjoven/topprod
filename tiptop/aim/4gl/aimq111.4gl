# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: aimq111
# Descriptions...: 库存进出日异动查询
# Date & Author..: 12/10/30 By zm  #No.FUN-C90076
# Modify.........: No.TQC-CC0128 12/12/26 By xujing 補過單
# Modify.........: No.MOD-DA0201 13/10/29 By fengmy 單身只有單行數據時，跳出循環時查值
# Modify.........: No.MOD-DB0080 13/11/12 By fengmy imk_pre傳值錯誤

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
       i,g_yy,g_mm,g_dd      LIKE type_file.num5,   
       last_y,last_m	LIKE type_file.num5,   
       m_bdate	        LIKE type_file.dat     
    DEFINE g_bdate,g_edate LIKE type_file.dat
    DEFINE g_img       DYNAMIC ARRAY OF RECORD
                azp02   LIKE azp_file.azp01,
                img02   LIKE img_file.img02,
                img03   LIKE img_file.img03,
                ime03   LIKE ime_file.ime03,
                img04   LIKE img_file.img04,
                imd02   LIKE imd_file.imd02, 
                img19   LIKE img_file.img19, 
                ima12   LIKE ima_file.ima12,
                ima01   LIKE ima_file.ima01,
                ima02   LIKE ima_file.ima02,
                ima021   LIKE ima_file.ima021,
                img09   LIKE img_file.img09, 
                q0   LIKE img_file.img10,
                p0   LIKE ccc_file.ccc23,
                s0   LIKE ccc_file.ccc23,
                d0   LIKE img_file.img10,
                d1   LIKE img_file.img10,
                d2   LIKE img_file.img10,
                d3   LIKE img_file.img10, #出
                d4   LIKE img_file.img10,
                d5   LIKE img_file.img10,
                d6   LIKE img_file.img10,
                d7   LIKE img_file.img10,
                d8   LIKE img_file.img10,
                d9   LIKE img_file.img10,
                d10   LIKE img_file.img10,
                d11   LIKE img_file.img10,
                d12   LIKE img_file.img10,
                d13   LIKE img_file.img10,
                d14   LIKE img_file.img10,
                d15   LIKE img_file.img10,
                d16   LIKE img_file.img10,
                d17   LIKE img_file.img10,
                d18   LIKE img_file.img10,
                d19   LIKE img_file.img10,
                d20   LIKE img_file.img10,
                d21   LIKE img_file.img10,
                d22   LIKE img_file.img10,
                d23   LIKE img_file.img10,
                d24   LIKE img_file.img10,
                d25   LIKE img_file.img10,
                d26   LIKE img_file.img10,
                d27   LIKE img_file.img10,
                d28   LIKE img_file.img10,
                d29   LIKE img_file.img10,
                d30   LIKE img_file.img10,
                d31   LIKE img_file.img10,
                d32   LIKE img_file.img10,
                d33   LIKE img_file.img10,
                d34   LIKE img_file.img10,
                d35   LIKE img_file.img10,
                d36   LIKE img_file.img10,
                d37   LIKE img_file.img10,
                d38   LIKE img_file.img10,
                d39   LIKE img_file.img10,
                d40   LIKE img_file.img10,
                d41   LIKE img_file.img10,
                d42   LIKE img_file.img10,
                d43   LIKE img_file.img10,
                d44   LIKE img_file.img10,
                d45   LIKE img_file.img10,
                d46   LIKE img_file.img10,
                d47   LIKE img_file.img10,
                d48   LIKE img_file.img10,
                d49   LIKE img_file.img10,
                d50   LIKE img_file.img10,
                d51   LIKE img_file.img10,
                d52   LIKE img_file.img10,
                d53   LIKE img_file.img10,
                d54   LIKE img_file.img10,
                d55   LIKE img_file.img10,
                d56   LIKE img_file.img10,
                d57   LIKE img_file.img10,
                d58   LIKE img_file.img10,
                d59   LIKE img_file.img10,
                d60   LIKE img_file.img10,
                d61   LIKE img_file.img10,
                q3   LIKE img_file.img10,
                p3   LIKE ccc_file.ccc23,
                s3   LIKE ccc_file.ccc23,
                n3   LIKE ccc_file.ccc23,
                r3   LIKE ccc_file.ccc23,
                m3   LIKE ccc_file.ccc23
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

    OPEN WINDOW aimq111_w AT p_row,p_col
         WITH FORM "aim/42f/aimq111" 
          ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()
    IF NOT cl_null(g_argv1) THEN CALL q111_q() END IF
   
    CALL cl_set_comp_visible('p3,total,c',FALSE)
    CALL q111_menu()
    CLOSE WINDOW aimq111_w
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time      #計算使用時間 (退出使間) 
             
END MAIN

#QBE 查詢資料
FUNCTION q111_cs()
DEFINE  l_cnt        LIKE type_file.num5    
DEFINE  lc_qbe_sn    LIKE gbm_file.gbm01  
DEFINE  l_azp06      LIKE azp_file.azp06    

   INITIALIZE tm.* TO NULL
   CALL g_img.clear()
   CLEAR FORM
   LET tm.price = 'Y'
   LET tm.total = 'N'
   LET tm.viewall = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1' 
   LET tm.c = '1' 
   LET g_row_count = 0 
   LET g_rec_b = 0
#  SELECT trunc(sysdate,'MM') INTO tm.bdate FROM DUAL
   SELECT (YEAR(sysdate)||'/'||Month(sysdate)||'/01') INTO tm.bdate FROM DUAL #FUN-C90076 xj
   CALL  s_azn01(g_yy,g_mm)  RETURNING  g_bdate,g_edate
   LET tm.edate = g_edate  
   LET tm.yy=YEAR(tm.bdate)
   LET tm.mm=MONTH(tm.bdate)

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
 
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT CONSTRUCT
      ON ACTION qbe_select
         CALL cl_qbe_select()    
  END CONSTRUCT
 
  IF INT_FLAG THEN
     RETURN 
  END IF

  INPUT BY NAME tm.bdate,tm.price,tm.viewall,
                tm.yy,tm.mm,tm.total,tm.c WITHOUT DEFAULTS
      BEFORE INPUT
         CALL cl_qbe_display_condition(lc_qbe_sn)
         IF NOT cl_null(tm.bdate) THEN
            LET g_yy=YEAR(tm.bdate)
            LET g_mm=MONTH(tm.bdate)
            LET g_dd=DAY(tm.bdate)
            IF g_dd='1' THEN
               CALL s_azn01(g_yy,g_mm) RETURNING  g_bdate,g_edate   
               LET tm.edate = g_edate DISPLAY BY NAME tm.edate
               DISPLAY BY NAME tm.edate
            END IF 
         END IF 

         IF NOT cl_null(tm.p)THEN 
     #        LET tm.total='Y'
             DISPLAY BY NAME tm.total
         END IF  
         CALL cl_set_comp_entry('c',tm.total='Y')


      AFTER FIELD bdate
         LET g_yy=YEAR(tm.bdate)
         LET g_mm=MONTH(tm.bdate)
         LET g_dd=DAY(tm.bdate)
         IF g_dd<>'1' THEN 
             CALL cl_err(tm.bdate,'aim-613',0)
             NEXT FIELD bdate 
         END IF 
         CALL s_azn01(g_yy,g_mm) RETURNING  g_bdate,g_edate
         LET tm.edate = g_edate DISPLAY BY NAME tm.edate
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

    
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
               
   CONSTRUCT tm.wc ON img02,img03,img04,img19,ima12,ima01,ima02,ima021,img09 
                 FROM s_img[1].b_img02,s_img[1].b_img03,s_img[1].b_img04,
                      s_img[1].b_img19,s_img[1].b_ima12,s_img[1].b_ima01,
                      s_img[1].b_ima02,s_img[1].b_ima021,s_img[1].b_img09

      BEFORE CONSTRUCT
             CALL cl_qbe_init()
 
      ON ACTION locale
          CALL cl_show_fld_cont()  
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
#              WHEN INFIELD(ima06)
#                CALL cl_init_qry_var()
#                LET g_qryparam.form = "q_imz"
#                LET g_qryparam.state = "c"
#                CALL cl_create_qry()RETURNING g_qryparam.multiret
#                DISPLAY g_qryparam.multiret TO ima06
#                NEXT FIELD ima06
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
 
      ON ACTION exit
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
   END WHILE
   
   CALL s_azm(g_yy,g_mm) RETURNING g_chr,m_bdate,i
   LET last_y = g_yy LET last_m = g_mm - 1
   IF last_m = 0 THEN LET last_y = last_y - 1 LET last_m = 12 END IF
   
 #  CALL q111()
   CALL q111_b_fill() #單身

END FUNCTION

FUNCTION q111_menu()
DEFINE l_cnt LIKE type_file.num5

   WHILE TRUE
      CALL q111_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q111_q()
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

FUNCTION q111_q()

    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    DISPLAY '   ' TO FORMONLY.cn2
    CALL q111_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    DISPLAY g_row_count TO FORMONLY.cn2
END FUNCTION

FUNCTION q111_show()
   CALL q111_b_fill() #單身
   CALL cl_show_fld_cont()                  
END FUNCTION


FUNCTION q111_bp(p_ud)
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
   DISPLAY ARRAY g_img TO s_img.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         CALL fgl_set_arr_curr(g_ac) 
         IF tm.price='Y' THEN 
            CALL cl_set_comp_visible('p0,s0,s3,n3,r3,m3',TRUE)
         ELSE
            CALL cl_set_comp_visible('p0,s0,s3,n3,r3,m3',FALSE)
         END IF
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


      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY

      ON ACTION accept
#        LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 		
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON ACTION aimq231_r
         LET g_action_choice="aimq231_r"
         EXIT DISPLAY

      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about       
         CALL cl_about()       

      AFTER DISPLAY
         CONTINUE DISPLAY

     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

#FUN-C90076---mark---xj
#FUNCTION q111()
#   DEFINE tok           base.StringTokenizer
#   DEFINE l_dbs         LIKE azp_file.azp03
#   DEFINE l_plant       LIKE azp_file.azp01
#   DEFINE l_sql      STRING
#     
#   DROP TABLE img_temp
#   CREATE TABLE img_temp(azp01   VARCHAR(10),    #营运中心
#                         azp03   VARCHAR(20),    #db
#                         img01   VARCHAR(40),    #料号
#                         img02   VARCHAR(10),    #仓库
#                         img03   VARCHAR(10),    #库位
#                         img04   VARCHAR(24),    #批号
#                         tlf06   DATE,           #异动日期
#                         tlf907  DEC(5,0),       #异动码
#                         tlf10   DEC(15,3))      #数量
#   LET tok = base.StringTokenizer.create(g_azp01,"|")
#   WHILE tok.hasMoreTokens()
#     LET l_plant = tok.nextToken()
#     LET l_dbs = ''
#     SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01=l_plant
#     LET l_dbs=s_dbstring(l_dbs CLIPPED)
#     IF cl_null(l_dbs) THEN CONTINUE WHILE END IF     
# 
#     LET l_sql = "INSERT INTO img_temp ",
#                 "SELECT '",l_plant,"','",l_dbs,"',img01,img02,img03,img04,tlf06,tlf907,NVL(SUM(tlf10*tlf60),0) ",
#                 "  FROM ",l_dbs CLIPPED,"img_file,",l_dbs CLIPPED,"tlf_file,",l_dbs CLIPPED,"ima_file ",
#                 " WHERE img01=tlf01(+) AND img02=tlf902(+) AND img03=tlf903(+) AND img04=tlf904(+) AND img01=ima01 ",
#                 "   AND tlf06 BETWEEN '",tm.bdate,"' AND  '",tm.edate,"' ",
#                 "   AND ", tm.wc CLIPPED,
#                 " GROUP BY img01,img02,img03,img04,tlf06,tlf907 "
#     PREPARE img_pre FROM l_sql
#     EXECUTE img_pre 
#   END WHILE
#
#END FUNCTION
#FUN-C90076---mark---xj

FUNCTION q111_b_fill()              
   DEFINE l_sql      STRING
   DEFINE l_flag     LIKE type_file.num5,     
          l_factor   LIKE ima_file.ima31_fac,  
          l_tlf10,l_qty,l_qty1    LIKE tlf_file.tlf10,
          l_tlf06    LIKE tlf_file.tlf06,
          l_ima01    LIKE ima_file.ima01, 
          l_img02    LIKE img_file.img02,  
          l_ima12    LIKE ima_file.ima12, 
          l_img03    LIKE img_file.img03,  
          l_img04    LIKE img_file.img04,  
          l_img19    LIKE img_file.img19   
   DEFINE s_imd02    LIKE imd_file.imd02,
          s_ime03    LIKE ime_file.ime03,
          s_ima01    LIKE ima_file.ima01, 
          s_img02    LIKE img_file.img02,  
          s_ima12    LIKE ima_file.ima12, 
          s_ima02    LIKE ima_file.ima02, 
          s_ima021   LIKE ima_file.ima021, 
          s_img03    LIKE img_file.img03,  
          s_img04    LIKE img_file.img04,  
          s_img09    LIKE img_file.img09,
          s_img19    LIKE img_file.img19   
   DEFINE t_imd02    LIKE imd_file.imd02,
          t_ime03    LIKE ime_file.ime03,
          t_ima01    LIKE ima_file.ima01, 
          t_img02    LIKE img_file.img02,  
          t_ima12    LIKE ima_file.ima12, 
          t_ima02    LIKE ima_file.ima02, 
          t_ima021   LIKE ima_file.ima021, 
          t_img03    LIKE img_file.img03,  
          t_img04    LIKE img_file.img04,  
          t_img09    LIKE img_file.img09,
          t_img19    LIKE img_file.img19   
   DEFINE tok           base.StringTokenizer
   DEFINE l_dbs         LIKE azp_file.azp03
   DEFINE l_wc          LIKE azp_file.azp01
   DEFINE l_tlf907      LIKE tlf_file.tlf907
   DEFINE l_plant       LIKE azp_file.azp01
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
  display time  #xj add
  WHILE tok.hasMoreTokens()
     LET l_plant = tok.nextToken()
     LET l_dbs = ''
     SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01=l_plant
     LET l_dbs=s_dbstring(l_dbs CLIPPED)
     IF cl_null(l_dbs) THEN CONTINUE WHILE END IF     

     LET l_qty=0 
     LET l_sql = "SELECT stb04 FROM ",l_dbs CLIPPED,"stb_file  ",
                 " WHERE stb01=? and stb02=",tm.yy," and stb03=",tm.mm," "
     PREPARE stb_pre FROM l_sql

     LET l_sql = "SELECT imk09 FROM ",l_dbs CLIPPED,"imk_file  ",
                 " WHERE imk01=? AND imk02=? AND imk03=? AND imk04=? AND imk05=",last_y," AND imk06=",last_m," "
     PREPARE imk_pre FROM l_sql
     
     LET l_sql = "SELECT ccc23 FROM ",l_dbs CLIPPED,"ccc_file  ",
                 " WHERE ccc01=? AND ccc02=",tm.yy," AND ccc03=",tm.mm," "   
     PREPARE ccc_pre FROM l_sql

     IF tm.viewall='Y' THEN    #两SQL的区别是内/外关联,提升效率
#        LET l_sql = "SELECT tlf06,tlf907,NVL(SUM(tlf10*tlf60),0),'",l_plant,"',img02,img03,ime03,img04,imd02,img19,ima12,img01,ima02,ima021,img09 ",
#                    "  FROM ",l_dbs CLIPPED,"img_file,",l_dbs CLIPPED,"tlf_file,",l_dbs CLIPPED,"ima_file, ",
#                    "  ",l_dbs CLIPPED,"imd_file,",l_dbs CLIPPED,"ime_file ",
#                    " WHERE img01=tlf01(+) AND img02=tlf902(+) AND img03=tlf903(+) AND img04=tlf904(+) AND img01=ima01 ",
#                    "   AND img02=imd01(+) AND img02=ime01(+) AND img03=ime02(+) ",
#                    "   AND tlf06(+) BETWEEN '",tm.bdate,"' AND  '",tm.edate,"' ",
#                    "   AND ", tm.wc CLIPPED,
#                    " GROUP BY tlf06,tlf907,img02,img03,ime03,img04,imd02,img19,ima12,img01,ima02,ima021,img09 ",
#                    " ORDER BY img01,img02,img03,img04,tlf06 "
        LET l_sql = "SELECT tlf06,tlf907,NVL(SUM(tlf10*tlf60),0),'",l_plant,"',img02,img03,ime03,img04,imd02,img19,ima12,img01,ima02,ima021,img09 ",
                    "  FROM ",l_dbs CLIPPED,"ima_file,",l_dbs CLIPPED,"img_file",
                    "       LEFT OUTER JOIN ",l_dbs CLIPPED,"tlf_file ON img01=tlf01",
                    "                                                AND img02=tlf902",
                    "                                                AND img03=tlf903",
                    "                                                AND img04=tlf904",
                    "                                                AND tlf06 BETWEEN '",tm.bdate,"' AND  '",tm.edate,"'",
                    "       LEFT OUTER JOIN ",l_dbs CLIPPED,"imd_file ON img02=imd01",
                    "       LEFT OUTER JOIN ",l_dbs CLIPPED,"ime_file ON img02=ime01",
                    "                                                AND img03=ime02",
                    " WHERE img01=ima01",
                    "   AND ",tm.wc CLIPPED,
                    " GROUP BY tlf06,tlf907,img02,img03,ime03,img04,imd02,img19,ima12,img01,ima02,ima021,img09 ",
                    " ORDER BY img01,img02,img03,img04,tlf06 "
     ELSE
#        LET l_sql = "SELECT tlf06,tlf907,NVL(SUM(tlf10*tlf60),0),'",l_plant,"',img02,img03,ime03,img04,imd02,img19,ima12,img01,ima02,ima021,img09 ",
#                    "  FROM ",l_dbs CLIPPED,"img_file,",l_dbs CLIPPED,"tlf_file,",l_dbs CLIPPED,"ima_file, ",
#                    "  ",l_dbs CLIPPED,"imd_file,",l_dbs CLIPPED,"ime_file ",
#                    " WHERE img01=tlf01 AND img02=tlf902 AND img03=tlf903 AND img04=tlf904 AND img01=ima01 ",
#                    "   AND img02=imd01(+) AND img02=ime01(+) AND img03=ime02(+) ",
#                    "   AND tlf06 BETWEEN '",tm.bdate,"' AND  '",tm.edate,"' ",
#                    "   AND ", tm.wc CLIPPED,
#                    " GROUP BY tlf06,tlf907,img02,img03,ime03,img04,imd02,img19,ima12,img01,ima02,ima021,img09 ",
#                    " ORDER BY img01,img02,img03,img04,tlf06 "
        LET l_sql = "SELECT tlf06,tlf907,NVL(SUM(tlf10*tlf60),0),'",l_plant,"',img02,img03,ime03,img04,imd02,img19,ima12,img01,ima02,ima021,img09 ",
                    "  FROM ",l_dbs CLIPPED,"ima_file,",l_dbs CLIPPED,"tlf_file,",l_dbs CLIPPED,"img_file",
                    "       LEFT OUTER JOIN ",l_dbs CLIPPED,"imd_file ON img02=imd01",
                    "       LEFT OUTER JOIN ",l_dbs CLIPPED,"ime_file ON img02=ime01",
                    "                                                AND img03=ime02",
                    " WHERE img01=ima01 AND img01=tlf01 AND img02=tlf902 AND img03=tlf903 AND img04=tlf904",
                    "   AND tlf06 BETWEEN '",tm.bdate,"' AND  '",tm.edate,"' ",
                    "   AND ",tm.wc CLIPPED,
                    " GROUP BY tlf06,tlf907,img02,img03,ime03,img04,imd02,img19,ima12,img01,ima02,ima021,img09 ",
                    " ORDER BY img01,img02,img03,img04,tlf06 "
     END IF
     PREPARE q111_pb1 FROM l_sql
     DECLARE q111_bcs1 CURSOR FOR q111_pb1
     FOREACH q111_bcs1 INTO l_tlf06,l_tlf907,l_tlf10,g_img[g_cnt].azp02,g_img[g_cnt].img02,g_img[g_cnt].img03,g_img[g_cnt].ime03,g_img[g_cnt].img04,
                            g_img[g_cnt].imd02,g_img[g_cnt].img19,g_img[g_cnt].ima12,g_img[g_cnt].ima01,g_img[g_cnt].ima02,g_img[g_cnt].ima021,
                            g_img[g_cnt].img09
        IF l_ima01 IS NOT NULL THEN 
           IF g_img[g_cnt].ima01<>l_ima01 OR g_img[g_cnt].img02<>l_img02 OR g_img[g_cnt].img03<>l_img03 OR g_img[g_cnt].img04<>l_img04  THEN 
              LET s_img02=g_img[g_cnt].img02   LET s_img03=g_img[g_cnt].img03   LET s_ime03=g_img[g_cnt].ime03  LET s_img04=g_img[g_cnt].img04
              LET s_imd02=g_img[g_cnt].imd02   LET s_img19=g_img[g_cnt].img19   LET s_ima12=g_img[g_cnt].ima12  LET s_ima01=g_img[g_cnt].ima01
              LET s_ima02=g_img[g_cnt].ima02   LET s_ima021=g_img[g_cnt].ima021   LET s_img09=g_img[g_cnt].img09  
              LET g_cnt = g_cnt + 1    
              LET g_img[g_cnt].img02=s_img02   LET g_img[g_cnt].img03=s_img03   LET g_img[g_cnt].ime03=s_ime03  LET g_img[g_cnt].img04=s_img04
              LET g_img[g_cnt].imd02=s_imd02   LET g_img[g_cnt].img19=s_img19   LET g_img[g_cnt].ima12=s_ima12  LET g_img[g_cnt].ima01=s_ima01
              LET g_img[g_cnt].ima02=s_ima02   LET g_img[g_cnt].ima021=s_ima021   LET g_img[g_cnt].img09=s_img09   LET g_img[g_cnt].azp02=l_plant
              EXECUTE stb_pre USING g_img[g_cnt].ima01 INTO g_img[g_cnt].p0    #计划单价
              IF cl_null(g_img[g_cnt].p0) THEN LET g_img[g_cnt].p0=0 END IF
              LET g_img[g_cnt].p3 = g_img[g_cnt].p0                            #计划单价

              EXECUTE ccc_pre USING g_img[g_cnt].ima01 INTO g_img[g_cnt].n3    #实际单价
              IF cl_null(g_img[g_cnt].n3) THEN LET g_img[g_cnt].n3=0 END IF

              EXECUTE imk_pre USING g_img[g_cnt].ima01,g_img[g_cnt].img02,g_img[g_cnt].img03,g_img[g_cnt].img04 INTO g_img[g_cnt].q0   #期初数量
              IF cl_null(g_img[g_cnt].q0) THEN LET g_img[g_cnt].q0=0 END IF
              LET g_img[g_cnt].s0 = g_img[g_cnt].p0*g_img[g_cnt].q0   #期初金额

              #----------------------处理上一笔-------------------------#
              LET g_img[g_cnt-1].img02=t_img02   LET g_img[g_cnt-1].img03=t_img03   LET g_img[g_cnt-1].ime03=t_ime03  LET g_img[g_cnt-1].img04=t_img04
              LET g_img[g_cnt-1].imd02=t_imd02   LET g_img[g_cnt-1].img19=t_img19   LET g_img[g_cnt-1].ima12=t_ima12  LET g_img[g_cnt-1].ima01=t_ima01
              LET g_img[g_cnt-1].ima02=t_ima02   LET g_img[g_cnt-1].ima021=t_ima021   LET g_img[g_cnt-1].img09=t_img09  
              
              IF g_cnt=2 THEN 
                 EXECUTE stb_pre USING g_img[g_cnt-1].ima01 INTO g_img[g_cnt-1].p0   #计划单价
                 IF cl_null(g_img[g_cnt-1].p0) THEN LET g_img[g_cnt-1].p0=0 END IF
                 LET g_img[g_cnt-1].p3 = g_img[g_cnt-1].p0

                 EXECUTE ccc_pre USING g_img[g_cnt-1].ima01 INTO g_img[g_cnt-1].n3   #实际单价
                 IF cl_null(g_img[g_cnt-1].n3) THEN LET g_img[g_cnt-1].n3=0 END IF
 
                #EXECUTE imk_pre USING g_img[g_cnt-1].ima01,g_img[g_cnt-1].img02,g_img[g_cnt-1].img04,g_img[g_cnt-1].img04 INTO g_img[g_cnt-1].q0  #期初数量 #MOD-DB0080 mark
                 EXECUTE imk_pre USING g_img[g_cnt-1].ima01,g_img[g_cnt-1].img02,g_img[g_cnt-1].img03,g_img[g_cnt-1].img04 INTO g_img[g_cnt-1].q0  #期初数量 #MOD-DB0080 add
                 IF cl_null(g_img[g_cnt-1].q0) THEN LET g_img[g_cnt-1].q0=0 END IF
                 LET g_img[g_cnt-1].s0 = g_img[g_cnt-1].p0*g_img[g_cnt-1].q0          #期初金额
              END IF
              LET g_img[g_cnt-1].q3 = l_qty+g_img[g_cnt-1].q0   #期末数量
              LET g_img[g_cnt-1].s3 = g_img[g_cnt-1].p0*g_img[g_cnt-1].q3   #期末金额
              LET g_img[g_cnt-1].r3 = g_img[g_cnt-1].n3*g_img[g_cnt-1].q3   #期末实际成本金额
              LET g_img[g_cnt-1].m3 = g_img[g_cnt-1].r3-g_img[g_cnt-1].s3   #差异
         
              LET l_qty = 0
              #--------------------------End-----------------------------#
              
           END IF
        END IF
        LET l_day=DAY(l_tlf06)
        CASE 
           WHEN l_day=1 AND l_tlf907=1   LET g_img[g_cnt].d0 = l_tlf10   #1号-入
           WHEN l_day=1 AND l_tlf907=-1  LET g_img[g_cnt].d1 = l_tlf10   #1号-出
           WHEN l_day=2 AND l_tlf907=1   LET g_img[g_cnt].d2 = l_tlf10  
           WHEN l_day=2 AND l_tlf907=-1  LET g_img[g_cnt].d3 = l_tlf10 
           WHEN l_day=3 AND l_tlf907=1   LET g_img[g_cnt].d4 = l_tlf10   
           WHEN l_day=3 AND l_tlf907=-1  LET g_img[g_cnt].d5 = l_tlf10  
           WHEN l_day=4 AND l_tlf907=1   LET g_img[g_cnt].d6 = l_tlf10 
           WHEN l_day=4 AND l_tlf907=-1  LET g_img[g_cnt].d7 = l_tlf10  
           WHEN l_day=5 AND l_tlf907=1   LET g_img[g_cnt].d8 = l_tlf10 
           WHEN l_day=5 AND l_tlf907=-1  LET g_img[g_cnt].d9 = l_tlf10 
           WHEN l_day=6 AND l_tlf907=1   LET g_img[g_cnt].d10 = l_tlf10 
           WHEN l_day=6 AND l_tlf907=-1  LET g_img[g_cnt].d11 = l_tlf10 
           WHEN l_day=7 AND l_tlf907=1   LET g_img[g_cnt].d12 = l_tlf10 
           WHEN l_day=7 AND l_tlf907=-1  LET g_img[g_cnt].d13 = l_tlf10 
           WHEN l_day=8 AND l_tlf907=1   LET g_img[g_cnt].d14 = l_tlf10 
           WHEN l_day=8 AND l_tlf907=-1  LET g_img[g_cnt].d15 = l_tlf10
           WHEN l_day=9 AND l_tlf907=1   LET g_img[g_cnt].d16 = l_tlf10   
           WHEN l_day=9 AND l_tlf907=-1  LET g_img[g_cnt].d17 = l_tlf10   
           WHEN l_day=10 AND l_tlf907=1  LET g_img[g_cnt].d18 = l_tlf10  
           WHEN l_day=10 AND l_tlf907=-1 LET g_img[g_cnt].d19 = l_tlf10  
           WHEN l_day=11 AND l_tlf907=1  LET g_img[g_cnt].d20 = l_tlf10  
           WHEN l_day=11 AND l_tlf907=-1 LET g_img[g_cnt].d21 = l_tlf10  
           WHEN l_day=12 AND l_tlf907=1  LET g_img[g_cnt].d22 = l_tlf10  
           WHEN l_day=12 AND l_tlf907=-1 LET g_img[g_cnt].d23 = l_tlf10   
           WHEN l_day=13 AND l_tlf907=1  LET g_img[g_cnt].d24 = l_tlf10   
           WHEN l_day=13 AND l_tlf907=-1 LET g_img[g_cnt].d25 = l_tlf10   
           WHEN l_day=14 AND l_tlf907=1  LET g_img[g_cnt].d26 = l_tlf10   
           WHEN l_day=14 AND l_tlf907=-1 LET g_img[g_cnt].d27 = l_tlf10   
           WHEN l_day=15 AND l_tlf907=1  LET g_img[g_cnt].d28 = l_tlf10   
           WHEN l_day=15 AND l_tlf907=-1 LET g_img[g_cnt].d29 = l_tlf10   
           WHEN l_day=16 AND l_tlf907=1  LET g_img[g_cnt].d30 = l_tlf10   
           WHEN l_day=16 AND l_tlf907=-1 LET g_img[g_cnt].d31 = l_tlf10   
           WHEN l_day=17 AND l_tlf907=1  LET g_img[g_cnt].d32 = l_tlf10   
           WHEN l_day=17 AND l_tlf907=-1 LET g_img[g_cnt].d33 = l_tlf10  
           WHEN l_day=18 AND l_tlf907=1  LET g_img[g_cnt].d34 = l_tlf10 
           WHEN l_day=18 AND l_tlf907=-1 LET g_img[g_cnt].d35 = l_tlf10
           WHEN l_day=19 AND l_tlf907=1  LET g_img[g_cnt].d36 = l_tlf10   
           WHEN l_day=19 AND l_tlf907=-1 LET g_img[g_cnt].d37 = l_tlf10   
           WHEN l_day=20 AND l_tlf907=1  LET g_img[g_cnt].d38 = l_tlf10   
           WHEN l_day=20 AND l_tlf907=-1 LET g_img[g_cnt].d39 = l_tlf10   
           WHEN l_day=21 AND l_tlf907=1  LET g_img[g_cnt].d40 = l_tlf10   
           WHEN l_day=21 AND l_tlf907=-1 LET g_img[g_cnt].d41 = l_tlf10
           WHEN l_day=22 AND l_tlf907=1  LET g_img[g_cnt].d42 = l_tlf10 
           WHEN l_day=22 AND l_tlf907=-1 LET g_img[g_cnt].d43 = l_tlf10  
           WHEN l_day=23 AND l_tlf907=1  LET g_img[g_cnt].d44 = l_tlf10   
           WHEN l_day=23 AND l_tlf907=-1 LET g_img[g_cnt].d45 = l_tlf10   
           WHEN l_day=24 AND l_tlf907=1  LET g_img[g_cnt].d46 = l_tlf10   
           WHEN l_day=24 AND l_tlf907=-1 LET g_img[g_cnt].d47 = l_tlf10   
           WHEN l_day=25 AND l_tlf907=1  LET g_img[g_cnt].d48 = l_tlf10   
           WHEN l_day=25 AND l_tlf907=-1 LET g_img[g_cnt].d49 = l_tlf10   
           WHEN l_day=26 AND l_tlf907=1  LET g_img[g_cnt].d50 = l_tlf10   
           WHEN l_day=26 AND l_tlf907=-1 LET g_img[g_cnt].d51 = l_tlf10   
           WHEN l_day=27 AND l_tlf907=1  LET g_img[g_cnt].d52 = l_tlf10   
           WHEN l_day=27 AND l_tlf907=-1 LET g_img[g_cnt].d53 = l_tlf10  
           WHEN l_day=28 AND l_tlf907=1  LET g_img[g_cnt].d54 = l_tlf10 
           WHEN l_day=28 AND l_tlf907=-1 LET g_img[g_cnt].d55 = l_tlf10
           WHEN l_day=29 AND l_tlf907=1  LET g_img[g_cnt].d56 = l_tlf10   
           WHEN l_day=29 AND l_tlf907=-1 LET g_img[g_cnt].d57 = l_tlf10   
           WHEN l_day=30 AND l_tlf907=1  LET g_img[g_cnt].d58 = l_tlf10   
           WHEN l_day=30 AND l_tlf907=-1 LET g_img[g_cnt].d59 = l_tlf10   
           WHEN l_day=31 AND l_tlf907=1  LET g_img[g_cnt].d60 = l_tlf10   
           WHEN l_day=31 AND l_tlf907=-1 LET g_img[g_cnt].d61 = l_tlf10   
        END CASE

        IF cl_null(g_img[g_cnt].d0) THEN LET g_img[g_cnt].d0=0 END  IF
        IF cl_null(g_img[g_cnt].d1) THEN LET g_img[g_cnt].d1=0 END  IF
        IF cl_null(g_img[g_cnt].d2) THEN LET g_img[g_cnt].d2=0 END  IF
        IF cl_null(g_img[g_cnt].d3) THEN LET g_img[g_cnt].d3=0 END  IF
        IF cl_null(g_img[g_cnt].d4) THEN LET g_img[g_cnt].d4=0 END  IF
        IF cl_null(g_img[g_cnt].d5) THEN LET g_img[g_cnt].d5=0 END  IF
        IF cl_null(g_img[g_cnt].d6) THEN LET g_img[g_cnt].d6=0 END  IF
        IF cl_null(g_img[g_cnt].d7) THEN LET g_img[g_cnt].d7=0 END  IF
        IF cl_null(g_img[g_cnt].d8) THEN LET g_img[g_cnt].d8=0 END  IF
        IF cl_null(g_img[g_cnt].d9) THEN LET g_img[g_cnt].d9=0 END  IF
        IF cl_null(g_img[g_cnt].d10) THEN LET g_img[g_cnt].d10=0 END  IF
        IF cl_null(g_img[g_cnt].d11) THEN LET g_img[g_cnt].d11=0 END  IF
        IF cl_null(g_img[g_cnt].d12) THEN LET g_img[g_cnt].d12=0 END  IF
        IF cl_null(g_img[g_cnt].d13) THEN LET g_img[g_cnt].d13=0 END  IF
        IF cl_null(g_img[g_cnt].d14) THEN LET g_img[g_cnt].d14=0 END  IF
        IF cl_null(g_img[g_cnt].d15) THEN LET g_img[g_cnt].d15=0 END  IF
        IF cl_null(g_img[g_cnt].d16) THEN LET g_img[g_cnt].d16=0 END  IF
        IF cl_null(g_img[g_cnt].d17) THEN LET g_img[g_cnt].d17=0 END  IF
        IF cl_null(g_img[g_cnt].d18) THEN LET g_img[g_cnt].d18=0 END  IF
        IF cl_null(g_img[g_cnt].d19) THEN LET g_img[g_cnt].d19=0 END  IF
        IF cl_null(g_img[g_cnt].d20) THEN LET g_img[g_cnt].d20=0 END  IF
        IF cl_null(g_img[g_cnt].d21) THEN LET g_img[g_cnt].d21=0 END  IF
        IF cl_null(g_img[g_cnt].d22) THEN LET g_img[g_cnt].d22=0 END  IF
        IF cl_null(g_img[g_cnt].d23) THEN LET g_img[g_cnt].d23=0 END  IF
        IF cl_null(g_img[g_cnt].d24) THEN LET g_img[g_cnt].d24=0 END  IF
        IF cl_null(g_img[g_cnt].d25) THEN LET g_img[g_cnt].d25=0 END  IF
        IF cl_null(g_img[g_cnt].d26) THEN LET g_img[g_cnt].d26=0 END  IF
        IF cl_null(g_img[g_cnt].d27) THEN LET g_img[g_cnt].d27=0 END  IF
        IF cl_null(g_img[g_cnt].d28) THEN LET g_img[g_cnt].d28=0 END  IF
        IF cl_null(g_img[g_cnt].d29) THEN LET g_img[g_cnt].d29=0 END  IF
        IF cl_null(g_img[g_cnt].d30) THEN LET g_img[g_cnt].d30=0 END  IF
        IF cl_null(g_img[g_cnt].d31) THEN LET g_img[g_cnt].d31=0 END  IF
        IF cl_null(g_img[g_cnt].d32) THEN LET g_img[g_cnt].d32=0 END  IF
        IF cl_null(g_img[g_cnt].d33) THEN LET g_img[g_cnt].d33=0 END  IF
        IF cl_null(g_img[g_cnt].d34) THEN LET g_img[g_cnt].d34=0 END  IF
        IF cl_null(g_img[g_cnt].d35) THEN LET g_img[g_cnt].d35=0 END  IF
        IF cl_null(g_img[g_cnt].d36) THEN LET g_img[g_cnt].d36=0 END  IF
        IF cl_null(g_img[g_cnt].d37) THEN LET g_img[g_cnt].d37=0 END  IF
        IF cl_null(g_img[g_cnt].d38) THEN LET g_img[g_cnt].d38=0 END  IF
        IF cl_null(g_img[g_cnt].d39) THEN LET g_img[g_cnt].d39=0 END  IF
        IF cl_null(g_img[g_cnt].d40) THEN LET g_img[g_cnt].d40=0 END  IF
        IF cl_null(g_img[g_cnt].d41) THEN LET g_img[g_cnt].d41=0 END  IF
        IF cl_null(g_img[g_cnt].d42) THEN LET g_img[g_cnt].d42=0 END  IF
        IF cl_null(g_img[g_cnt].d43) THEN LET g_img[g_cnt].d43=0 END  IF
        IF cl_null(g_img[g_cnt].d44) THEN LET g_img[g_cnt].d44=0 END  IF
        IF cl_null(g_img[g_cnt].d45) THEN LET g_img[g_cnt].d45=0 END  IF
        IF cl_null(g_img[g_cnt].d46) THEN LET g_img[g_cnt].d46=0 END  IF
        IF cl_null(g_img[g_cnt].d47) THEN LET g_img[g_cnt].d47=0 END  IF
        IF cl_null(g_img[g_cnt].d48) THEN LET g_img[g_cnt].d48=0 END  IF
        IF cl_null(g_img[g_cnt].d49) THEN LET g_img[g_cnt].d49=0 END  IF
        IF cl_null(g_img[g_cnt].d50) THEN LET g_img[g_cnt].d50=0 END  IF
        IF cl_null(g_img[g_cnt].d51) THEN LET g_img[g_cnt].d51=0 END  IF
        IF cl_null(g_img[g_cnt].d52) THEN LET g_img[g_cnt].d52=0 END  IF
        IF cl_null(g_img[g_cnt].d53) THEN LET g_img[g_cnt].d53=0 END  IF
        IF cl_null(g_img[g_cnt].d54) THEN LET g_img[g_cnt].d54=0 END  IF
        IF cl_null(g_img[g_cnt].d55) THEN LET g_img[g_cnt].d55=0 END  IF
        IF cl_null(g_img[g_cnt].d56) THEN LET g_img[g_cnt].d56=0 END  IF
        IF cl_null(g_img[g_cnt].d57) THEN LET g_img[g_cnt].d57=0 END  IF
        IF cl_null(g_img[g_cnt].d58) THEN LET g_img[g_cnt].d58=0 END  IF
        IF cl_null(g_img[g_cnt].d59) THEN LET g_img[g_cnt].d59=0 END  IF
        IF cl_null(g_img[g_cnt].d60) THEN LET g_img[g_cnt].d60=0 END  IF
        IF cl_null(g_img[g_cnt].d61) THEN LET g_img[g_cnt].d61=0 END  IF           

        LET l_qty1=l_tlf10*l_tlf907 
        IF cl_null(l_qty1) THEN LET l_qty1=0 END IF
        LET l_qty = l_qty+l_qty1
     {   IF tm.viewall='N' AND g_img[g_cnt].q0 = 0 AND g_img[g_cnt].d0 = 0 AND g_img[g_cnt].d1 = 0 AND g_img[g_cnt].d2 = 0 AND g_img[g_cnt].d3 = 0
           AND g_img[g_cnt].d4 = 0 AND g_img[g_cnt].d5 = 0 AND g_img[g_cnt].d6 = 0 AND g_img[g_cnt].d7 = 0 AND g_img[g_cnt].d8 = 0 AND g_img[g_cnt].d9 = 0
           AND g_img[g_cnt].d10 = 0 AND g_img[g_cnt].d11 = 0 AND g_img[g_cnt].d12 = 0 AND g_img[g_cnt].d13 = 0 AND g_img[g_cnt].d14 = 0 AND g_img[g_cnt].d15 = 0 
           AND g_img[g_cnt].d16 = 0 AND g_img[g_cnt].d17 = 0 AND g_img[g_cnt].d18 = 0 AND g_img[g_cnt].d19 = 0 AND g_img[g_cnt].d20 = 0 AND g_img[g_cnt].d21 = 0
           AND g_img[g_cnt].d22 = 0 AND g_img[g_cnt].d23 = 0 AND g_img[g_cnt].d24 = 0 AND g_img[g_cnt].d25 = 0 AND g_img[g_cnt].d26 = 0 AND g_img[g_cnt].d27 = 0
           AND g_img[g_cnt].d28 = 0 AND g_img[g_cnt].d29 = 0 AND g_img[g_cnt].d30 = 0 AND g_img[g_cnt].d31 = 0 AND g_img[g_cnt].d32 = 0 AND g_img[g_cnt].d33 = 0
           AND g_img[g_cnt].d34 = 0 AND g_img[g_cnt].d35 = 0 AND g_img[g_cnt].d36 = 0 AND g_img[g_cnt].d37 = 0 AND g_img[g_cnt].d38 = 0 AND g_img[g_cnt].d39 = 0 
           AND g_img[g_cnt].d40 = 0 AND g_img[g_cnt].d41 = 0 AND g_img[g_cnt].d42 = 0 AND g_img[g_cnt].d43 = 0 AND g_img[g_cnt].d44 = 0 AND g_img[g_cnt].d45 = 0
           AND g_img[g_cnt].d46 = 0 AND g_img[g_cnt].d47 = 0 AND g_img[g_cnt].d48 = 0 AND g_img[g_cnt].d49 = 0 AND g_img[g_cnt].d50 = 0 AND g_img[g_cnt].d51 = 0
           AND g_img[g_cnt].d52 = 0 AND g_img[g_cnt].d53 = 0 AND g_img[g_cnt].d54 = 0 AND g_img[g_cnt].d55 = 0 AND g_img[g_cnt].d56 = 0 AND g_img[g_cnt].d57 = 0
           AND g_img[g_cnt].d58 = 0 AND g_img[g_cnt].d59 = 0 AND g_img[g_cnt].d60 = 0 AND g_img[g_cnt].d61 = 0 AND g_img[g_cnt].q3 = 0 THEN
           CONTINUE FOREACH
        END IF
     } 
        LET l_ima01= g_img[g_cnt].ima01
        LET l_img02= g_img[g_cnt].img02
        LET l_img03= g_img[g_cnt].img03
        LET l_img04= g_img[g_cnt].img04
           
        LET t_img02=g_img[g_cnt].img02   LET t_img03=g_img[g_cnt].img03   LET t_ime03=g_img[g_cnt].ime03  LET t_img04=g_img[g_cnt].img04
        LET t_imd02=g_img[g_cnt].imd02   LET t_img19=g_img[g_cnt].img19   LET t_ima12=g_img[g_cnt].ima12  LET t_ima01=g_img[g_cnt].ima01
        LET t_ima02=g_img[g_cnt].ima02   LET t_ima021=g_img[g_cnt].ima021   LET t_img09=g_img[g_cnt].img09  

        IF g_cnt > 20000  THEN   
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF 
        DISPLAY BY NAME g_img[g_cnt].img02
    END FOREACH
    #最后一笔的
    #MOD-DA0201--begin---add
    IF g_cnt=1 THEN 
       EXECUTE stb_pre USING g_img[g_cnt].ima01 INTO g_img[g_cnt].p0   #计划单价
       IF cl_null(g_img[g_cnt].p0) THEN LET g_img[g_cnt].p0=0 END IF
       LET g_img[g_cnt].p3 = g_img[g_cnt].p0

       EXECUTE ccc_pre USING g_img[g_cnt].ima01 INTO g_img[g_cnt].n3   #实际单价
       IF cl_null(g_img[g_cnt].n3) THEN LET g_img[g_cnt].n3=0 END IF
 
       EXECUTE imk_pre USING g_img[g_cnt].ima01,g_img[g_cnt].img02,g_img[g_cnt].img04,g_img[g_cnt].img04 INTO g_img[g_cnt].q0  #期初数量
       IF cl_null(g_img[g_cnt].q0) THEN LET g_img[g_cnt].q0=0 END IF
       LET g_img[g_cnt].s0 = g_img[g_cnt].p0*g_img[g_cnt].q0          #期初金额
    END IF
    #MOD-DA0201--end---add
    LET g_img[g_cnt].q3 = l_qty+g_img[g_cnt].q0             #期末数量
    LET g_img[g_cnt].s3 = g_img[g_cnt].p0*g_img[g_cnt].q3   #期末金额
    LET g_img[g_cnt].r3 = g_img[g_cnt].n3*g_img[g_cnt].q3   #期末实际成本金额
    LET g_img[g_cnt].m3 = g_img[g_cnt].r3-g_img[g_cnt].s3   #差异
 END WHILE
 display time   #xj add
 DISPLAY g_cnt TO FORMONLY.cnt
 DISPLAY g_cnt TO FORMONLY.cn2
END FUNCTION

#TQC-CC0128
