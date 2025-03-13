# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: arms010.4gl
# Descriptions...: RMA銷退貨作業系統參數
# Date & Author..: 92/05/11 BY MAY 
# Modify.........: No.MOD-470041 04/07/22 By Nicola 修改INSERT INTO 語法
# Modify.........: No.MOD-4A0213 04/10/14 By Mandy q_imd 的參數傳的有誤
# Modify.........: No.MOD-4B0169 04/11/22 By Mandy check imd_file 的程式段...應加上 imdacti 的判斷
# Modify.........: No.MOD-530110 05/03/25 By Mandy RMA倉盤點資料轉入發料單理由碼開窗時無法帶入資料
# Modify.........: No.FUN-550064 05/05/28 By Trisy 單據編號加大
# Modify.........: NO.FUN-560014 05/06/08 By jackie 單據編號修改
# Modify.........: No.MOD-490064 05/09/16 By Nicola 新增rmz00為KEY值
# Modify.........: No.FUN-660111 06/06/12 By pxlpxl substitute cl_err() for cl_err3()
# Modify.........: No.TQC-670008 06/07/05 By rainy 權限修正
# Modify.........: No.FUN-690010 06/09/05 By huchenghao 類型轉換
# Modify.........: No.FUN-930104 09/03/23 By dxfwo   理由碼的分類改善
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-A10008 10/01/06 By lilingyu "覆出工作天數 RMA應收利潤率"未控管負數
# Modify.........: No.FUN-A70130 10/08/11 By huangtao 修改s_check_no`的參數
# Modify.........: No:FUN-B30211 11/03/30 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No.FUN-B50039 11/07/08 By fengrui 增加自定義欄位
 
DATABASE ds
 
GLOBALS "../../config/top.global"
    DEFINE
        g_rmz_t         RECORD LIKE rmz_file.*,  # 預留RMA系統參數檔
        g_rmz_o         RECORD LIKE rmz_file.*   # 預留RMA系統參數檔
    DEFINE  p_row,p_col LIKE type_file.num5    #No.FUN-690010 SMALLINT
    DEFINE  g_t1        LIKE oay_file.oayslip   #No.FUN-550064      #No.FUN-690010 VARCHAR(05)
    DEFINE  g_forupd_sql          STRING
 
 
MAIN
    OPTIONS 
          INPUT NO WRAP
    DEFER INTERRUPT 
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
   
    WHENEVER ERROR CALL cl_err_msg_log
   
    SELECT * FROM rmz_file 
    IF STATUS or SQLCA.sqlcode=100  THEN
        INSERT INTO rmz_file (rmz00,rmz01,rmz02,rmz03,rmz04,rmz05,rmz06,rmz07,  #No.MOD-470041  #No.MOD-490064
                             rmz08,rmz09,rmz10,rmz11,rmz12,rmz13,rmz14,
                             rmz15,rmz16,rmz17,rmz18,rmz19,rmz20,rmz21)
            VALUES("0","1","1","1","1","RM1","1","1","1","1","1","1",1,"1",   #No.MOD-490064
                   "1","S","1","1","1","",0,0)
    END IF
 
    IF (NOT cl_setup("ARM")) THEN
       EXIT PROGRAM
    END IF
    CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-B30211
 
    OPEN WINDOW s010_w AT p_row,p_col
        WITH FORM "arm/42f/arms010"    
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
 
 
    CALL s010_show()
 
    #WHILE TRUE      ####040512
      LET g_action_choice=""
    CALL s010_menu()
      #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
    #END WHILE    ####040512
 
    CLOSE WINDOW s010_w
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
END MAIN
 
FUNCTION s010_show()
    LET g_rmz_t.* = g_rmz.*
    LET g_rmz_o.* = g_rmz.*
    SELECT * INTO g_rmz.* FROM rmz_file
    DISPLAY BY NAME g_rmz.rmz01,g_rmz.rmz02,g_rmz.rmz03,g_rmz.rmz04,
                    g_rmz.rmz05,g_rmz.rmz06,g_rmz.rmz07,g_rmz.rmz08,
                    g_rmz.rmz16,g_rmz.rmz11,
                    g_rmz.rmz12,g_rmz.rmz13,g_rmz.rmz14,g_rmz.rmz15,
                    g_rmz.rmz17,g_rmz.rmz18,g_rmz.rmz19,g_rmz.rmz20,
                    g_rmz.rmz21,
                    #FUN-B50039-add-str--
                    g_rmz.rmzud01,g_rmz.rmzud02,g_rmz.rmzud03,
                    g_rmz.rmzud04,g_rmz.rmzud05,g_rmz.rmzud06,
                    g_rmz.rmzud07,g_rmz.rmzud08,g_rmz.rmzud09,
                    g_rmz.rmzud10,g_rmz.rmzud11,g_rmz.rmzud12,
                    g_rmz.rmzud13,g_rmz.rmzud14,g_rmz.rmzud15
                    #FUN-B50039-add-end--
                    
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION s010_menu()
    MENU ""
    ON ACTION modify 
       LET g_action_choice = "modify"
       IF cl_chk_act_auth() THEN 
          CALL s010_u()
       END IF 
    ON ACTION help 
       CALL cl_show_help()

    ON ACTION locale
       CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf

    ON ACTION exit
       LET g_action_choice = "exit"
    EXIT MENU

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
    END MENU
