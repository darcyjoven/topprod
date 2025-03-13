# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: armp160.4gl
# Descriptions...: RMA用料轉雜收發單作業
# Date & Author..: 98/03/26 By Alan 98/04/10 modi by plum
# Modify.........: No.MOD-4A0213 04/10/14 By Mandy q_imd 的參數傳的有誤
# Modify.........: No.FUN-550064 05/05/27 By Trisy 單據編號加大
# Modify.........: No.FUN-560014 05/06/08 By yoyo 單據編號修改
# Modify.........; NO.MOD-570404 05/08/01 By Yiting 轉雜收發後,回寫雜收發單號到armt128的雜項領退單號時(rmd21,rmd22),沒判斷該項次是否已有雜項領退
# Modify.........: No.FUN-570149 06/03/13 By yiting 背景作業
# Modify.........: NO.TQC-630139 06/04/03 by Yitng 32區 ds4 領料轉雜項發料料件數量未轉入
# Modify.........: No.TQC-610087 06/04/07 By Claire Review 所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-660111 06/06/12 By pxlpxl substitute cl_err() for cl_err3()
# Modify.........: No.TQC-670008 06/07/05 By kim 將 g_sys 變數改成寫死系統別(要大寫)
# Modify.........: No.FUN-680006 06/08/03 By kim GP3.5 利潤中心
# Modify.........: No.FUN-690010 06/09/05 By huchenghao 類型轉換
# Modify.........: No.FUN-6A0085 06/10/25 By douzh l_time轉g_time
# Modify.........: No.TQC-6C0213 06/12/30 By chenl  對inb06,inb07賦值為' ',以保証資料的正確性。
# Modify.........: No.TQC-760019 07/06/15 By kim 會產生aimt301,aimt302,但是單身檢驗碼為NULL,應default
# Modify.........: No.MOD-7A0185 07/11/15 By claire 無法產生報表 
# Modify.........: No.FUN-870163 08/07/31 By sherry 預設申請數量=原異動數量
# Modify.........: No.TQC-930069 09/04/03 By Sunyanchun 無報表生成
# Modify.........: No.FUN-980007 09/08/17 By TSD.zeak GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-870007 09/08/19 By Zhangyajun ina_file新增字段賦值
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A20044 10/03/20 By  jiachenchao 刪除字段ima26*
# Modify.........: No.FUN-AA0062 10/11/02 By yinhy 倉庫權限使用控管修改
# Modify.........: No:FUN-B30211 11/03/30 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:FUN-B70074 11/07/20 By fengrui 添加行業別表的新增於刪除
# Modify.........: No.FUN-C30085 12/06/29 By lixiang 串CR報表改串GR報表
# Modify.........: No.FUN-CB0087 12/12/20 By xujing 倉庫單據理由碼改善

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE 
       g_rmd           RECORD
        rmd08         LIKE rmd_file.rmd08,
        rmd01         LIKE rmd_file.rmd01,
        rmd04         LIKE rmd_file.rmd04,
        rmd05         LIKE rmd_file.rmd05,
#        d12qty        LIKE ima_file.ima26  #No.FUN-690010 DECIMAL(12,3) #FUN-A20044
        d12qty        LIKE type_file.num15_3  #No.FUN-690010 DECIMAL(12,3) #FUN-A20044
             END RECORD,
      g_ina           RECORD LIKE ina_file.*,
      g_inb           RECORD LIKE inb_file.*,
       g_wc,g_sql      string,  #No.FUN-580092 HCN
      stk1            LIKE rmz_file.rmz01,  #No.FUN-690010 VARCHAR(8),    # RMA 倉庫編號
      dept            LIKE rmz_file.rmz13,  #No.FUN-690010 VARCHAR(6),    # RMA部門編號
      stk2            LIKE rmz_file.rmz02,  #No.FUN-690010 VARCHAR(8),    # 中途倉庫編號
      edate           LIKE rmc_file.rmc08,  #No.FUN-690010 DATE,       # 截止修復日期
      sdate           LIKE type_file.dat,   #No.FUN-690010 DATE,       # 收發單日期
      a01             LIKE rmz_file.rmz08,  #No.FUN-690010 VARCHAR(5),          #No.FUN-550064                                                                                    
      a02             LIKE rmz_file.rmz07,  #No.FUN-690010 VARCHAR(5),          #No.FUN-550064    
      b01             LIKE type_file.num5,   #No.FUN-690010 SMALLINT,   # 收發單單身筆數
      begin_no        LIKE type_file.num5,   #No.FUN-690010 SMALLINT,   # 
      begin_ina01     LIKE type_file.chr1000,#No.FUN-690010 VARCHAR(400), 
      end_ina01       LIKE ina_file.ina01,
      g_count,p_row,p_col LIKE type_file.num5      #   #No.FUN-690010 SMALLINT
 
