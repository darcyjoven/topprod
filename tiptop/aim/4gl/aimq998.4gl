# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# PATTERN NAME...: aimq998.4gl
# DESCRIPTIONS...: 盤盈虧明細表
# DATE & AUTHOR..: 12/08/29 by xujing  FUN-C80092
# Modify.........: No.FUN-C80092 12/09/12 By lixh1 增加寫入日誌功能
# Modify.........: No.FUN-C80092 12/09/18 By fengrui 增加axcq100串查功能,最大筆數控制與excel導出處理 
# Modify.........: No.FUN-D10022 13/01/05 By xujing 優化成本勾稽
# Modify.........: No.MOD-D60247 13/06/29 By fengmy 自動執行成功未更新CKA檔

DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE tm,tm_t  RECORD
           wc        LIKE type_file.chr1000,   
           yy,mm     LIKE type_file.num5,
           d         LIKE type_file.chr1,
           e         LIKE type_file.chr1,    
           f         LIKE type_file.chr1,    
           ctype     LIKE type_file.chr1,  
           a         LIKE type_file.chr1,
           z         LIKE type_file.chr1
           END RECORD
DEFINE g_tlf DYNAMIC ARRAY OF RECORD
         azp01    LIKE azp_file.azp01,
         ima12    LIKE ima_file.ima12,
         azf03    LIKE azf_file.azf03,
         pia02    LIKE pia_file.pia02,
         ima02    LIKE ima_file.ima02,
         ima021   LIKE ima_file.ima021,
         ccc08    LIKE ccc_file.ccc08,
         pia01    LIKE pia_file.pia01,
         pia03    LIKE pia_file.pia03, 
         pia04    LIKE pia_file.pia04, 
         pia05    LIKE pia_file.pia05,
         img09    LIKE type_file.chr100,
         pia08    LIKE pia_file.pia08,
         pia08_c  LIKE ccc_file.ccc23,                                          
         pia30    LIKE pia_file.pia30,
         pia30_c  LIKE ccc_file.ccc23,
         diff     LIKE pia_file.pia30,
         diff_c   LIKE ccc_file.ccc23,
         x45      LIKE type_file.chr100,
         ccc23    LIKE ccc_file.ccc23 
             END RECORD
DEFINE g_tlf_excel DYNAMIC ARRAY OF RECORD
         azp01    LIKE azp_file.azp01,
         ima12    LIKE ima_file.ima12,
         azf03    LIKE azf_file.azf03,
         pia02    LIKE pia_file.pia02,
         ima02    LIKE ima_file.ima02,
         ima021   LIKE ima_file.ima021,
         ccc08    LIKE ccc_file.ccc08,
         pia01    LIKE pia_file.pia01,
         pia03    LIKE pia_file.pia03, 
         pia04    LIKE pia_file.pia04, 
         pia05    LIKE pia_file.pia05,
         img09    LIKE type_file.chr100,
         pia08    LIKE pia_file.pia08,
         pia08_c  LIKE ccc_file.ccc23,                                          
         pia30    LIKE pia_file.pia30,
         pia30_c  LIKE ccc_file.ccc23,
         diff     LIKE pia_file.pia30,
         diff_c   LIKE ccc_file.ccc23,
         x45      LIKE type_file.chr100,
         ccc23    LIKE ccc_file.ccc23
             END RECORD
DEFINE g_tlf_1,g_tlf_1_excel DYNAMIC ARRAY OF RECORD
         azp01    LIKE azp_file.azp01,
         ima12    LIKE ima_file.ima12,
         azf03    LIKE azf_file.azf03,
         pia02    LIKE pia_file.pia02,
         ima02    LIKE ima_file.ima02,
         ima021   LIKE ima_file.ima021,
         ccc08    LIKE ccc_file.ccc08,
         pia01    LIKE pia_file.pia01,
         pia03    LIKE pia_file.pia03, 
         pia04    LIKE pia_file.pia04, 
         pia05    LIKE pia_file.pia05,
         img09    LIKE type_file.chr100,
         pia08    LIKE pia_file.pia08,
         pia08_c  LIKE ccc_file.ccc23,                                          
         pia30    LIKE pia_file.pia30,
         pia30_c  LIKE ccc_file.ccc23,
         diff     LIKE pia_file.pia30,
         diff_c   LIKE ccc_file.ccc23,
         x45      LIKE type_file.chr100,
         ccc23    LIKE ccc_file.ccc23 
             END RECORD
DEFINE   sr1     RECORD
         pia08_tot     LIKE pia_file.pia08,
         pia08_c_tot   LIKE ccc_file.ccc23,                                          
         pia30_tot     LIKE pia_file.pia30,
         pia30_c_tot   LIKE ccc_file.ccc23,
         diff_tot      LIKE pia_file.pia30,
         diff_c_tot    LIKE ccc_file.ccc23      
                  END RECORD
DEFINE g_sql      STRING                                        
DEFINE g_str      STRING                                        
DEFINE m_plant    LIKE azw_file.azw01                           
DEFINE g_azi_azi03 LIKE azi_file.azi03                         
DEFINE g_azi_azi04 LIKE azi_file.azi04                        
DEFINE g_azi_azi05 LIKE azi_file.azi05                          
DEFINE g_wc        LIKE type_file.chr1000                       
DEFINE g_yy,g_mm   LIKE type_file.num5,                         
       g_rec_b     LIKE type_file.num10                                              
DEFINE   g_cnt           LIKE type_file.num10        
DEFINE   g_msg           LIKE ze_file.ze03           
DEFINE   g_row_count     LIKE type_file.num10         
DEFINE   g_curs_index    LIKE type_file.num10        
DEFINE l_ac              LIKE type_file.num5
DEFINE g_piaplant_o  LIKE pia_file.piaplant
DEFINE g_ima12_o     LIKE ima_file.ima12
DEFINE g_ckk   RECORD LIKE ckk_file.*
DEFINE l_table       STRING
DEFINE g_i     LIKE type_file.num5
DEFINE g_pia02    LIKE pia_file.pia02
DEFINE g_argv1        LIKE type_file.num5,
       g_argv2        LIKE type_file.num5,
       g_argv3        LIKE type_file.chr1,
       g_argv4        LIKE type_file.chr1,
       g_argv5        LIKE type_file.chr1
DEFINE g_cka00        LIKE cka_file.cka00  
DEFINE l_ac1          LIKE type_file.num5,    #FUN-D10022 add
       g_rec_b2       LIKE type_file.num10  #FUN-D10022 add
DEFINE g_filter_wc    STRING
DEFINE g_filter_plant_wc STRING 
DEFINE g_flag         LIKE type_file.chr1 
DEFINE g_action_flag  LIKE type_file.chr100
DEFINE w              ui.Window      
DEFINE f              ui.Form       
DEFINE page         om.DomNode 

MAIN
   OPTIONS                               
      INPUT NO WRAP
   DEFER INTERRUPT                       
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time     

   LET g_argv1   = ARG_VAL(1)  #年度 
   LET g_argv2   = ARG_VAL(2)  #期別 
   LET g_argv3   = ARG_VAL(3)  #成本計算類型   
   LET g_argv4   = ARG_VAL(4)  #勾稽否
   LET g_argv5   = ARG_VAL(5)  #g_bgjob
   LET g_bgjob   = g_argv5
   CALL q998_table()
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      OPEN WINDOW q998_w WITH FORM "aim/42f/aimq998"
         ATTRIBUTE (STYLE = g_win_style CLIPPED)
      CALL cl_ui_init()
# Prog. Version..: '5.30.06-13.03.12(0,0)    #FUN-D10022 mark
      CALL q998_q()
      CALL cl_set_act_visible("revert_filter",FALSE)
      CALL q998_menu()
      CLOSE WINDOW q998_w   
    ELSE
      CALL aimq998()
    END IF
    DROP TABLE aimq998_tmp
    CALL cl_used(g_prog,g_time,2) RETURNING g_time      