END FUNCTION
 
 
FUNCTION s010_u()
 
    IF s_shut(0) THEN CALL cl_err('',9037,0) RETURN END IF
    CALL cl_opmsg('u')
    MESSAGE ""
    LET g_forupd_sql = "SELECT * FROM rmz_file FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE rmz_curl CURSOR FROM g_forupd_sql
 
    LET g_success = 'Y'
    BEGIN WORK
    OPEN rmz_curl 
    IF SQLCA.sqlcode  THEN
       CALL cl_err('',SQLCA.sqlcode,0)
       RETURN
    END IF
    FETCH rmz_curl INTO g_rmz.*
    IF SQLCA.sqlcode  THEN
       CALL cl_err('',SQLCA.sqlcode,0)
       RETURN
    END IF
    LET g_rmz_t.* = g_rmz.*
    LET g_rmz_o.* = g_rmz.*
    DISPLAY BY NAME g_rmz.rmz01,g_rmz.rmz02,g_rmz.rmz03,g_rmz.rmz04,
                    g_rmz.rmz05,g_rmz.rmz06,g_rmz.rmz07,g_rmz.rmz08,
                    g_rmz.rmz16,g_rmz.rmz11,
                    g_rmz.rmz12,g_rmz.rmz13,g_rmz.rmz14,g_rmz.rmz15,
                    g_rmz.rmz17,g_rmz.rmz18,
                    #FUN-B50039-add-str--
                    g_rmz.rmzud01,g_rmz.rmzud02,g_rmz.rmzud03,
                    g_rmz.rmzud04,g_rmz.rmzud05,g_rmz.rmzud06,
                    g_rmz.rmzud07,g_rmz.rmzud08,g_rmz.rmzud09,
                    g_rmz.rmzud10,g_rmz.rmzud11,g_rmz.rmzud12,
                    g_rmz.rmzud13,g_rmz.rmzud14,g_rmz.rmzud15
                    #FUN-B50039-add-end--
                    
    WHILE TRUE
        CALL s010_show()
        CALL s010_i()
        IF INT_FLAG THEN
           LET INT_FLAG = 0
           CALL cl_err('',9001,0)
           ROLLBACK WORK
           LET g_rmz.* = g_rmz_t.*
           CALL s010_show()
           EXIT WHILE
        END IF
        UPDATE rmz_file SET
                rmz01=g_rmz.rmz01,
                rmz02=g_rmz.rmz02,
                rmz03=g_rmz.rmz03,
                rmz04=g_rmz.rmz04,
                rmz05=g_rmz.rmz05,
                rmz06=g_rmz.rmz06,
                rmz07=g_rmz.rmz07,
                rmz08=g_rmz.rmz08,