DEFINE   g_cnt           LIKE type_file.num10      #No.FUN-690010 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-690010 SMALLINT
DEFINE   g_change_lang   LIKE type_file.chr1     # Prog. Version..: '5.30.06-13.03.12(01)        #No.FUN-570149
DEFINE   ls_date         STRING          #No.FUN-570149
DEFINE   l_flag          LIKE type_file.num5     #No.FUN-690010 SMALLINT        #No.FUN-570149
DEFINE   g_msg           LIKE type_file.chr1000  #No.FUN-690010 VARCHAR(600)       #No.FUN-570149
 
MAIN
#     DEFINE   l_time LIKE type_file.chr8            #No.FUN-6A0085
   DEFINE l_wc    LIKE type_file.chr1000       #No.TQC-610087 add  #No.FUN-690010 VARCHAR(600)
   OPTIONS
        INPUT NO WRAP
   DEFER INTERRUPT
 
   #No.FUN-570149 --start--
   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_wc    = ARG_VAL(1)
   LET ls_date = ARG_VAL(2)
   LET edate   = cl_batch_bg_date_convert(ls_date)
   LET stk1    = ARG_VAL(3)
   LET stk2    = ARG_VAL(4)
   LET a01     = ARG_VAL(5)
   LET a02     = ARG_VAL(6)
   LET ls_date = ARG_VAL(7)
   LET sdate   = cl_batch_bg_date_convert(ls_date)
   LET dept    = ARG_VAL(8)
   LET b01     = ARG_VAL(9)
   LET g_bgjob = ARG_VAL(10)
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
   #No.FUN-570149 --end---
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ARM")) THEN
      EXIT PROGRAM
   END IF
 
#NO.FUN-570149 start-
#   LET p_row = 5 LET p_col = 33
#   OPEN WINDOW p160_w AT p_row,p_col WITH FORM "arm/42f/armp160"
#       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
#    CALL cl_ui_init()
     CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
   WHILE TRUE
      IF g_bgjob = 'N' THEN
         CALL cl_opmsg('z')
         CALL p160()
         IF cl_sure(21,21) THEN
            LET g_success = 'Y'
            BEGIN WORK
            CALL p160_cur()
            IF g_success = 'Y' THEN
               COMMIT WORK
               CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
            ELSE
               ROLLBACK WORK
               CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
            END IF
            IF begin_no !=0 THEN
              #-----------No.TQC-610087 modify-----------
               #LET g_msg="armr300 '",begin_ina01 CLIPPED,"'"       
                LET l_wc="ina01 in (",begin_ina01 CLIPPED,")"      
                #LET l_wc=' ina01 = "',begin_ina01,'"' #MOD-7A0185  #TQC-930069--mark---
               #LET g_msg="armr300 '",g_today,"' '",g_user,"' '",g_lang,"' ",  #FUN-C30085 mark
                LET g_msg="armg300 '",g_today,"' '",g_user,"' '",g_lang,"' ",  #FUN-C30085 add
                          " 'Y' ' ' '1'  '",l_wc CLIPPED,"'    "    #MOD-7A0185
                          #" 'Y' ' ' '1' ",'\" ',l_wc CLIPPED,' \" ',"  "  #MOD-7A0185 mark
              #-----------No.TQC-610087 end---------------
               CALL cl_cmdrun(g_msg CLIPPED)
            END IF
            IF l_flag THEN
               CONTINUE WHILE
            ELSE
               CLOSE WINDOW p160_w
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
      ELSE
         LET g_success = 'Y'
         BEGIN WORK
         CALL p160_cur()
         IF g_success = 'Y' THEN
            COMMIT WORK
         ELSE
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE
#    CALL cl_opmsg('z')
#   CALL p160()
#   CLOSE WINDOW p160_w
     CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