END MAIN
 
FUNCTION q998_cs()
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   
DEFINE p_row,p_col    LIKE type_file.num5    
DEFINE l_cmd          LIKE type_file.chr1000 
DEFINE li_result      LIKE type_file.num5  
 
   SELECT ccz28,ccz01,ccz02 INTO g_ccz.ccz28,g_ccz.ccz01,g_ccz.ccz02
      FROM ccz_file WHERE ccz00='0'  
   CLEAR FORM 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.d    = 'N'
   LET tm.e    = '3'
   LET tm.f    = '1'
   LET tm.yy   = g_ccz.ccz01
   LET tm.mm   = g_ccz.ccz02
   LET tm.ctype = g_ccz.ccz28   
   LET tm.a    = '1'
   LET tm.z    = 'Y'
   CALL cl_set_comp_visible("page02", FALSE)
   CALL ui.interface.refresh()
   CALL cl_set_comp_visible("page02", TRUE)

   DIALOG ATTRIBUTE(UNBUFFERED)
      INPUT BY NAME tm.yy,tm.mm,tm.ctype,tm.a,tm.d,
                    tm.z,tm.e,tm.f
                 ATTRIBUTE(WITHOUT DEFAULTS) 
         BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)
      AFTER FIELD d
         IF tm.d NOT MATCHES '[YN]' THEN
            NEXT FIELD d
         END IF
      AFTER FIELD e
         IF tm.e NOT MATCHES '[123]' THEN
            NEXT FIELD e
         END IF
      AFTER FIELD f
         IF tm.f NOT MATCHES '[123]' THEN
            NEXT FIELD f
         END IF
      AFTER FIELD yy
         IF tm.yy != g_ccz.ccz01 OR tm.mm != g_ccz.ccz02 THEN
            CALL cl_set_comp_entry('z',FALSE)
            LET tm.z = 'N'
            DISPLAY BY NAME tm.z
         ELSE
            CALL cl_set_comp_entry('z',TRUE)
            LET tm.z = 'Y'
            DISPLAY BY NAME tm.z
         END IF 
         
      AFTER FIELD mm
         IF tm.mm > 12 OR tm.mm <= 0 THEN
            NEXT FIELD mm
         END IF

         IF tm.yy != g_ccz.ccz01 OR tm.mm != g_ccz.ccz02 THEN
            CALL cl_set_comp_entry('z',FALSE)
            LET tm.z = 'N'
            DISPLAY BY NAME tm.z
         ELSE
            CALL cl_set_comp_entry('z',TRUE)
            LET tm.z = 'Y'
            DISPLAY BY NAME tm.z
         END IF
      END INPUT 
      CONSTRUCT g_wc ON azp01 FROM s_tlf[1].azp01
          
      END CONSTRUCT

      CONSTRUCT tm.wc ON ima12,pia02,ccc08,pia01,pia03,pia04,pia05
                    FROM s_tlf[1].ima12,s_tlf[1].pia02,s_tlf[1].ccc08,s_tlf[1].pia01,
                         s_tlf[1].pia03,s_tlf[1].pia04,s_tlf[1].pia05
      END CONSTRUCT

      ON ACTION controlp
         IF INFIELD(azp01) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_azw"
            LET g_qryparam.state = "c"
               LET g_qryparam.where = "azw02 = '",g_legal,"' ",
                                      " AND azw01 IN(SELECT zxy03 FROM zxy_file WHERE zxy01 = '",g_user,"' )"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO azp01
               NEXT FIELD azp01 
            END IF   
            
         IF INFIELD(pia02) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_ima"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO pia02
            NEXT FIELD pia02
         END IF

         IF INFIELD(ima12) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_azf"
            LET g_qryparam.state = "c"
            LET g_qryparam.arg1  = "G"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO ima12 
            NEXT FIELD ima12    
         END IF 

         IF INFIELD(pia03) THEN #倉庫
            CALL q_imd_1(TRUE,TRUE,"","","","","") RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO pia03
            NEXT FIELD pia03
         END IF 

         IF INFIELD(pia04) THEN #儲位
            CALL q_ime_1(TRUE,TRUE,"","","",g_plant,"","","") RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO pia04
            NEXT FIELD pia04
         END IF 

         IF INFIELD(pia05) THEN#批號
            CALL cl_init_qry_var()
            LET g_qryparam.state    = "c"
            LET g_qryparam.form     = "q_img"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO pia05
            NEXT FIELD pia05
         END IF 
         #FUN-D10022---add---str---
         IF INFIELD(ccc08) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.state    = "c"
            LET g_qryparam.form     = "q_ccc08"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO ccc08
            NEXT FIELD ccc08
         END IF

         IF INFIELD(pia01) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.state  = "c"
            LET g_qryparam.form   = "q_pia01"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO pia01
            NEXT FIELD pia01
         END IF 
         #FUN-D10022---add---end---
       ON ACTION CONTROLZ
          CALL cl_show_req_fields()

       ON ACTION CONTROLG 
          CALL cl_cmdask()
   
       ON ACTION ACCEPT 
          ACCEPT DIALOG

       ON ACTION CANCEL
          LET INT_FLAG=1
          EXIT DIALOG 
         
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE DIALOG
 
       ON ACTION about         
          CALL cl_about()     
 
       ON ACTION HELP         
          CALL cl_show_help() 
 
       ON ACTION EXIT
          LET INT_FLAG = 1
          EXIT DIALOG

       ON ACTION qbe_save
          CALL cl_qbe_save()

       ON ACTION qbe_select
          CALL cl_qbe_select()

       BEFORE DIALOG
          CALL cl_qbe_init()
          IF NOT cl_null(g_argv1) AND NOT cl_null(g_argv2) AND NOT cl_null(g_argv3) THEN 
             LET g_wc = " azw01 ='",g_plant CLIPPED,"'"
             LET tm.wc = " 1=1"
             DISPLAY g_plant TO azp01
             LET tm.yy   = g_argv1
             LET tm.mm   = g_argv2
             LET g_yy = tm.yy
             LET g_mm = tm.mm
             LET tm.ctype = g_argv3
             IF tm.yy != g_ccz.ccz01 OR tm.mm != g_ccz.ccz02 THEN
                LET tm.z = 'N'
             ELSE
                LET tm.z = 'Y'
             END IF
             DISPLAY BY NAME tm.d,tm.e,tm.f,tm.a,tm.z,
                         tm.yy,tm.mm,tm.ctype
             CALL cl_set_comp_entry('yy,mm,ctype',FALSE)
             EXIT DIALOG 
          ELSE
             CALL cl_set_comp_entry('yy,mm,ctype',TRUE)
          END IF
   END DIALOG
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup') 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE tm.* TO NULL
      INITIALIZE sr1.* TO NULL
      DELETE FROM aimq998_tmp
      RETURN
   END IF
   CALL aimq998()
END FUNCTION
 