#               rmz09=g_rmz.rmz09,
#               rmz10=g_rmz.rmz10,
                rmz11=g_rmz.rmz11,
                rmz12=g_rmz.rmz12,
                rmz13=g_rmz.rmz13,
                rmz14=g_rmz.rmz14,
                rmz15=g_rmz.rmz15,
                rmz16=g_rmz.rmz16,
                rmz17=g_rmz.rmz17,
                rmz18=g_rmz.rmz18, 
                rmz19=g_rmz.rmz19, 
                rmz20=g_rmz.rmz20, 
                rmz21=g_rmz.rmz21,
                #FUN-B50039-add-str--
                rmzud01=g_rmz.rmzud01,
                rmzud02=g_rmz.rmzud02,
                rmzud03=g_rmz.rmzud03,
                rmzud04=g_rmz.rmzud04,
                rmzud05=g_rmz.rmzud05,
                rmzud06=g_rmz.rmzud06,
                rmzud07=g_rmz.rmzud07,
                rmzud08=g_rmz.rmzud08,
                rmzud09=g_rmz.rmzud09,
                rmzud10=g_rmz.rmzud10,
                rmzud11=g_rmz.rmzud11,
                rmzud12=g_rmz.rmzud12,
                rmzud13=g_rmz.rmzud13,
                rmzud14=g_rmz.rmzud14,
                rmzud15=g_rmz.rmzud15
                #FUN-B50039-add-end--
           WHERE rmz00='0'     #No.MOD-490064
        IF SQLCA.sqlcode THEN
   #        CALL cl_err('',SQLCA.sqlcode,0) # FUN-660111
         CALL cl_err3("upd","rmz_file","","",SQLCA.sqlcode,"","",0) # FUN-660111
           CONTINUE WHILE
        END IF
        CLOSE rmz_curl
           IF g_success = 'Y'
              THEN COMMIT WORK
              ELSE ROLLBACK WORK
           END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION s010_i()
   DEFINE   li_result   LIKE type_file.num5          #No.FUN-550064   #No.FUN-690010 SMALLINT
   DEFINE   l_msg   LIKE type_file.chr1000, #No.FUN-690010 VARCHAR(80),
            l_cnt   LIKE type_file.num5,    #No.FUN-690010 SMALLINT
            l_ans   LIKE type_file.chr1     #No.FUN-690010 VARCHAR(1)     #判斷BEFORE FIELD rmz32 時的走向
   DEFINE l_azf09       LIKE azf_file.azf09          #No.FUN-930104
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   INPUT BY NAME g_rmz.rmz01,g_rmz.rmz02,g_rmz.rmz03,g_rmz.rmz04,
                 g_rmz.rmz19,g_rmz.rmz15,g_rmz.rmz20,g_rmz.rmz21,
                 g_rmz.rmz05,g_rmz.rmz06,g_rmz.rmz17,g_rmz.rmz18,
                 g_rmz.rmz08,g_rmz.rmz07,g_rmz.rmz16,
                 g_rmz.rmz11,g_rmz.rmz12,g_rmz.rmz13,
                 g_rmz.rmz14,
                 #FUN-B50039-add-str--
                 g_rmz.rmzud01,g_rmz.rmzud02,g_rmz.rmzud03,
                 g_rmz.rmzud04,g_rmz.rmzud05,g_rmz.rmzud06,
                 g_rmz.rmzud07,g_rmz.rmzud08,g_rmz.rmzud09,
                 g_rmz.rmzud10,g_rmz.rmzud11,g_rmz.rmzud12,
                 g_rmz.rmzud13,g_rmz.rmzud14,g_rmz.rmzud15
                 #FUN-B50039-add-end--
                 WITHOUT DEFAULTS  
 
      AFTER FIELD rmz01
         IF NOT cl_null(g_rmz.rmz01) THEN
            CALL s010_imd(g_rmz.rmz01) 
            IF NOT cl_null(g_errno) THEN 
               LET g_rmz.rmz01=g_rmz_o.rmz01
               DISPLAY BY NAME g_rmz.rmz01
               NEXT FIELD rmz01
            END IF 
         END IF 
         LET g_rmz_o.rmz01=g_rmz.rmz01
 
      AFTER FIELD rmz02
         IF NOT cl_null(g_rmz.rmz02) THEN
            CALL s010_imd(g_rmz.rmz02)
            IF NOT cl_null(g_errno) THEN 
               LET g_rmz.rmz02=g_rmz_o.rmz02
               DISPLAY BY NAME g_rmz.rmz02
               NEXT FIELD rmz02
            END IF 
         END IF
         LET g_rmz_o.rmz02=g_rmz.rmz02
 
      AFTER FIELD rmz03
         IF NOT cl_null(g_rmz.rmz02) THEN
            CALL s010_imd(g_rmz.rmz03)
            IF NOT cl_null(g_errno) THEN 
               LET g_rmz.rmz03=g_rmz_o.rmz03
               DISPLAY BY NAME g_rmz.rmz03
               NEXT FIELD rmz03
            END IF 
         END IF
         LET g_rmz_o.rmz03=g_rmz.rmz03
 
      AFTER FIELD rmz04
         IF NOT cl_null(g_rmz.rmz04) THEN
            CALL s010_imd(g_rmz.rmz04)
            IF NOT cl_null(g_errno) THEN 
               LET g_rmz.rmz04=g_rmz_o.rmz04
               DISPLAY BY NAME g_rmz.rmz04
               NEXT FIELD rmz04
            END IF 
         END IF
         LET g_rmz_o.rmz04=g_rmz.rmz04
 
      AFTER FIELD rmz05
         #--NO:6842
         IF NOT cl_null(g_rmz.rmz05) THEN
      #No.FUN-550064 --start--   