#   IF INT_FLAG THEN LET INT_FLAG = 0 END IF
#NO.FUN-570149 end---
END MAIN
 
FUNCTION p160()
   DEFINE   li_result   LIKE type_file.num5          #No.FUN-550064    #No.FUN-690010 SMALLINT
   DEFINE g_msg    LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(600)  
#  DEFINE l_flag    SMALLINT          #No.FUN-570149
   DEFINE lc_cmd   LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(500)          #No.FUN-570149
 
#No.FUN-570149 --start--
   LET p_row = 5 LET p_col = 33
 
   OPEN WINDOW p160_w AT p_row,p_col WITH FORM "arm/42f/armp160"
      ATTRIBUTE (STYLE = g_win_style)
 
    CALL cl_ui_init()
#NO.FUN-570149 END--
 
   CLEAR FORM
   WHILE TRUE
      LET g_action_choice = ''
 
      CONSTRUCT BY NAME g_wc ON rmc01   
 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         ON ACTION locale
#           LET g_action_choice='locale'            #No.FUN-570149
            LET g_change_lang = TRUE                #No.FUN-570149
            EXIT CONSTRUCT
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT CONSTRUCT
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
      END CONSTRUCT
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
      #NO.FUN-570149 start--
#      IF g_action_choice = 'locale' THEN
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   #FUN-550037(smin)
         CONTINUE WHILE
      END IF
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p160_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
#        RETURN
      END IF
      #No.FUN-570149 ---end---
 
      LET edate = NULL
      LET stk1  = g_rmz.rmz01
      LET stk2  = g_rmz.rmz02
      LET a01   = g_rmz.rmz08
      LET a02   = g_rmz.rmz07
      LET sdate = g_today
      LET dept  = g_rmz.rmz13
      LET b01   = 20
      LET g_bgjob = 'N'               #No.FUN-570149
 
      #INPUT BY NAME edate,stk1,stk2,a01,a02,sdate,dept,b01 WITHOUT DEFAULTS 
      INPUT BY NAME edate,stk1,stk2,a01,a02,sdate,dept,b01,g_bgjob WITHOUT DEFAULTS  #NO.FUN-570149
 
         AFTER FIELD edate   #截止修復日期
            IF cl_null(edate) THEN
               NEXT FIELD edate
            END IF
        
         AFTER FIELD dept    #部門編號
            IF cl_null(dept) THEN 
               NEXT FIELD dept 
            END IF
        
         AFTER FIELD a01     #收料單別
            IF cl_null(a01) THEN 
               NEXT FIELD a01 
            END IF
        #No.FUN-550064 --start-- 
            CALL s_check_no("aim",a01,"","2","","","")  
            RETURNING li_result,a01                                                   
            CALL s_get_doc_no(a01) RETURNING a01
            IF (NOT li_result) THEN                  
               NEXT FIELD a01 
            END IF
#            CALL s_mfgslip(a01,'aim',2)  #檢查單別
#            IF NOT cl_null(g_errno) THEN           #抱歉, 有問題
#               CALL cl_err(a01,g_errno,0)
#              NEXT FIELD a01 
#           END IF
         #No.FUN-550064 ---end---  
 
         AFTER FIELD a02    #發料單單別
            IF cl_null(a02) THEN
               NEXT FIELD a02
            END IF
        #No.FUN-550064 --start--                                                                                                    
            CALL s_check_no("aim",a02,"","1","","","")                                                                                 
            RETURNING li_result,a02                                                                                                 
            CALL s_get_doc_no(a02) RETURNING a02
            IF (NOT li_result) THEN                     
               NEXT FIELD a02
            END IF