FUNCTION q998_menu()
   WHILE TRUE
      IF cl_null(g_action_choice) THEN
         IF g_action_flag = "page01" THEN
            CALL q998_bp("G")
         END IF
         IF g_action_flag = "page02" THEN
            CALL q998_bp2()
         END IF
      END IF
      CASE g_action_choice
         WHEN "page01"
            CALL q998_bp("G")
         WHEN "page02"
            CALL q998_bp2()
         WHEN "data_filter"       #資料過濾
            IF cl_chk_act_auth() THEN
               CALL q998_filter_askkey()
               CALL aimq998()        #重填充新臨時表
               CALL q998_show()
            END IF            
            LET g_action_choice = " "
         WHEN "revert_filter"     # 過濾還原
            IF cl_chk_act_auth() THEN
               LET g_filter_wc = ''
               CALL cl_set_act_visible("revert_filter",FALSE) 
               CALL aimq998()        #重填充新臨時表
               CALL q998_show() 
            END IF             
            LET g_action_choice = " "
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL q998_q()
            END IF
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
            IF g_action_flag = "page01" THEN  
               IF cl_chk_act_auth() THEN
                  LET page = f.FindNode("Page","page01")
                  CALL cl_export_to_excel(page,base.TypeInfo.create(g_tlf_excel),'','')
               END IF
            END IF  
            IF g_action_flag = "page02" THEN
               IF cl_chk_act_auth() THEN
                  LET page = f.FindNode("Page","page02")
                  CALL cl_export_to_excel(page,base.TypeInfo.create(g_tlf_1_excel),'','')
               END IF
            END IF
            LET g_action_choice = " "
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q998_show()
   DISPLAY tm.a TO a
   IF cl_null(g_action_flag) OR g_action_flag = "page02" THEN
      LET g_action_choice = "page02"
      CALL q998_b_fill()  
      CALL q998_b_fill_2()
      CALL cl_set_comp_visible("page01", FALSE)
      CALL ui.interface.refresh()
      CALL cl_set_comp_visible("page01", TRUE)
   ELSE
      LET g_action_choice = "page01"
      CALL q998_b_fill_2()
      CALL q998_b_fill()  
      CALL cl_set_comp_visible("page02", FALSE)
      CALL ui.interface.refresh()
      CALL cl_set_comp_visible("page02", TRUE)
   END IF 
   CALL q998_set_visible()
   CALL cl_show_fld_cont()                   
END FUNCTION

FUNCTION aimq998()              
DEFINE   p_wc        STRING,
         l_sql       STRING      
DEFINE l_pia40    LIKE pia_file.pia40 
DEFINE l_pia60    LIKE pia_file.pia60,
       l_pia50    LIKE pia_file.pia50,
       l_ima12    LIKE ima_file.ima12,
       l_azf03    LIKE azf_file.azf03,
       l_plant    LIKE pia_file.piaplant,
       l_str,l_str1,l_str2,l_wc STRING ,
       l_flag     LIKE type_file.chr1,
       l_msg      STRING
DEFINE l_n    LIKE type_file.num5
DEFINE l_order1,l_order2,l_order3 LIKE type_file.chr100
DEFINE l_name     LIKE type_file.chr20 
DEFINE l_msg2    STRING   #FUN-C80092
DEFINE m_wc      STRING   #FUN-C80092
DEFINE l_bdate,l_edate  LIKE type_file.dat 
DEFINE l_diff_tot LIKE pia_file.pia30
DEFINE l_diff_c_tot   LIKE ccc_file.ccc23 

   LET g_yy = tm.yy        
   LET g_mm = tm.mm        
   IF NOT cl_null(g_bgjob) AND g_bgjob = 'Y' THEN 
      LET g_wc = " azw01 = '",g_plant CLIPPED,"'"
      LET g_yy = g_argv1     
      LET g_mm = g_argv2
     #MOD-D60247--begin
      LET tm.yy = g_argv1     
      LET tm.mm = g_argv2
     #MOD-D60247--end
      LET tm.ctype = g_argv3
      LET tm.z = g_argv4
      LET tm.d = 'N'
      LET tm.e = '3'
      LET tm.f = '3'
   END IF
#FUN-C80092 ---------------Begin---------------
   LET m_wc = g_wc CLIPPED,";",tm.wc CLIPPED 
   LET l_msg2 = "tm.yy = '",tm.yy,"'",";","tm.mm = '",tm.mm,"'",";","tm.ctype = '",tm.ctype,"'",";",
                "tm.d = '",tm.d,"'",";","tm.e = '",tm.e,"'",";","tm.f = '",tm.f,"'",";","tm.z = '",tm.z,"'"
   CALL s_log_ins(g_prog,'','',m_wc,l_msg2)
        RETURNING g_cka00