#           LET g_t1 = g_rmz.rmz05[1,3]
#           CALL s_axmslip(g_t1,'70',g_sys)  # 單別,單據性質(user權限)
#           IF NOT cl_null(g_errno) THEN
#              CALL cl_err(g_t1,g_errno,0)
            LET g_t1 = g_rmz.rmz05[1,g_doc_len]
          #  CALL s_check_no("aXm",g_t1,"","70","","","")  #No.FUN-560014
            CALL s_check_no("arm",g_t1,"","70","","","")  #No.FUN-A70130
            RETURNING li_result,g_rmz.rmz05 
            LET g_rmz.rmz05 = s_get_doc_no(g_rmz.rmz05) 
            DISPLAY BY NAME g_rmz.rmz05                                                                                             
            IF (NOT li_result) THEN                                                                                                 
               NEXT FIELD rmz05
            END IF
         #--NO:6842
           CALL s010_oay(g_rmz.rmz05,'70') 
           IF NOT cl_null(g_errno) THEN 
              LET g_rmz.rmz05=g_rmz_o.rmz05
              DISPLAY BY NAME g_rmz.rmz05
              NEXT FIELD rmz05
           END IF 
        END IF
        LET g_rmz_o.rmz05=g_rmz.rmz05
    #No.FUN-550064 ---end---  
 
      AFTER FIELD rmz06
         #--NO:6842
      #No.FUN-550064 --start--  
         IF NOT cl_null(g_rmz.rmz06) THEN
#           LET g_t1 = g_rmz.rmz06[1,3]
#           CALL s_axmslip(g_t1,'71',g_sys)  # 單別,單據性質(user權限)
#           IF NOT cl_null(g_errno) THEN
#              CALL cl_err(g_t1,g_errno,0)
            LET g_t1 = g_rmz.rmz06[1,g_doc_len]                                                                                     
          #  CALL s_check_no("axm",g_t1,"","71","","","")       #No.FUN-560014 
            CALL s_check_no("arm",g_t1,"","71","","","")        #No.FUN-A70130                                
            RETURNING li_result,g_rmz.rmz06                                                                                         
            LET g_rmz.rmz06 = s_get_doc_no(g_rmz.rmz06) 
            DISPLAY BY NAME g_rmz.rmz06                                                                                             
            IF (NOT li_result) THEN                                                                                                 
               NEXT FIELD rmz06
            END IF
         #--NO:6842
            CALL s010_oay(g_rmz.rmz06,'71') 
            IF NOT cl_null(g_errno) THEN 
               LET g_rmz.rmz06=g_rmz_o.rmz06
               DISPLAY BY NAME g_rmz.rmz06
               NEXT FIELD rmz06
            END IF 
         END IF
        LET g_rmz_o.rmz06=g_rmz.rmz06
      #No.FUN-550064 ---end---   
 
      AFTER FIELD rmz17
         IF NOT cl_null(g_rmz.rmz17) THEN
            #--NO:6842
      #No.FUN-550064 --start--  
#           LET g_t1 = g_rmz.rmz17[1,3]
#           CALL s_axmslip(g_t1,'75',g_sys)  # 單別,單據性質(user權限)
#           IF NOT cl_null(g_errno) THEN
#              CALL cl_err(g_t1,g_errno,0)
            LET g_t1 = g_rmz.rmz17[1,g_doc_len]                                                                                     
          #  CALL s_check_no("axm",g_t1,"","75","","","")              #No.FUN-560014     
             CALL s_check_no("arm",g_t1,"","75","","","")              #No.FUN-A70130                                     
            RETURNING li_result,g_rmz.rmz17                                                                                         
            LET g_rmz.rmz17 = s_get_doc_no(g_rmz.rmz17) 
            DISPLAY BY NAME g_rmz.rmz17                                                                                             
            IF (NOT li_result) THEN                                                                                                 
               NEXT FIELD rmz17
            END IF
            #--NO:6842
            CALL s010_oay(g_rmz.rmz17,'75') 
            IF NOT cl_null(g_errno) THEN 
               LET g_rmz.rmz17=g_rmz_o.rmz17
               DISPLAY BY NAME g_rmz.rmz17
               NEXT FIELD rmz17
            END IF 
         END IF 
         LET g_rmz_o.rmz17=g_rmz.rmz17
      #No.FUN-550064 ---end---   
 
      AFTER FIELD rmz18
         IF NOT cl_null(g_rmz.rmz18) THEN
            #--NO:6842
      #No.FUN-550064 --start--  