#            CALL s_mfgslip(a02,'aim',1)     #檢查單別
#            IF NOT cl_null(g_errno) THEN         #抱歉, 有問題
#               CALL cl_err(a02,g_errno,0)
#              NEXT FIELD a02
#           END IF
         #No.FUN-550064 ---end---    
 
         AFTER FIELD sdate  #收發單日期
            IF cl_null(sdate) THEN
               NEXT FIELD sdate 
            END IF
           
         AFTER FIELD b01    #收發單單身筆數
            IF cl_null(b01) THEN
               NEXT FIELD b01
            END IF
         #No.FUN-AA0062  --Begin
         AFTER FIELD stk1
            IF NOT s_chk_ware(stk1) THEN
              NEXT FIELD stk1
            END IF
         AFTER FIELD stk2
            IF NOT s_chk_ware(stk2) THEN
              NEXT FIELD stk2
            END IF   
         #No.FUN-AA0062  --End   
         ON ACTION CONTROLP
            CASE 
               WHEN INFIELD(a01)     #查詢單据
                  CALL q_smy(FALSE,FALSE,a01,'AIM',2) RETURNING a01 #TQC-670008
#                  CALL FGL_DIALOG_SETBUFFER( a01 )
                  DISPLAY BY NAME a01 
                  NEXT FIELD a01
               WHEN INFIELD(a02)     #查詢單据
                  CALL q_smy(FALSE,FALSE,a02,'AIM',1) RETURNING a02 #TQC-670008
#                  CALL FGL_DIALOG_SETBUFFER( a02 )
                  DISPLAY BY NAME a02 
                  NEXT FIELD a02
               WHEN INFIELD(stk1)     #查詢倉庫
#                 CALL q_imd(8,10,stk1,'A') RETURNING stk1
#No.FUN-AA0062  --Begin
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.form = "q_imd"
#                  LET g_qryparam.default1 = stk1
#                   LET g_qryparam.arg1     = 'SW'        #倉庫類別 #MOD-4A0213
#                  CALL cl_create_qry() RETURNING stk1
#                  CALL FGL_DIALOG_SETBUFFER( stk1 )
                  CALL q_imd_1(FALSE,TRUE,stk1,"","","","") RETURNING stk1
#No.FUN-AA0062  --End
                  DISPLAY BY NAME stk1 
                  NEXT FIELD stk1
               WHEN INFIELD(stk2)     #查詢倉庫
#                 CALL q_imd(8,10,stk2,'A') RETURNING stk2
#No.FUN-AA0062  --Begin
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.form = "q_imd"
#                  LET g_qryparam.default1 = stk2
#                  LET g_qryparam.arg1     = 'SW'        #倉庫類別 #MOD-4A0213
#                  CALL cl_create_qry() RETURNING stk2
#                  CALL FGL_DIALOG_SETBUFFER( stk2 )
                  CALL q_imd_1(FALSE,TRUE,stk2,"","","","") RETURNING stk2
#No.FUN-AA0062  --End                  
                  DISPLAY BY NAME stk2 
                  NEXT FIELD stk2
               WHEN INFIELD(dept)    # 查詢檢驗部門代號及名稱
#                 CALL q_gem(10,22,dept) RETURNING dept
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gem"
                  LET g_qryparam.default1 = dept
                  CALL cl_create_qry() RETURNING dept
#                  CALL FGL_DIALOG_SETBUFFER( dept )
                  DISPLAY BY NAME dept
                  NEXT FIELD dept
            END CASE
         ON ACTION CONTROLR CALL cl_show_req_fields()
         ON ACTION CONTROLG CALL cl_cmdask()
 
         ON ACTION locale
          #->No.FUN-570149--end---
       #  LET g_action_choice='locale'
       #  CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
          LET g_change_lang = TRUE
          #->No.FUN-570149--end---
          EXIT INPUT
 
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
      END INPUT
      #No.FUN-570149 --start--