#FUN-C80092 ---------------End-----------------

   DELETE FROM aimq998_tmp    #清空臨時表          #FUN-D10022 add
   CALL s_ymtodate(g_yy,g_mm,g_yy,g_mm) RETURNING l_bdate,l_edate
   IF cl_null(tm.wc) THEN LET tm.wc = " 1=1" END IF
   SELECT azi05 INTO g_azi_azi05 FROM azi_file WHERE azi01=g_aza.aza17
   IF cl_null(g_wc) THEN LET g_wc = " 1=1" END IF
   IF cl_null(g_filter_wc) THEN LET g_filter_wc=" 1=1" END IF
   IF cl_null(g_filter_plant_wc) THEN LET g_filter_plant_wc=" 1=1" END IF
   LET g_sql = "SELECT azw01 FROM azw_file,azp_file ",
               " WHERE azp01 = azw01 AND azwacti = 'Y'",
               "   AND azw01 IN (SELECT zxy03 FROM zxy_file WHERE zxy01 = '",g_user,"')",
               "   AND ",g_wc CLIPPED,
               "   AND ",g_filter_plant_wc CLIPPED
   PREPARE sel_azw01_pre FROM g_sql
   DECLARE sel_azw01_cur CURSOR WITH HOLD FOR sel_azw01_pre

   FOREACH sel_azw01_cur INTO m_plant
      IF cl_null(m_plant) THEN CONTINUE FOREACH END IF 
   
        #如果計價年月空白，則採現行年月(modi in 010607)
        IF cl_null(tm.yy) OR cl_null(tm.mm) THEN
           LET l_sql = "SELECT ccz01,ccz02 ", 
                       "  FROM ",cl_get_target_table(m_plant, 'ccz_file'),   
                       " WHERE ccz00 = '0'"
           CALL cl_replace_sqldb(l_sql) RETURNING l_sql    
           CALL cl_parse_qry_sql(l_sql,m_plant) RETURNING l_sql   
           PREPARE ccz_prepare1 FROM l_sql                                                                                         
             DECLARE ccz_c1  CURSOR FOR ccz_prepare1                                                                               
             OPEN ccz_c1                                                                                                             
             FETCH ccz_c1 INTO g_yy,g_mm      
        END IF     
        LET l_sql = "SELECT azi03,azi04 ",
                    "  FROM ",cl_get_target_table(m_plant, 'azi_file'),   
                    " WHERE azi01 = '",g_aza.aza17,"'"
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql    
        CALL cl_parse_qry_sql(l_sql,m_plant) RETURNING l_sql  
        PREPARE azi_prepare1 FROM l_sql                                                                                         
        DECLARE azi_c1  CURSOR FOR azi_prepare1                                                                               
        OPEN azi_c1                                                                                                             
        FETCH azi_c1 INTO g_azi_azi03,g_azi_azi04 

   #--------------------------------------l_sql--------------------------------
        LET l_sql = "SELECT  '",m_plant CLIPPED,
                    "',NVL(TRIM(ima12),'') ima12,azf03,NVL(TRIM(pia02),'') pia02,ima02,ima021,NVL(TRIM(ccc08),'') ccc08,NVL(TRIM(pia03),'') pia03,",
                    "NVL(TRIM(pia04),'') pia04,NVL(TRIM(pia05),'') pia05,NVL(TRIM(img09),'') img09,NVL(pia08,0) pia08,",
                    "NVL(pia08*ccc23,0) pia08_c,pia01,NVL(pia30,0) pia30,NVL(pia30*ccc23,0) pia30_c,NVL(pia30-pia08,0) diff,",
                    "NVL((pia30-pia08)*ccc23,0) diff_c,'' x45,ccc23,pia40,pia60,pia50,",g_azi_azi03,",",g_azi_azi04,",",g_azi_azi05,
                   "  FROM ",cl_get_target_table(m_plant, 'pia_file')," LEFT OUTER JOIN ",cl_get_target_table(m_plant, 'img_file'),
                   "                                                    ON  img01=pia02 ",
                   "                                                    AND img02=pia03 ",
                   "                                                    AND img03=pia04 ",
                   "                                                    AND img04=pia05,",
                             cl_get_target_table(m_plant, 'ima_file')," LEFT OUTER JOIN ",cl_get_target_table(m_plant, 'azf_file'),
                   "                                                    ON  azf_file.azf01=ima12 ",
                   "                                                    AND azf_file.azf02='G',  ",
                             cl_get_target_table(m_plant, 'ccc_file')
   
   
        LET l_str1 = " WHERE pia02=ima01 ",   #FUN-9C0170
                     "   AND pia02=ccc01 ",
                     "   AND pia03 NOT IN (SELECT jce02 FROM ",cl_get_target_table(m_plant, 'jce_file'),")",   #FUN-A70084
                     "   AND ccc02= ",g_yy,                  #MOD-C10048 add
                     "   AND ccc07='",tm.ctype,"'",          #FUN-9C0170 
                     "   AND ccc03= ",g_mm                   #MOD-C10048 add
        IF tm.ctype = '5' THEN
            LET l_str  = ",", cl_get_target_table(m_plant, 'imd_file')    #FUN-A70084  
        ELSE
           LET l_str = ''
        END IF
         IF tm.f = '1' OR tm.f = '3' THEN
           LET l_str = l_str,",",cl_get_target_table(m_plant, 'tlf_file')
           LET l_str1= l_str1," AND tlf905=pia01"
        END IF
        #無盤盈虧差異者..
        IF tm.d='N' THEN 
           LET l_str1 = l_str1," AND NVL(pia08,0)<>NVL(pia30,0) "
        END IF 
        #------------------------------------------------------------
        #選擇只印盤盈時過濾盤虧資料
        IF tm.e='1' THEN
           LET l_str1 = l_str1," AND NVL(pia08,0)<=NVL(pia30,0) "
        END IF 
        #------------------------------------------------------------
        #選擇只印盤虧時過濾盤盈資料
        IF tm.e='2' THEN
           LET l_str1 = l_str1," AND NVL(pia08,0)>=NVL(pia30,0) "
        END IF 
        
        CASE tm.ctype
          WHEN '3'
             LET l_str2 = " AND img04 = ccc08 "
          WHEN '5'
             LET l_str2 = " AND img02 = imd01 AND imd09=ccc08"
          OTHERWISE
             LET l_str2 = ''
        END CASE
        LET l_sql = l_sql,l_str,l_str1,l_str2
   #FUN-9C0170--end--add----------------------------------
        DISPLAY "l_sql:",l_sql
        CASE WHEN tm.f = '1' LET l_sql = l_sql CLIPPED," AND pia19='Y' AND tlf06 BETWEEN '",l_bdate CLIPPED,"' AND '",l_edate CLIPPED,"'"
             WHEN tm.f = '2' LET l_sql = l_sql CLIPPED," AND pia19<>'Y' "
             WHEN tm.f = '3' LET l_sql = l_sql CLIPPED," AND ((pia19='Y' AND tlf06 BETWEEN '",l_bdate CLIPPED,"' AND '",l_edate CLIPPED,"')",
                                                       " OR pia19<>'Y')"
        END CASE 
        LET l_sql = l_sql CLIPPED," AND ",tm.wc CLIPPED," AND ",g_filter_wc CLIPPED


        CALL cl_replace_sqldb(l_sql) RETURNING l_sql  
        CALL cl_parse_qry_sql(l_sql,m_plant) RETURNING l_sql  

        LET l_sql = " INSERT INTO aimq998_tmp ",l_sql CLIPPED 
        PREPARE q998_ins FROM l_sql
        EXECUTE q998_ins

        LET l_sql = " UPDATE aimq998_tmp ",
                    "    SET pia30 = pia60 ",
                    "   WHERE pia60 IS NOT NULL",
                    "     AND pia60 <> ''",
                    "     AND azp01 = '",m_plant CLIPPED,"'"
        PREPARE q998_pre1 FROM l_sql
        EXECUTE q998_pre1 

        LET l_sql = " UPDATE aimq998_tmp ",
                    "    SET pia30 = pia50 ",
                    "   WHERE pia50 IS NOT NULL",
                    "     AND pia50 <> '' ",
                    "     AND (pia60 = '' OR pia60 IS NULL)",
                    "     AND azp01 = '",m_plant CLIPPED,"'"
        PREPARE q998_pre2 FROM l_sql
        EXECUTE q998_pre2

        LET l_sql = " UPDATE aimq998_tmp ",
                    "    SET pia30 = pia40 ",
                    "  WHERE pia40 IS NOT NULL",
                    "    AND pia40 <> '' ",
                    "    AND (pia60 = '' OR pia60 IS NULL)",
                    "    AND (pia50 = '' OR pia50 IS NULL)",
                    "     AND azp01 = '",m_plant CLIPPED,"'"
        PREPARE q998_pre3 FROM l_sql
        EXECUTE q998_pre3

        LET l_sql = "UPDATE aimq998_tmp ",
                    "   SET pia08_c = pia08 * ccc23,",
                    "       pia30_c = pia30 * ccc23,",
                    "       diff    = pia30 - pia08",
                    "  WHERE azp01 = '",m_plant CLIPPED,"'"
        PREPARE q998_pre6 FROM l_sql
        EXECUTE q998_pre6

        LET l_sql = "UPDATE aimq998_tmp ",
                    "   SET diff_c = diff * ccc23",
                    " WHERE azp01 = '",m_plant CLIPPED,"'"
        PREPARE q998_pre7 FROM l_sql
        EXECUTE q998_pre7            
    
        LET l_sql = " UPDATE aimq998_tmp",
                    "    SET x45 = '*' ",
                    " WHERE (diff_c > 5000 ",
                    "    OR diff_c < -5000)",
                    "   AND azp01 = '",m_plant CLIPPED,"'"
        PREPARE q998_pre4 FROM l_sql
        EXECUTE q998_pre4

        LET l_sql = " UPDATE aimq998_tmp",
                    "    SET x45 = ' ' ",
                    " WHERE diff_c <= 5000 ",
                    "   AND diff_c >= -5000",
                    "   AND azp01 = '",m_plant CLIPPED,"'" 
        PREPARE q998_pre5 FROM l_sql
        EXECUTE q998_pre5

#       LET l_sql = "UPDATE aimq998_tmp ",
#                   "   SET pia08 = round(pia08,",g_azi_azi04,"),",
#                   "     pia08_c =round(pia08_c,",g_azi_azi05,"),",
#                   "       pia30 = round(pia30,",g_azi_azi04,"),",
#                   "     pia30_c =round(pia30_c,",g_azi_azi05,"),",
#                   "        diff = round(diff,",g_azi_azi04,"),",
#                   "      diff_c = round(diff_c,",g_azi_azi05,"),",
#                   "       ccc23 = round(ccc23,",g_azi_azi03,")"
#       PREPARE q998_pre8 FROM l_sql
#       EXECUTE q998_pre8

        LET l_n = 0
        LET l_diff_tot = 0
        LET l_diff_c_tot = 0
        LET l_sql = "SELECT COUNT(*),SUM(diff),SUM(diff_c) FROM aimq998_tmp",
                    " WHERE azp01 = '",m_plant CLIPPED,"'"
        PREPARE q998_pre9 FROM l_sql
        EXECUTE q998_pre9 INTO l_n,l_diff_tot,l_diff_c_tot
        
       #IF tm.z = 'Y' AND l_n > 0     #MOD-D60247 mark
        IF tm.z = 'Y' AND l_n >= 0    #MOD-D60247
           AND g_filter_plant_wc = " 1=1"  
           AND g_filter_wc = " 1=1" THEN
         LET g_ckk.ckk17 = g_wc," ",tm.wc
         CALL s_ckk_fill('','316','axc-447',tm.yy,tm.mm,g_prog,tm.ctype,l_diff_tot,l_diff_c_tot,'','','','',  
                        '','','','',g_ckk.ckk17,g_user,g_today,g_time,'Y') RETURNING g_ckk.*
         IF NOT s_ckk(g_ckk.*,m_plant) THEN END IF
      END IF
   END FOREACH     
   
    CALL s_log_upd(g_cka00,'Y')       #MOD-D60247 add