#           LET g_t1 = g_rmz.rmz18[1,3]
#           CALL s_axmslip(g_t1,'73',g_sys)  # 單別,單據性質(user權限)
#           IF NOT cl_null(g_errno) THEN
#              CALL cl_err(g_t1,g_errno,0)
            LET g_t1 = g_rmz.rmz18[1,g_doc_len]                                                                                     
         #   CALL s_check_no("arm",g_t1,"","73","","","")      #No.FUN-560014  
            CALL s_check_no("arm",g_t1,"","73","","","")     #No.FUN-A70130                                                         
            RETURNING li_result,g_rmz.rmz18                                                                                         
            LET g_rmz.rmz18 = s_get_doc_no(g_rmz.rmz18) 
            DISPLAY BY NAME g_rmz.rmz18                                                                                             
            IF (NOT li_result) THEN                                                                                                 
               LET g_rmz.rmz18=g_rmz_o.rmz18                    
               NEXT FIELD rmz18
            END IF
            #--NO:6842
            CALL s010_oay(g_rmz.rmz18,'73') 
            IF NOT cl_null(g_errno) THEN 
               LET g_rmz.rmz18=g_rmz_o.rmz18
               DISPLAY BY NAME g_rmz.rmz18
               NEXT FIELD rmz18
            END IF 
         END IF
         LET g_rmz_o.rmz18=g_rmz.rmz18
      #No.FUN-550064 ---end---   
 
      AFTER FIELD rmz07
         IF NOT cl_null(g_rmz.rmz07) THEN
           CALL s010_smy(g_rmz.rmz07,'1') 
           IF NOT cl_null(g_errno) THEN 
              LET g_rmz.rmz07=g_rmz_o.rmz07
              DISPLAY BY NAME g_rmz.rmz07
           END IF 
         END IF
         LET g_rmz_o.rmz07=g_rmz.rmz07
 
      AFTER FIELD rmz08
         IF NOT cl_null(g_rmz.rmz08) THEN
           CALL s010_smy(g_rmz.rmz08,'2') 
           IF NOT cl_null(g_errno) THEN 
              LET g_rmz.rmz08=g_rmz_o.rmz08
              DISPLAY BY NAME g_rmz.rmz08
            END IF 
         END IF 
         LET g_rmz_o.rmz08=g_rmz.rmz08
 
      AFTER FIELD rmz16
         IF NOT cl_null(g_rmz.rmz16) THEN
           CALL s010_smy(g_rmz.rmz16,'4') 
           IF NOT cl_null(g_errno) THEN 
              LET g_rmz.rmz16=g_rmz_o.rmz16
              DISPLAY BY NAME g_rmz.rmz16
            END IF 
         END IF 
         LET g_rmz_o.rmz16=g_rmz.rmz16
 
      AFTER FIELD rmz11
         IF NOT cl_null(g_rmz.rmz11) THEN
      #No.FUN-550064 --start--  
           CALL s010_ooy() 
           IF NOT cl_null(g_errno) THEN 
              LET g_rmz.rmz11=g_rmz_o.rmz11
              DISPLAY BY NAME g_rmz.rmz11
              NEXT FIELD rmz11
           END IF
            CALL s_check_no("axr",g_rmz.rmz11,"","14","","","")               #No.FUN-560014                                                       
            RETURNING li_result,g_rmz.rmz11                                                                                         
            LET g_rmz.rmz11 = s_get_doc_no(g_rmz.rmz11) 
            DISPLAY BY NAME g_rmz.rmz11                                                                                             
            IF (NOT li_result) THEN                                                                                                 
               NEXT FIELD rmz11
            END IF 