#     IF g_action_choice = 'locale' THEN
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   #FUN-550037(smin)
         CONTINUE WHILE
      END IF
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p160_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
#        RETURN
      END IF
      #No.FUN-570149 ---end---
 
      LET begin_no=0
      LET g_count=0
      LET g_sql = "SELECT COUNT(*) ",
                  "  FROM rmc_file,rmd_file,rma_file ",
                  "WHERE rmd01=rmc01 and rmd03=rmc02 ",
                  "  AND rmc08 <= '",edate,"'",  
                  "  AND rmc14 !='0' AND rma01=rmc01 ",
                  "  AND rma09 !='6' AND rmavoid='Y' ",
                  "  AND rmaconf='Y' AND rmd08 IS NOT NULL ",
                  "  AND (rmd21 IS NULL OR rmd21=' ')",
                  "  AND rmd12 <>0 ",
                  "  AND rmd04 != 'MISC' AND ",g_wc CLIPPED 
      PREPARE p160_precount FROM g_sql
      DECLARE p160_count CURSOR FOR p160_precount
      OPEN p160_count 
      FETCH p160_count INTO g_count 
      IF g_count= 0 THEN
         CALL cl_err('','aap-129',1)     # 無符合條件資料
         CLOSE p160_precount
         CONTINUE  WHILE
      END IF
 
#NO.FUN-570149 mark--
#      IF cl_sure(20,20) THEN
#         LET g_sql = "SELECT rmd08,rmd01,rmd04,rmd05,sum(rmd12) ",
#                     " FROM rmc_file,rmd_file,rma_file ",
#                     "WHERE rmd01=rmc01 and rmd03=rmc02 ",
#                    "  AND rmc08 <= '",edate,"'",  
#                     "  AND rmc14 <> '0' AND rma01=rmc01 ",
#                     "  AND rma09 !='6' AND rmavoid='Y' ",
#                     "  AND rmaconf='Y' AND rmd08 IS NOT NULL ",
#                     "  AND (rmd21 IS NULL OR rmd21=' ')",
#                     "  AND rmd12 <> 0 ",
#                     "  AND rmd04 != 'MISC' AND ",g_wc CLIPPED,
#                     " GROUP BY rmd08,rmd01,rmd04,rmd05  ORDER BY rmd08,rmd01,rmd04,rmd05 "
#         PREPARE p160_prepare FROM g_sql
#         DECLARE p160_cs CURSOR FOR p160_prepare
#         BEGIN WORK
#         LET g_success = 'Y'
#         CALL p160_ins()
#         IF g_count= 0 and g_success='Y' THEN
#            CALL cl_err('','aap-129',1)     # 無符合條件資料
#            CLOSE p160_cs
#            ROLLBACK WORK
#            CONTINUE WHILE
#         END IF
#         IF g_success = 'Y' THEN
#            COMMIT WORK
#            CALL cl_end2(1) RETURNING l_flag
#         ELSE
#            ROLLBACK WORK
#            CALL cl_end2(2) RETURNING l_flag
#         END IF
#         IF l_flag THEN CONTINUE WHILE ELSE EXIT WHILE END IF
#      END IF
#      CLOSE p160_cs
#      IF begin_no !=0 THEN 
#         LET g_msg="armr300 '",begin_ina01 CLIPPED,"'"
#         CALL cl_cmdrun(g_msg CLIPPED)
#      END IF
#      EXIT WHILE 
#   END WHILE
#   CLOSE WINDOW p160_w
#NO.FUN-570149 mark--
 
#NO.FUN-570149 start--
      IF g_bgjob = "Y" THEN
         SELECT zz08 INTO lc_cmd FROM zz_file
          WHERE zz01 = "armp160"
         IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
            CALL cl_err('armp160','9031',1) 
         ELSE
            LET g_wc=cl_replace_str(g_wc, "'", "\"")
            LET lc_cmd = lc_cmd CLIPPED,
                         " '",g_wc,"'",
                         " '",edate CLIPPED,"'",
                         " '",stk1 CLIPPED,"'",
                         " '",stk2 CLIPPED,"'",
                         " '",a01 CLIPPED,"'",
                         " '",a02 CLIPPED,"'",
                         " '",sdate CLIPPED,"'",
                         " '",dept CLIPPED,"'",
                         " '",b01 CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'"
 
            CALL cl_cmdat('armp160',g_time,lc_cmd CLIPPED)
         END IF
         CLOSE WINDOW p160_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF
      EXIT WHILE
   END WHILE