END FUNCTION
 
FUNCTION q998_bp(p_ud)
DEFINE   p_ud   LIKE type_file.chr1          
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
   
   LET g_action_flag = 'page01'
   IF g_action_choice = "page01" AND NOT cl_null(tm.a) AND g_flag != '1' THEN
      CALL q998_b_fill()
   END IF
   LET g_flag = ' '
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY BY NAME tm.yy,tm.mm
   DISPLAY g_rec_b TO FORMONLY.cn2
   DISPLAY BY NAME sr1.*

   DIALOG ATTRIBUTES(UNBUFFERED)
      INPUT tm.a FROM a ATTRIBUTE(WITHOUT DEFAULTS)
         ON CHANGE a
            IF NOT cl_null(tm.a)  THEN 
               CALL q998_b_fill_2()
               CALL q998_set_visible()
               CALL cl_set_comp_visible("page01", FALSE)
               CALL ui.interface.refresh()
               CALL cl_set_comp_visible("page01", TRUE)
               LET g_action_choice = "page02"
            ELSE
               CALL q998_b_fill()
               CALL g_tlf_1.clear()
            END IF
            DISPLAY BY NAME tm.a
            EXIT DIALOG
      END INPUT
      DISPLAY ARRAY g_tlf TO s_tlf.* ATTRIBUTE(COUNT=g_rec_b)
         BEFORE ROW
            LET l_ac = ARR_CURR()
      END DISPLAY
      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG

      ON ACTION page02
         LET g_action_choice = 'page02'
         EXIT DIALOG

      ON ACTION data_filter
         LET g_action_choice="data_filter"
         EXIT DIALOG     

      ON ACTION revert_filter         
         LET g_action_choice="revert_filter"
         EXIT DIALOG 

      ON ACTION refresh_detail          #明細資料刷新
         CALL cl_set_comp_visible("page02", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page02", TRUE)
         LET g_action_choice = 'page01' 
         EXIT DIALOG
 
      ON ACTION HELP
         LET g_action_choice="help"
         EXIT DIALOG
 
      ON ACTION locale
         CALL cl_dynamic_locale()
 
      ON ACTION EXIT
         LET g_action_choice="exit"
         EXIT DIALOG
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG
 
      ON ACTION CANCEL
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
   END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION q998_set_visible()
   CALL cl_set_comp_visible("azp01_1,ima12_1,azf03_1,pia02_1,ima02_1,ima021_1",TRUE)
   CALL cl_set_comp_visible("ccc08_1,pia01_1,pia03_1,pia04_1,pia05_1",TRUE)
   CASE tm.a
       WHEN '1'
          CALL cl_set_comp_visible("azp01_1,pia02_1,ima02_1,ima021_1",FALSE)
          CALL cl_set_comp_visible("ccc08_1,pia01_1,pia03_1,pia04_1,pia05_1",FALSE)
       WHEN '2'
          CALL cl_set_comp_visible("azp01_1,ima12_1,azf03_1",FALSE)
          CALL cl_set_comp_visible("ccc08_1,pia01_1,pia03_1,pia04_1,pia05_1",FALSE) 
       WHEN '3'
          CALL cl_set_comp_visible("azp01_1,ima12_1,azf03_1,pia02_1,ima02_1,ima021_1",FALSE)
          CALL cl_set_comp_visible("ccc08_1,pia01_1,pia03_1,pia04_1",FALSE)
       WHEN '4'
          CALL cl_set_comp_visible("azp01_1,ima12_1,azf03_1,pia02_1,ima02_1,ima021_1",FALSE)
          CALL cl_set_comp_visible("ccc08_1,pia01_1,pia04_1,pia05_1",FALSE)
       WHEN '5'
          CALL cl_set_comp_visible("azp01_1,ima12_1,azf03_1,pia02_1,ima02_1,ima021_1",FALSE)
          CALL cl_set_comp_visible("ccc08_1,pia01_1,pia03_1,pia05_1",FALSE)
       WHEN '6'
          CALL cl_set_comp_visible("azp01_1,ima12_1,azf03_1,pia02_1,ima02_1,ima021_1",FALSE)
          CALL cl_set_comp_visible("ccc08_1,pia03_1,pia04_1,pia05_1",FALSE)
       WHEN '7'
          CALL cl_set_comp_visible("ima12_1,azf03_1,pia02_1,ima02_1,ima021_1",FALSE)
          CALL cl_set_comp_visible("ccc08_1,pia01_1,pia03_1,pia04_1,pia05_1",FALSE)
       WHEN '8'
          CALL cl_set_comp_visible("azp01_1,ima12_1,azf03_1,pia02_1,ima02_1,ima021_1",FALSE)
          CALL cl_set_comp_visible("pia01_1,pia03_1,pia04_1,pia05_1",FALSE)
   END CASE
END FUNCTION 

FUNCTION q998_table()
DEFINE l_sql    STRING

LET l_sql = "CREATE TEMP TABLE aimq998_tmp( ", 
              "azp01    LIKE azp_file.azp01,",
              "ima12    LIKE ima_file.ima12,",
              "azf03    LIKE azf_file.azf03,",  
              "pia02    LIKE pia_file.pia02,",
              "ima02    LIKE ima_file.ima02,",
              "ima021   LIKE ima_file.ima021,",
              "ccc08    LIKE ccc_file.ccc08,",
              "pia03    LIKE pia_file.pia03,",
              "pia04    LIKE pia_file.pia04,",
              "pia05    LIKE pia_file.pia05,",
              "img09    LIKE type_file.chr100,",
              "pia08    LIKE pia_file.pia08,",
              "pia08_c  LIKE ccc_file.ccc23,",
              "pia01    LIKE pia_file.pia01,",
              "pia30    LIKE pia_file.pia30,",
              "pia30_c  LIKE ccc_file.ccc23,",
              "diff     LIKE pia_file.pia30,",
              "diff_c   LIKE ccc_file.ccc23,",
              "x45      LIKE type_file.chr100,",
              "ccc23    LIKE ccc_file.ccc23,",
              "pia40    LIKE pia_file.pia40,",
              "pia60    LIKE pia_file.pia60,",
              "pia50    LIKE pia_file.pia50,",
              "azi03    LIKE azi_file.azi03,",
              "azi04    LIKE azi_file.azi04,",
              "azi05    LIKE azi_file.azi05)"
PREPARE q998_table_pre FROM l_sql
EXECUTE q998_table_pre    
END FUNCTION 

FUNCTION q998_filter_askkey()
DEFINE l_wc   STRING
DEFINE l_plant_wc STRING
   CLEAR FORM

   DIALOG ATTRIBUTE(UNBUFFERED)
   
      CONSTRUCT l_plant_wc ON azp01 FROM s_tlf[1].azp01
      
      END CONSTRUCT

      CONSTRUCT l_wc ON ima12,pia02,ccc08,pia01,pia03,pia04,pia05
                    FROM s_tlf[1].ima12,s_tlf[1].pia02,s_tlf[1].ccc08,s_tlf[1].pia01,
                         s_tlf[1].pia03,s_tlf[1].pia04,s_tlf[1].pia05
      END CONSTRUCT
      ON ACTION controlp
         IF INFIELD(azp01) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_azw"
            LET g_qryparam.state = "c"
               LET g_qryparam.where = "azw02 = '",g_legal,"' ",
                                      " AND azw01 IN(SELECT zxy03 FROM zxy_file WHERE zxy01 = '",g_user,"' )"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO azp01
               NEXT FIELD azp01 
            END IF   
            
         IF INFIELD(pia02) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_ima"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO pia02
            NEXT FIELD pia02
         END IF

         IF INFIELD(ima12) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_azf"
            LET g_qryparam.state = "c"
            LET g_qryparam.arg1  = "G"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO ima12 
            NEXT FIELD ima12    
         END IF 

         IF INFIELD(pia03) THEN #倉庫
            CALL q_imd_1(TRUE,TRUE,"","","","","") RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO pia03
            NEXT FIELD pia03
         END IF 

         IF INFIELD(pia04) THEN #儲位
            CALL q_ime_1(TRUE,TRUE,"","","",g_plant,"","","") RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO pia04
            NEXT FIELD pia04
         END IF 

         IF INFIELD(pia05) THEN#批號
            CALL cl_init_qry_var()
            LET g_qryparam.state    = "c"
            LET g_qryparam.form     = "q_img"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO pia05
            NEXT FIELD pia05
         END IF 
         #FUN-D10022---add---str---
         IF INFIELD(ccc08) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.state    = "c"
            LET g_qryparam.form     = "q_ccc08"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO ccc08
            NEXT FIELD ccc08
         END IF

         IF INFIELD(pia01) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.state  = "c"
            LET g_qryparam.form   = "q_pia01"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO pia01
            NEXT FIELD pia01
         END IF 
         #FUN-D10022---add---end---
       ON ACTION CONTROLZ
          CALL cl_show_req_fields()

       ON ACTION CONTROLG 
          CALL cl_cmdask()
   
       ON ACTION ACCEPT        
          ACCEPT DIALOG

       ON ACTION CANCEL
          LET INT_FLAG=1
          EXIT DIALOG 
         
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE DIALOG
 
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
 
       ON ACTION HELP          #MOD-4C0121
          CALL cl_show_help()  #MOD-4C0121
 
       ON ACTION EXIT
          LET INT_FLAG = 1
          EXIT DIALOG

       ON ACTION qbe_save
          CALL cl_qbe_save()

       ON ACTION qbe_select
          CALL cl_qbe_select()

      BEFORE DIALOG
         DISPLAY BY NAME tm.d,tm.e,tm.f,tm.a,tm.z,
                         tm.yy,tm.mm,tm.ctype
         CALL cl_qbe_init()
   END DIALOG
   IF INT_FLAG THEN 
      LET g_filter_wc = ''
      LET g_filter_plant_wc = ''
      CALL cl_set_act_visible("revert_filter",FALSE)
      LET INT_FLAG = 0
      RETURN 
   END IF
   IF cl_null(l_wc) THEN LET l_wc =" 1=1" END IF 
   IF cl_null(l_plant_wc) THEN LET l_plant_wc =" 1=1" END IF
   IF l_wc !=" 1=1" OR l_plant_wc != " 1=1" THEN
      CALL cl_set_act_visible("revert_filter",TRUE)
   END IF 
   IF cl_null(g_filter_wc) THEN LET g_filter_wc = " 1=1" END IF
   IF cl_null(g_filter_plant_wc) THEN LET g_filter_plant_wc = " 1=1" END IF
   LET g_filter_wc = g_filter_wc CLIPPED," AND ",l_wc CLIPPED
   LET g_filter_plant_wc = g_filter_plant_wc CLIPPED," AND ",l_plant_wc CLIPPED
END FUNCTION

FUNCTION q998_b_fill()
DEFINE    g_ckk      RECORD LIKE ckk_file.*
DEFINE    l_msg      STRING  
DEFINE    l_azi03    LIKE azi_file.azi03
DEFINE    l_azi04    LIKE azi_file.azi04
DEFINE    l_azi05    LIKE azi_file.azi05
   LET g_sql = "SELECT azp01,ima12,azf03,pia02,ima02,ima021,ccc08,pia01,pia03,pia04,",
               "       pia05,img09,round(pia08,azi04),round(pia08_c,azi05),round(pia30,azi04),",
               "       round(pia30_c,azi05),round(diff,azi04),round(diff_c,azi05),x45,round(ccc23,azi03)",
#               "       azi03,azi04,azi05"
               "  FROM aimq998_tmp"
               
   PREPARE aimq998_pb FROM g_sql
   DECLARE tlf_curs  CURSOR FOR aimq998_pb        #CURSOR

   CALL g_tlf.clear()
   CALL g_tlf_excel.clear()
   LET g_cnt = 1
   LET g_rec_b = 0
   
   FOREACH tlf_curs INTO g_tlf_excel[g_cnt].*   #,l_azi03,l_azi04,l_azi05
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      IF g_cnt <= g_max_rec THEN 
         LET g_tlf[g_cnt].* = g_tlf_excel[g_cnt].*
      END IF 
      LET g_cnt = g_cnt + 1 
   END FOREACH

   CALL q998_get_tot()
   IF g_cnt <= g_max_rec THEN 
      CALL g_tlf.deleteElement(g_cnt)
   END IF 
   CALL g_tlf_excel.deleteElement(g_cnt)
   LET g_cnt = g_cnt -1      
   LET g_rec_b = g_cnt
   CALL s_log_upd(g_cka00,'Y')             #更新日誌  #FUN-C80092
   IF g_rec_b > g_max_rec AND (g_bgjob is null OR g_bgjob='N') THEN
      CALL cl_err_msg(NULL,"axc-131",g_rec_b||"|"||g_max_rec,10)
      LET g_rec_b  = g_max_rec 
   END IF 
   DISPLAY g_rec_b TO FORMONLY.cn2

END FUNCTION

FUNCTION q998_b_fill_2()

   CALL g_tlf_1.clear()
   LET g_rec_b2 = 0
   LET g_cnt = 1
   CALL q998_get_tot()
   CALL q998_get_sum()
     
END FUNCTION

FUNCTION q998_get_sum()
DEFINE l_wc     STRING
DEFINE l_sql    STRING

   CASE tm.a
      WHEN '1'
         LET l_sql = "SELECT '',ima12,azf03,'','','','','','','','',img09,",
                     "       SUM(round(pia08,azi04)),SUM(round(pia08_c,azi05)),",
                     "       SUM(round(pia30,azi04)),SUM(round(pia30_c,azi05)),",
                     "       SUM(round(diff,azi04)),SUM(round(diff_c,azi05)),x45,SUM(round(ccc23,azi03))",
                     "  FROM aimq998_tmp",
                     " GROUP BY ima12,azf03,img09,x45",
                     " ORDER BY ima12,azf03,img09,x45"
      WHEN '2'
         LET l_sql = "SELECT '','','',pia02,ima02,ima021,'','','','','',img09,",
                     "       SUM(round(pia08,azi04)),SUM(round(pia08_c,azi05)),",
                     "       SUM(round(pia30,azi04)),SUM(round(pia30_c,azi05)),",
                     "       SUM(round(diff,azi04)),SUM(round(diff_c,azi05)),x45,SUM(round(ccc23,azi03))",
                     "  FROM aimq998_tmp",
                     " GROUP BY pia02,ima02,ima021,img09,x45",
                     " ORDER BY pia02,ima02,ima021,img09,x45"
      WHEN '3'
         LET l_sql = "SELECT '','','','','','','','','','',pia05,img09,",
                     "       SUM(round(pia08,azi04)),SUM(round(pia08_c,azi05)),",
                     "       SUM(round(pia30,azi04)),SUM(round(pia30_c,azi05)),",
                     "       SUM(round(diff,azi04)),SUM(round(diff_c,azi05)),x45,SUM(round(ccc23,azi03))",
                     "  FROM aimq998_tmp",
                     " GROUP BY pia05,img09,x45",
                     " ORDER BY pia05,img09,x45"
      WHEN '4'
         LET l_sql = "SELECT '','','','','','','','',pia03,'','',img09,",
                     "       SUM(round(pia08,azi04)),SUM(round(pia08_c,azi05)),",
                     "       SUM(round(pia30,azi04)),SUM(round(pia30_c,azi05)),",
                     "       SUM(round(diff,azi04)),SUM(round(diff_c,azi05)),x45,SUM(round(ccc23,azi03))",
                     "  FROM aimq998_tmp",
                     " GROUP BY pia03,img09,x45",
                     " ORDER BY pia03,img09,x45"
      WHEN '5'
         LET l_sql = "SELECT '','','','','','','','','',pia04,'',img09,",
                     "       SUM(round(pia08,azi04)),SUM(round(pia08_c,azi05)),",
                     "       SUM(round(pia30,azi04)),SUM(round(pia30_c,azi05)),",
                     "       SUM(round(diff,azi04)),SUM(round(diff_c,azi05)),x45,SUM(round(ccc23,azi03))",
                     "  FROM aimq998_tmp",
                     " GROUP BY pia04,img09,x45",
                     " ORDER BY pia04,img09,x45"
      WHEN '6'
         LET l_sql = "SELECT '','','','','','','',pia01,'','','',img09,",
                     "       SUM(round(pia08,azi04)),SUM(round(pia08_c,azi05)),",
                     "       SUM(round(pia30,azi04)),SUM(round(pia30_c,azi05)),",
                     "       SUM(round(diff,azi04)),SUM(round(diff_c,azi05)),x45,SUM(round(ccc23,azi03))",
                     "  FROM aimq998_tmp",
                     " GROUP BY pia01,img09,x45",
                     " ORDER BY pia01,img09,x45"
      WHEN '7'
         LET l_sql = "SELECT azp01,'','','','','','','','','','',img09,",
                     "       SUM(round(pia08,azi04)),SUM(round(pia08_c,azi05)),",
                     "       SUM(round(pia30,azi04)),SUM(round(pia30_c,azi05)),",
                     "       SUM(round(diff,azi04)),SUM(round(diff_c,azi05)),x45,SUM(round(ccc23,azi03))",
                     "  FROM aimq998_tmp",
                     " GROUP BY azp01,img09,x45",
                     " ORDER BY azp01,img09,x45"
      WHEN '8'
         LET l_sql = "SELECT '','','','','','',ccc08,'','','','',img09,",
                     "       SUM(round(pia08,azi04)),SUM(round(pia08_c,azi05)),",
                     "       SUM(round(pia30,azi04)),SUM(round(pia30_c,azi05)),",
                     "       SUM(round(diff,azi04)),SUM(round(diff_c,azi05)),x45,SUM(round(ccc23,azi03))",
                     "  FROM aimq998_tmp",
                     " GROUP BY ccc08,img09,x45",
                     " ORDER BY ccc08,img09,x45"
   END CASE 

   PREPARE q998_pb FROM l_sql
   DECLARE q998_curs1 CURSOR FOR q998_pb
   FOREACH q998_curs1 INTO g_tlf_1_excel[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      IF g_cnt <= g_max_rec THEN 
         LET g_tlf_1[g_cnt].* = g_tlf_1_excel[g_cnt].*
      END IF 
      LET g_cnt = g_cnt + 1
   END FOREACH
   DISPLAY ARRAY g_tlf_1 TO s_tlf_1.* ATTRIBUTE(COUNT=g_cnt)
      BEFORE DISPLAY
         EXIT DISPLAY
   END DISPLAY
 
   IF g_cnt <= g_max_rec THEN 
      CALL g_tlf_1.deleteElement(g_cnt)
   END IF 
   CALL g_tlf_1_excel.deleteElement(g_cnt)
   LET g_cnt = g_cnt -1      
   LET g_rec_b2 = g_cnt
   IF g_rec_b2 > g_max_rec AND (g_bgjob is null OR g_bgjob='N') THEN
      CALL cl_err_msg(NULL,"axc-131",g_rec_b2||"|"||g_max_rec,10)
      LET g_rec_b2  = g_max_rec 
   END IF
   DISPLAY g_rec_b2 TO FORMONLY.cn2 
END FUNCTION 

FUNCTION q998_get_tot()
    LET sr1.pia08_tot = 0
    LET sr1.pia08_c_tot = 0                                          
    LET sr1.pia30_tot   = 0 
    LET sr1.pia30_c_tot = 0  
    LET sr1.diff_tot  = 0   
    LET sr1.diff_c_tot = 0
    SELECT SUM(round(pia08,azi04)),SUM(round(pia08_c,azi05)),SUM(round(pia30,azi04)),SUM(round(pia30_c,azi05)),
           SUM(round(diff,azi04)),SUM(round(diff_c,azi05))
      INTO sr1.pia08_tot,sr1.pia08_c_tot,sr1.pia30_tot,    
           sr1.pia30_c_tot,sr1.diff_tot,sr1.diff_c_tot
      FROM aimq998_tmp
END FUNCTION 

FUNCTION q998_bp2()
       
   LET g_flag = ' '
   LET g_action_flag = 'page02'
   CALL cl_set_act_visible("accept,cancel", FALSE)
   CALL q998_b_fill_2()
   DISPLAY  tm.a TO a
   DISPLAY  tm.e TO e
   DISPLAY  tm.f TO f
   DISPLAY BY NAME tm.yy,tm.mm 
   DISPLAY g_rec_b2 TO FORMONLY.cn2
   DISPLAY BY NAME sr1.*
   DIALOG ATTRIBUTES(UNBUFFERED)
      INPUT tm.a FROM a ATTRIBUTE(WITHOUT DEFAULTS)
         ON CHANGE a
            IF NOT cl_null(tm.a)  THEN 
               CALL q998_b_fill_2()
               CALL q998_set_visible()
               LET g_action_choice = "page02"
            END IF
            DISPLAY  tm.a TO a
            EXIT DIALOG
      END INPUT
      DISPLAY ARRAY g_tlf_1 TO s_tlf_1.* ATTRIBUTE(COUNT=g_rec_b2)
         BEFORE ROW
            LET l_ac = ARR_CURR()
            CALL cl_show_fld_cont()

      END DISPLAY

      ON ACTION page01
         LET g_action_choice="page01"
         EXIT DIALOG

      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG      
 
      ON ACTION ACCEPT
         LET l_ac1 = ARR_CURR()
         IF NOT cl_null(g_action_choice) AND l_ac1 > 0  THEN
            CALL q998_detail_fill(l_ac1)
            CALL cl_set_comp_visible("page02", FALSE)
            CALL ui.interface.refresh()
            CALL cl_set_comp_visible("page02", TRUE)
            LET g_action_choice= "page01"  
            LET g_flag = '1'             
            EXIT DIALOG 
         END IF
   

      ON ACTION refresh_detail
         CALL cl_set_comp_visible("page02", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page02", TRUE)
         LET g_action_choice = 'page01' 
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
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG

      AFTER DIALOG
         CONTINUE DIALOG

      ON ACTION controls                    
         CALL cl_set_head_visible("","AUTO")
   END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION q998_detail_fill(p_ac)
   DEFINE p_ac         LIKE type_file.num5,  
          l_sql        STRING, 
          l_sql1       STRING,
          l_sql2       STRING,
          l_tmp        STRING 
   LET l_sql = "SELECT azp01,ima12,azf03,pia02,ima02,ima021,ccc08,pia01,pia03,pia04,",
               "       pia05,img09,round(pia08,azi04),round(pia08_c,azi05),round(pia30,azi04),",
               "       round(pia30_c,azi05),round(diff,azi04),round(diff_c,azi05),x45,round(ccc23,azi03)",
               "  FROM aimq998_tmp"
               
   LET l_sql1= "SELECT SUM(round(pia08,azi04)),SUM(round(pia08_c,azi05)),SUM(round(pia30,azi04)),",
               "SUM(round(pia30_c,azi05)),SUM(round(diff,azi04)),SUM(round(diff_c,azi05))",
               "  FROM aimq998_tmp WHERE 1=1 "


   CASE tm.a 
      WHEN "1" 
         IF cl_null(g_tlf_1[p_ac].ima12) THEN 
            LET l_tmp = " OR ima12 IS NULL "
         ELSE 
            LET l_tmp = ''
         END IF 
         LET l_sql = l_sql," WHERE (ima12 = '",g_tlf_1[p_ac].ima12 CLIPPED,"'",l_tmp," )",
                           " ORDER BY ima12,azf03"
         LET l_sql1= l_sql1," AND  (ima12 = '",g_tlf_1[p_ac].ima12 CLIPPED,"'",l_tmp," )",
                           " GROUP BY ima12,azf03",
                           " ORDER BY ima12,azf03"

      WHEN "2"
         IF cl_null(g_tlf_1[p_ac].pia02) THEN 
            LET l_tmp = " OR pia02 IS NULL "
         ELSE 
            LET l_tmp = ''
         END IF 
         LET l_sql = l_sql," WHERE (pia02 = '",g_tlf_1[p_ac].pia02 CLIPPED,"'",l_tmp," )",
                           " ORDER BY pia02,ima02,ima021"
         LET l_sql1= l_sql1," AND  (pia02 = '",g_tlf_1[p_ac].pia02 CLIPPED,"'",l_tmp," )",
                            " GROUP BY pia02,ima02,ima021",
                            " ORDER BY pia02,ima02,ima021"
         
      WHEN "3"
         IF cl_null(g_tlf_1[p_ac].pia05) THEN 
            LET l_tmp = " OR pia05 IS NULL "
         ELSE 
            LET l_tmp = ''
         END IF 
         LET l_sql = l_sql," WHERE (pia05 = '",g_tlf_1[p_ac].pia05 CLIPPED,"'",l_tmp," )",
                           " ORDER BY pia05"
         LET l_sql1= l_sql1," AND  (pia05 = '",g_tlf_1[p_ac].pia05 CLIPPED,"'",l_tmp," )",
                            " GROUP BY pia05",
                            " ORDER BY pia05"

      WHEN "4"
         IF cl_null(g_tlf_1[p_ac].pia03) THEN 
            LET l_tmp = " OR pia03 IS NULL "
         ELSE 
            LET l_tmp = ''
         END IF 
         LET l_sql = l_sql," WHERE (pia03 = '",g_tlf_1[p_ac].pia03 CLIPPED,"'",l_tmp," )",
                           " ORDER BY pia03"
         LET l_sql1= l_sql1," AND  (pia03 = '",g_tlf_1[p_ac].pia03 CLIPPED,"'",l_tmp," )",
                            " GROUP BY pia03",
                            " ORDER BY pia03"
         
      WHEN "5"
         IF cl_null(g_tlf_1[p_ac].pia04) THEN 
            LET l_tmp = " OR pia04 IS NULL "
         ELSE 
            LET l_tmp = ''
         END IF 
         LET l_sql = l_sql," WHERE (pia04 = '",g_tlf_1[p_ac].pia04 CLIPPED,"'",l_tmp," )",
                           " ORDER BY pia04"
         LET l_sql1= l_sql1," AND  (pia04 = '",g_tlf_1[p_ac].pia04 CLIPPED,"'",l_tmp," )",
                            " GROUP BY pia04",
                            " ORDER BY pia04"

      WHEN "6"
         IF cl_null(g_tlf_1[p_ac].pia01) THEN 
            LET l_tmp = " OR pia01 IS NULL "
         ELSE 
            LET l_tmp = ''
         END IF 
         LET l_sql = l_sql," WHERE (pia01 = '",g_tlf_1[p_ac].pia01 CLIPPED,"'",l_tmp," )",
                           " ORDER BY pia01"
         LET l_sql1= l_sql1," AND  (pia01 = '",g_tlf_1[p_ac].pia01 CLIPPED,"'",l_tmp," )",
                            " GROUP BY pia01",
                            " ORDER BY pia01"

      WHEN "7"
         IF cl_null(g_tlf_1[p_ac].azp01) THEN 
            LET l_tmp = " OR azp01 IS NULL "
         ELSE 
            LET l_tmp = ''
         END IF 
         LET l_sql = l_sql," WHERE (azp01 = '",g_tlf_1[p_ac].azp01 CLIPPED,"'",l_tmp," )",
                           " ORDER BY azp01"
         LET l_sql1= l_sql1," AND  (azp01 = '",g_tlf_1[p_ac].azp01 CLIPPED,"'",l_tmp," )",
                            " GROUP BY azp01",
                            " ORDER BY azp01"

      WHEN "8"
         IF cl_null(g_tlf_1[p_ac].ccc08) THEN 
            LET l_tmp = " OR ccc08 IS NULL "
         ELSE 
            LET l_tmp = ''
         END IF 
         LET l_sql = l_sql," WHERE (ccc08 = '",g_tlf_1[p_ac].ccc08 CLIPPED,"'",l_tmp," )",
                           " ORDER BY ccc08"
         LET l_sql1= l_sql1," AND  (ccc08 = '",g_tlf_1[p_ac].ccc08 CLIPPED,"'",l_tmp," )",
                            " GROUP BY ccc08",
                            " ORDER BY ccc08"
   END CASE

   PREPARE aimq_pb_detail FROM l_sql
   DECLARE tlf_curs_detail  CURSOR FOR aimq_pb_detail        #CURSOR
   
   PREPARE aimq_pb_det_sr1 FROM l_sql1                                                                                               
   DECLARE aimq_cs_sr1 CURSOR FOR aimq_pb_det_sr1                                                                                      
   OPEN aimq_cs_sr1                                                                                                             
   FETCH aimq_cs_sr1 INTO sr1.pia08_tot,sr1.pia08_c_tot,sr1.pia30_tot,    
                          sr1.pia30_c_tot,sr1.diff_tot,sr1.diff_c_tot

   CALL g_tlf.clear()
   LET g_cnt = 1
   LET g_rec_b = 0
   
   FOREACH tlf_curs_detail INTO g_tlf_excel[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      IF g_cnt < = g_max_rec THEN
         LET g_tlf[g_cnt].* = g_tlf_excel[g_cnt].*
      END IF
      LET g_cnt = g_cnt + 1  
   END FOREACH
   IF g_cnt <= g_max_rec THEN
      CALL g_tlf.deleteElement(g_cnt)
   END IF
   CALL g_tlf_excel.deleteElement(g_cnt)
   LET g_rec_b = g_cnt - 1
   IF g_rec_b > g_max_rec THEN
      CALL cl_err_msg(NULL,"axc-131",g_rec_b||"|"||g_max_rec,10)
      LET g_rec_b  = g_max_rec   #筆數顯示畫面檔的筆數
   END IF
   DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION 

FUNCTION q998_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE ""
    CALL cl_opmsg('q')
    CALL q998_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    MESSAGE "SERCHING!"
    MESSAGE ""
    CALL q998_show()                             
END FUNCTION