#           CALL s_axrslip(g_rmz.rmz11,'14','AXR')        #檢查單別NO:6842
#           IF NOT cl_null(g_errno) THEN                  #抱歉, 有問題
#              CALL cl_err(g_rmz.rmz11[1,3],g_errno,0) 
#              NEXT FIELD rmz11
#           END IF
         END IF
         LET g_rmz_o.rmz11=g_rmz.rmz11
      #No.FUN-550064 ---end---   
 
      AFTER FIELD rmz12
         IF NOT cl_null(g_rmz.rmz12) THEN
            IF g_rmz.rmz12 < 0 THEN
               LET g_rmz.rmz12 = g_rmz_o.rmz12
               DISPLAY BY NAME g_rmz.rmz12
               MESSAGE "不可小於零!"
               NEXT FIELD rmz12
            END IF
         END IF
         LET g_rmz_o.rmz12=g_rmz.rmz12
 
      AFTER FIELD rmz13
         IF NOT cl_null(g_rmz.rmz13) THEN
            SELECT * FROM gem_file WHERE gem01=g_rmz.rmz13
               AND gemacti='Y'   #NO:6950
            IF SQLCA.sqlcode =100 THEN 
  #             CALL cl_err('','aap-039',0) # FUN-660111
            CALL cl_err3("sel","gem_file",g_rmz.rmz13,"","aap-039","","",0) # FUN-660111
               LET g_rmz.rmz13=g_rmz_o.rmz13
               DISPLAY BY NAME g_rmz.rmz13
               NEXT FIELD rmz13
            END IF 
         END IF 
         LET g_rmz_o.rmz13=g_rmz.rmz13
 
      AFTER FIELD rmz14
         IF NOT cl_null(g_rmz.rmz14) THEN
            SELECT * FROM azf_file WHERE azf02 = '2' AND azf01=g_rmz.rmz14 AND azfacti ='Y'
            IF SQLCA.sqlcode =100 THEN  
      #         CALL cl_err('','mfg3088',0) # FUN-660111
              CALL cl_err3("sel","azf_file","",g_rmz.rmz14,"mfg3088","","",0) # FUN-660111
               LET g_rmz.rmz14=g_rmz_o.rmz14
               DISPLAY BY NAME g_rmz.rmz14
               NEXT FIELD rmz14
            END IF 
 
#No.FUN-930104 --begin--            
            SELECT azf09 INTO l_azf09 FROM azf_file
             WHERE azf02 = '2' AND azf01=g_rmz.rmz14 AND azfacti ='Y'
              IF l_azf09 != '4' THEN 
               CALL cl_err('','aoo-403',1)
                NEXT FIELD rmz14
              END IF
#No.FUN-930104 --end--          
         END IF 
         LET g_rmz_o.rmz14=g_rmz.rmz14
 
      AFTER FIELD rmz15
         LET g_rmz_o.rmz15=g_rmz.rmz15
 
#TQC-A10008 --begin--
      AFTER FIELD rmz20
         IF NOT cl_null(g_rmz.rmz20) THEN
              IF g_rmz.rmz20 < 0 THEN
                 CALL cl_err('','aec-020',0)
                 NEXT FIELD CURRENT
              END IF 
         END IF 

      AFTER FIELD rmz21
         IF NOT cl_null(g_rmz.rmz21) THEN
              IF g_rmz.rmz21 < 0 THEN
                 CALL cl_err('','aec-020',0)
                 NEXT FIELD CURRENT
              END IF
         END IF

#TQC-A10008 --end--

      AFTER FIELD rmz19
         IF NOT cl_null(g_rmz.rmz19) THEN
            IF g_rmz.rmz19 NOT MATCHES '[YN]' THEN
               LET g_rmz.rmz19=g_rmz_o.rmz19
               DISPLAY BY NAME g_rmz.rmz19
               NEXT FIELD rmz19
            END IF
         END IF
         LET g_rmz_o.rmz19=g_rmz.rmz19

      #FUN-B50039-add-str--
      AFTER FIELD rmzud01
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD rmzud02
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD rmzud03
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD rmzud04
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD rmzud05
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD rmzud06
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD rmzud07
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD rmzud08
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD rmzud09
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD rmzud10
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD rmzud11
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD rmzud12
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD rmzud13
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD rmzud14
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD rmzud15
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      #FUN-B50039-add-end--
      
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(rmz01)     #RMA倉庫編號
               CALL cl_init_qry_var()
               LET g_qryparam.form ='q_imd' 
               LET g_qryparam.default1 =g_rmz.rmz01 
                LET g_qryparam.arg1     = 'SW'        #倉庫類別 #MOD-4A0213
               CALL cl_create_qry() RETURNING g_rmz.rmz01
#               CALL FGL_DIALOG_SETBUFFER( g_rmz.rmz01 )
               DISPLAY BY NAME g_rmz.rmz01 
               NEXT FIELD rmz01
            WHEN INFIELD(rmz02)     #RMA中途倉編號
               CALL cl_init_qry_var()
               LET g_qryparam.form ='q_imd' 
               LET g_qryparam.default1 =g_rmz.rmz02 
                LET g_qryparam.arg1     = 'SW'        #倉庫類別 #MOD-4A0213
               CALL cl_create_qry() RETURNING g_rmz.rmz02