#NO.FUN-570149 end--
END FUNCTION
 
#No.FUN-570149 --start--
FUNCTION p160_cur()
         LET g_sql = "SELECT rmd08,rmd01,rmd04,rmd05,sum(rmd12) ",
                     " FROM rmc_file,rmd_file,rma_file ",
                     "WHERE rmd01=rmc01 and rmd03=rmc02 ",
                    "  AND rmc08 <= '",edate,"'",  
                     "  AND rmc14 <> '0' AND rma01=rmc01 ",
                     "  AND rma09 !='6' AND rmavoid='Y' ",
                     "  AND rmaconf='Y' AND rmd08 IS NOT NULL ",
                     "  AND (rmd21 IS NULL OR rmd21=' ')",
                     "  AND rmd12 <> 0 ",
                     "  AND rmd04 != 'MISC' AND ",g_wc CLIPPED,
                     " GROUP BY rmd08,rmd01,rmd04,rmd05  ORDER BY rmd08,rmd01,rmd04,rmd05 "
         PREPARE p160_prepare FROM g_sql
         DECLARE p160_cs CURSOR FOR p160_prepare
         BEGIN WORK
         LET g_success = 'Y'
         CALL p160_ins()
         IF g_count= 0 and g_success='Y' THEN
            CALL cl_err('','aap-129',1)     # 無符合條件資料
            CLOSE p160_cs
            LET g_success = 'N' 
         END IF
END FUNCTION
#NO.FUN-570149 end--
 
FUNCTION p160_ins()
DEFINE l_rmd08 LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1),  #用退料別
       l_rmd01 LIKE rmd_file.rmd01,    #No.FUN-690010 VARCHAR(16), #No.FUN-560014
       l_more  LIKE type_file.chr1     #No.FUN-690010 VARCHAR(1)   #N:end of cursor Y:more data
 
    INITIALIZE g_rmd.*   TO NULL
    LET l_more = 'Y'
    LET g_count = 0
    OPEN p160_cs
    FETCH p160_cs INTO g_rmd.*
    IF SQLCA.SQLCODE THEN
       LET l_more = 'N'
    END IF
    LET begin_no=0
    WHILE l_more = 'Y'
       INITIALIZE g_ina.* TO NULL
       CASE
       WHEN g_rmd.rmd08 = '1'       #表用料: rmd12 <0
          LET g_ina.ina00 = '1'
#         LET g_ina.ina01[1,3]=a02
          LET g_ina.ina01[1,g_doc_len]=a02  #No.FUN-560014
       WHEN g_rmd.rmd08 = '2'       #表退料: rmd12 >0
          LET g_ina.ina00 = '3'
#         LET g_ina.ina01[1,3]=a01
          LET g_ina.ina01[1,g_doc_len]=a01  #No.FUN-560014
       END CASE
 
#      IF cl_null(g_ina.ina01[1,3]) THEN 
       IF cl_null(g_ina.ina01[1,g_doc_len]) THEN  #No.FUN-550064  
          CALL cl_err('slip is null','aar-001',1)
          LET g_success='N'
          EXIT WHILE
       END IF
       CALL p160_ins_ina()
       IF g_success = 'N' THEN   #有問題
          EXIT WHILE
       END IF
       LET g_cnt=0
      #LET l_rmd01 = g_rmd.rmd01  980730 mark 
       LET l_rmd08 = g_rmd.rmd08
      #WHILE l_more = 'Y' AND l_rmd08 = g_rmd.rmd08 AND l_rmd01 = g_rmd.rmd01
       WHILE l_more = 'Y' AND l_rmd08 = g_rmd.rmd08 
          AND g_cnt < b01
          IF g_rmd.d12qty IS NULL THEN LET g_rmd.d12qty=0 END IF
          IF g_rmd.d12qty < 0 THEN LET g_rmd.d12qty=g_rmd.d12qty*-1 END IF
          CALL p160_ins_inb()
         #LET g_cnt = g_cnt + 1
          IF g_success = 'N' THEN
             EXIT WHILE
          END IF
          LET g_count   = g_count+1
          FETCH NEXT p160_cs INTO g_rmd.*
          IF SQLCA.SQLCODE THEN
             LET l_more = 'N'   #no more data
          END IF
       END WHILE
    END WHILE
   #LET end_ina01=g_ina.ina01
    CLOSE p160_cs