#               CALL FGL_DIALOG_SETBUFFER( g_rmz.rmz02 )
               DISPLAY BY NAME g_rmz.rmz02 
               NEXT FIELD rmz02
            WHEN INFIELD(rmz03)     #RMA報廢倉編號
               CALL cl_init_qry_var()
               LET g_qryparam.form ='q_imd' 
               LET g_qryparam.default1 =g_rmz.rmz03 
                LET g_qryparam.arg1     = 'SW'        #倉庫類別 #MOD-4A0213
               CALL cl_create_qry() RETURNING g_rmz.rmz03
#               CALL FGL_DIALOG_SETBUFFER( g_rmz.rmz03 )
               DISPLAY BY NAME g_rmz.rmz03 
               NEXT FIELD rmz03
            WHEN INFIELD(rmz04)     #RMA不良品倉編號
               CALL cl_init_qry_var()
               LET g_qryparam.form ='q_imd' 
               LET g_qryparam.default1 =g_rmz.rmz04 
                LET g_qryparam.arg1     = 'SW'        #倉庫類別 #MOD-4A0213
               CALL cl_create_qry() RETURNING g_rmz.rmz04
#               CALL FGL_DIALOG_SETBUFFER( g_rmz.rmz04 )
               DISPLAY BY NAME g_rmz.rmz04 
               NEXT FIELD rmz04
            WHEN INFIELD(rmz05)     #RMA單別
               #CALL q_oay(FALSE,FALSE,g_rmz.rmz05,'70','axm') #TQC-670008
               CALL q_oay(FALSE,FALSE,g_rmz.rmz05,'70','arm')  #TQC-670008 
                    RETURNING g_rmz.rmz05
#               CALL FGL_DIALOG_SETBUFFER(g_rmz.rmz05)
               DISPLAY BY NAME g_rmz.rmz05 
               NEXT FIELD rmz05
            WHEN INFIELD(rmz06)     #RMA覆出單單別
               #CALL q_oay(FALSE,FALSE,g_rmz.rmz06,'71','axm') #TQC-670008
               CALL q_oay(FALSE,FALSE,g_rmz.rmz06,'71','arm')  #TQC-670008 
                    RETURNING g_rmz.rmz06
#               CALL FGL_DIALOG_SETBUFFER(g_rmz.rmz06)
               DISPLAY BY NAME g_rmz.rmz06 
               NEXT FIELD rmz06
            WHEN INFIELD(rmz17)     #RMA客退單單別
               #CALL q_oay(FALSE,FALSE,g_rmz.rmz17,'75','axm')  #TQC-670008
               CALL q_oay(FALSE,FALSE,g_rmz.rmz17,'75','arm')  #TQC-670008 
                    RETURNING g_rmz.rmz17
#               CALL FGL_DIALOG_SETBUFFER(g_rmz.rmz17)
               DISPLAY BY NAME g_rmz.rmz17 
               NEXT FIELD rmz17
            WHEN INFIELD(rmz18)     #RMA報廢單單別
               #CALL q_oay(FALSE,FALSE,g_rmz.rmz18,'73','axm') #TQC-670008
               CALL q_oay(FALSE,FALSE,g_rmz.rmz18,'73','arm')  #TQC-670008 
                    RETURNING g_rmz.rmz18
#               CALL FGL_DIALOG_SETBUFFER(g_rmz.rmz18)
               DISPLAY BY NAME g_rmz.rmz18 
               NEXT FIELD rmz18
            WHEN INFIELD(rmz07)     #RMA發料單單別
               #CALL q_smy(FALSE,FALSE,g_rmz.rmz07,'aim','1')  #TQC-670008
               CALL q_smy(FALSE,FALSE,g_rmz.rmz07,'AIM','1')   #TQC-670008
                          RETURNING g_rmz.rmz07
#               CALL FGL_DIALOG_SETBUFFER(g_rmz.rmz07)
               DISPLAY BY NAME g_rmz.rmz07 
               NEXT FIELD rmz07
            WHEN INFIELD(rmz08)     #RMA收料單單別
               #CALL q_smy(FALSE,FALSE,g_rmz.rmz08,'aim','2')  #TQC-670008
               CALL q_smy(FALSE,FALSE,g_rmz.rmz08,'AIM','2')   #TQC-670008 
                          RETURNING g_rmz.rmz08
#               CALL FGL_DIALOG_SETBUFFER(g_rmz.rmz08)
               DISPLAY BY NAME g_rmz.rmz08 
               NEXT FIELD rmz08
            WHEN INFIELD(rmz16)     #RMA調撥單單別
               #CALL q_smy(FALSE,FALSE,g_rmz.rmz16,'aim','4') #TQC-670008
               CALL q_smy(FALSE,FALSE,g_rmz.rmz16,'AIM','4')  #TQC-670008 
                          RETURNING g_rmz.rmz16
#               CALL FGL_DIALOG_SETBUFFER(g_rmz.rmz16)
               DISPLAY BY NAME g_rmz.rmz16 
               NEXT FIELD rmz16
            WHEN INFIELD(rmz11)    #RMA應收帳款立帳單單別
               #CALL q_ooy(FALSE,FALSE, g_t1,'14','axr')  #TQC-670008
               CALL q_ooy(FALSE,FALSE, g_t1,'14','AXR')   #TQC-670008 
                          RETURNING g_rmz.rmz11
#               CALL FGL_DIALOG_SETBUFFER(g_rmz.rmz11)
               DISPLAY BY NAME g_rmz.rmz11 
               NEXT FIELD rmz11
            WHEN INFIELD(rmz13)   #部門     
               CALL cl_init_qry_var()
               LET g_qryparam.form ='q_gem' 
               LET g_qryparam.default1 =g_rmz.rmz13 
               CALL cl_create_qry() RETURNING g_rmz.rmz13
#               CALL FGL_DIALOG_SETBUFFER( g_rmz.rmz13 )
               DISPLAY BY NAME g_rmz.rmz13 
               NEXT FIELD rmz13
            WHEN INFIELD(rmz14)   #理由碼
               CALL cl_init_qry_var()
#               LET g_qryparam.form ='q_azf' 
               LET g_qryparam.form ='q_azf01a'          #No.FUN-930104
               LET g_qryparam.default1 =g_rmz.rmz14 
#                LET g_qryparam.arg1 = "2" #MOD-530110
               LET g_qryparam.arg1 = "4"                #No.FUN-930104
               CALL cl_create_qry() RETURNING g_rmz.rmz14
#               CALL FGL_DIALOG_SETBUFFER( g_rmz.rmz14 )
               DISPLAY BY NAME g_rmz.rmz14 
               NEXT FIELD rmz14   
            OTHERWISE
               EXIT CASE
         END CASE
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG
         CALL cl_cmdask()
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
   
   END INPUT
END FUNCTION
 
FUNCTION s010_imd(p_imd01)
   DEFINE p_imd01 LIKE imd_file.imd01
   
   LET g_errno=' '
   SELECT imd01,imd10 FROM imd_file WHERE imd01=p_imd01
                                       AND imdacti = 'Y' #MOD-4B0169
   IF SQLCA.sqlcode=100 THEN 
 #     CALL cl_err('','mfg0094',0) # FUN-660111
            CALL cl_err3("sel","imd_file",p_imd01,"","mfg0094","","",0) # FUN-660111
      LET g_errno = 'err'
   END IF
END FUNCTION
 
FUNCTION s010_ooy()
 
   LET g_errno=' '
   SELECT ooytype FROM ooy_file WHERE ooyslip=g_rmz.rmz11 AND ooytype='14' 
   IF SQLCA.sqlcode=100 THEN 
 #     CALL cl_err('','aap-010',0) #FUN-660111
       CALL cl_err3("sel","ooy_file",g_rmz.rmz11,"","aap-010","","",0) # FUN-660111
      LET g_errno = 'err'
   END IF
END FUNCTION
 
FUNCTION s010_oay(p_slip,p_kind)
   DEFINE p_slip LIKE oay_file.oayslip,
          p_kind LIKE oay_file.oaytype
 
   LET g_errno=' '
   SELECT oaytype FROM oay_file WHERE oayslip=p_slip AND oaytype=p_kind 
   IF SQLCA.sqlcode=100 THEN 
#      CALL cl_err('','aap-010',0) #FUN-660111
       CALL cl_err3("sel","oay_file",p_slip,"","aap-010","","",0) # FUN-660111
      LET g_errno = 'err'
   END IF
END FUNCTION
 
FUNCTION s010_smy(p_slip,p_kind)
   DEFINE p_slip LIKE oay_file.oayslip,
          p_kind LIKE oay_file.oaytype
 
   LET g_errno=' '
   SELECT smyslip FROM smy_file WHERE smyslip=p_slip AND smykind=p_kind 
                                AND  smysys = 'aim'
   IF SQLCA.sqlcode=100 THEN 
 #     CALL cl_err('','aap-010',0)
     CALL cl_err3("sel","smy_file",p_slip,"","aap-010","","",0) # FUN-660111
      LET g_errno = 'err'
   END IF
END FUNCTION