END FUNCTION
 
FUNCTION p160_ins_ina()  # add 收發單單頭
DEFINE   li_result   LIKE type_file.num5          #No.FUN-550064   #No.FUN-690010 SMALLINT
 
        #No.FUN-550064 --start-- 
            CALL s_auto_assign_no("aim",g_ina.ina01,g_today,"2","ina_file","ina01","","","")  
            RETURNING li_result,g_ina.ina01                                                   
            IF g_bgjob = 'N' THEN           #FUN-570149
                DISPLAY BY NAME g_ina.ina01                                                                                             
            END IF
            IF (NOT li_result) THEN                                                                                                 
               LET g_success = 'N'
               RETURN
            END IF
#    CALL s_smyauno(g_ina.ina01,g_today) RETURNING g_i,g_ina.ina01
#    IF g_i THEN   #有問題
#       CALL cl_err(g_ina.ina01,g_errno,0)
#      LET g_success = 'N'
#      RETURN
#   END IF
       #No.FUN-550064 ---end---  
    IF begin_no=0 THEN LET begin_ina01='"',g_ina.ina01,'"' ELSE  
       LET begin_ina01=begin_ina01 CLIPPED,', "',g_ina.ina01,'"' END IF
    LET g_ina.ina02   = sdate
    LET g_ina.ina03   = g_today
    LET g_ina.ina04   = dept
    CALL cl_getmsg('arm-120',g_lang) RETURNING g_ina.ina07 
    LET g_ina.inapost = 'N'
    LET g_ina.inaconf = 'N'   #MOD-7A0185
    LET g_ina.ina11   = g_user #MOD-7A0185
    LET g_ina.inauser = g_user
    LET g_ina.inagrup = g_grup
    LET g_ina.inaplant = g_plant #FUN-980007
    LET g_ina.inalegal = g_legal #FUN-980007
    LET g_ina.ina12 = 'N' #No.FUN-870007
    LET g_ina.inapos='N'  #No.FUN-870007
 
    LET g_ina.inaoriu = g_user      #No.FUN-980030 10/01/04
    LET g_ina.inaorig = g_grup      #No.FUN-980030 10/01/04
    INSERT INTO ina_file VALUES(g_ina.*)
    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#       CALL cl_err('p160_ins_ina:',SQLCA.sqlcode,1) # FUN-660111
      CALL cl_err3("ins","ina_file",g_ina.ina01,"",SQLCA.sqlcode,"","p160_ins_ina:",1) # FUN-660111
       LET g_success = 'N'
    ELSE
       IF g_bgjob = 'N' THEN           #FUN-570149
           MESSAGE g_ina.ina01 SLEEP 1
           CALL ui.Interface.refresh()
       END IF
    END IF
    LET begin_no=begin_no+1
    
END FUNCTION
 
FUNCTION p160_ins_inb()  # add 收發單單身
    DEFINE l_inbi    RECORD LIKE inbi_file.*  #FUN-B70074 add
    DEFINE l_ina04   LIKE ina_file.ina04          #FUN-CB0087 xj
    DEFINE l_ina10   LIKE ina_file.ina10          #FUN-CB0087 xj
    DEFINE l_ina11   LIKE ina_file.ina11          #FUN-CB0087 xj


    INITIALIZE g_inb.* TO NULL
    LET g_inb.inb01     = g_ina.ina01      #收發單單號
    LET g_cnt           = g_cnt+1
    LET g_inb.inb03     = g_cnt            # 項次
    LET g_inb.inb04     = g_rmd.rmd04      # 產品編號
    LET g_inb.inb06     = " "              # 儲位        #No.TQC-6C0213
    LET g_inb.inb07     = " "              # 批號        #No.TQC-6C0213
    LET g_inb.inb08     = g_rmd.rmd05      # 單位
    LET g_inb.inb08_fac = 1                # 異動/庫存單位的換算率
    IF  g_rmd.rmd08 = '1' THEN             # 用料
        LET g_inb.inb05 = stk1
    ELSE                                   # 退料
        LET g_inb.inb05 = stk2
    END IF
    LET g_inb.inb10 = 'N' #TQC-760019      #檢驗否
    LET g_inb.inb15     = g_rmz.rmz14
#NO.TQC-630139 START--
    IF g_sma.sma115 = 'Y' THEN
        LET g_inb.inb902    = g_rmd.rmd05
        LET g_inb.inb904    = g_rmd.d12qty
        LET g_inb.inb09     = g_rmd.d12qty
    ELSE
        LET g_inb.inb09     = g_rmd.d12qty
    END IF
#NO.TQC-630139 END--
    LET g_inb.inb09     = g_rmd.d12qty
    LET g_inb.inb12     = g_rmd.rmd01
    LET g_inb.inb930    = s_costcenter(g_ina.ina04) #FUN-680006
    LET g_inb.inb16     = g_rmd.d12qty  #No.FUN-870163
    LET g_inb.inbplant = g_plant #FUN-980007
    LET g_inb.inblegal = g_legal #FUN-980007
   #FUN-CB0087-xj---add---str
    IF g_aza.aza115 = 'Y' THEN
       SELECT ina04,ina10,ina11 INTO l_ina04,l_ina10,l_ina11 FROM ina_file WHERE ina01 = g_inb.inb01
       CALL s_reason_code(g_inb.inb01,l_ina10,'',g_inb.inb04,g_inb.inb05,l_ina04,l_ina11) RETURNING g_inb.inb15
       IF cl_null(g_inb.inb15) THEN
          CALL cl_err('','aim-425',1)
          LET g_success = 'N'
          RETURN
       END IF
    END IF
  #FUN-CB0087-xj---add---end
    INSERT INTO inb_file VALUES(g_inb.*)
    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
 #      CALL cl_err('p160_ins_inb:',SQLCA.sqlcode,1) # FUN-660111
      CALL cl_err3("ins","inb_file",g_inb.inb01,g_inb.inb03,SQLCA.sqlcode,"","p160_ins_inb:",1) # FUN-660111
       LET g_success = 'N'
       RETURN
#FUN-B70074--add--insert--
    ELSE
       IF NOT s_industry('std') THEN
          INITIALIZE l_inbi.* TO NULL
          LET l_inbi.inbi01 = g_inb.inb01
          LET l_inbi.inbi03 = g_inb.inb03
          IF NOT s_ins_inbi(l_inbi.*,g_inb.inbplant ) THEN
             LET g_success = 'N'
             RETURN
          END IF
       END IF 
#FUN-B70074--add--insert--
    END IF
    UPDATE rmd_file            # update rmd
       SET rmd21=g_ina.ina01,rmd22=g_inb.inb03
     WHERE rmd01=g_rmd.rmd01 AND rmd04=g_rmd.rmd04
       AND rmd08=g_rmd.rmd08
        AND (rmd21 IS NULL or rmd21 = ' ' )  #NO.MOD-570404     己有單號者不更改
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
 #        CALL cl_err('p160_ins_ina:',SQLCA.sqlcode,1)#FUN-660111
         CALL cl_err3("upd","rmd_file",g_rmd.rmd01,"",SQLCA.sqlcode,"","p160_ins_ina:",1) # FUN-660111
         LET g_success = 'N'
      END IF
END FUNCTION
 
