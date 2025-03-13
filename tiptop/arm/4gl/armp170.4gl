# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: armp170.4gl
# Descriptions...: 不良品分析單轉調撥單作業
# Date & Author..: 98/03/26 By Alan
# MODI           : 98/04/20 by plum
# Modify.........: No.MOD-4A0213 04/10/14 By Mandy q_imd 的參數傳的有誤
# Modify.........: No.FUN-550064 05/05/27 By Trisy 單據編號加大 
# Modify.........: NO.MOD-570321 05/08/03 By Yiting 不應 排除 '1' 可用 ,依 per 而言 '1' 會由 PMA 中途倉入回 RMA 倉\
# Modify.........: No.FUN-570149 06/03/13 By yiting 批次背景執行
# Modify.........: No.FUN-660029 06/06/13 By kim GP3.1 增加確認碼欄位與處理
# Modify.........: No.FUN-660111 06/06/12 By pxlpxl substitute cl_err() for cl_err3()
# Modify.........: No.TQC-670008 06/07/05 By kim 將 g_sys 變數改成寫死系統別(要大寫)
# Modify.........: No.FUN-680006 06/08/03 By kim GP3.5 利潤中心
# Modify.........: No.FUN-5A0075 06/08/28 By rainy check 相關倉庫是否存在
# Modify.........: No.FUN-690010 06/09/19 By huchenghao 類型轉換
# Modify.........: No.FUN-6A0085 06/10/25 By douzh l_time轉g_time
# Modify.........: No.TQC-6C0213 06/12/31 By chenl 修正sql語句。
# Modify.........: No.TQC-930045 09/03/05 By chenyu 拋轉到aimt324里面的單子過賬時會當掉，原因就是拋轉過去的時候，儲位，批號沒有給值
# Modify.........: No.FUN-980007 09/08/17 By TSD.zeak GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-930030 09/09/30 By chenmoyan 給QBE條件開窗
# Modify.........: No.FUN-AA0062 10/11/02 By yinhy 倉庫權限使用控管修改
# Modify.........: No.FUN-A60034 11/03/08 By Mandy 因aimt324 新增EasyFlow整合功能影響INSERT INTO imm_file
# Modify.........: No:FUN-A70104 11/03/08 By Mandy [EF簽核] aimt324影響程式簽核欄位default
# Modify.........: No:FUN-B30211 11/03/30 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:MOD-B60208 11/06/23 By zhangll smyapr未賦值
# Modify.........: No.FUN-B70074 11/07/20 By xianghui 添加行業別表的新增於刪除
# Modify.........: No.FUN-CB0087 12/12/21 By qiull 庫存單據理由碼改善
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE 
       g_rmd           RECORD
        rmd33         LIKE rmd_file.rmd33,
        rmd31         LIKE rmd_file.rmd31,
        rmd04         LIKE rmd_file.rmd04,
        rmd05         LIKE rmd_file.rmd05,
        d12qty        LIKE rmd_file.rmd12
             END RECORD,
      g_imm           RECORD LIKE imm_file.*,
      g_imn           RECORD LIKE imn_file.*,
      g_rmd31_t       LIKE rmd_file.rmd31,
      g_wc,g_sql      string,  #No.FUN-580092 HCN
      out3            LIKE rmz_file.rmz01,  #No.FUN-690010 VARCHAR(8),    # RMA 倉庫編號
      in1             LIKE rmz_file.rmz02,  #No.FUN-690010 VARCHAR(8),    # 中途倉庫編號
      out1            LIKE rmz_file.rmz04,  #No.FUN-690010 VARCHAR(8),    # 不良品倉庫編號
      out2            LIKE rmz_file.rmz03,  #No.FUN-690010 VARCHAR(8),    # 報廢品倉庫編號
      bdate           LIKE type_file.dat,   #No.FUN-690010 DATE,       # 不良品分析單開始日期
      edate           LIKE type_file.dat,   #No.FUN-690010 DATE,       # 截止修復日期
      sdate           LIKE type_file.dat,   #No.FUN-690010 DATE,       # 調撥單日期
      a01             LIKE rmz_file.rmz16,  #No.FUN-690010 VARCHAR(5),    #No.FUN-550064 
      b01             LIKE type_file.num5,  #No.FUN-690010 SMALLINT,   # 調撥單單身筆數
      g_count,p_row,p_col         LIKE type_file.num5      #  #No.FUN-690010 SMALLINT
 
DEFINE   g_cnt           LIKE type_file.num10    #No.FUN-690010 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-690010 SMALLINT
DEFINE   g_change_lang   LIKE type_file.chr1     # Prog. Version..: '5.30.06-13.03.12(01)   #No.FUN-570149
DEFINE   ls_date         STRING     #No.FUN-570149
DEFINE   l_flag          LIKE type_file.num5     #No.FUN-690010 SMALLINT   #No.FUN-570149
 
MAIN
#     DEFINE   l_time LIKE type_file.chr8            #No.FUN-6A0085
   OPTIONS
        INPUT NO WRAP
   DEFER INTERRUPT
 
   #No.FUN-570149 --start--
   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_wc     = ARG_VAL(1)
   LET ls_date  = ARG_VAL(2)
   LET bdate    = cl_batch_bg_date_convert(ls_date)
   LET ls_date  = ARG_VAL(3)
   LET edate    = cl_batch_bg_date_convert(ls_date)
   LET in1      = ARG_VAL(4)
   LET out1     = ARG_VAL(5)
   LET out2     = ARG_VAL(6)
   LET out3     = ARG_VAL(7)
   LET a01      = ARG_VAL(8)
   LET ls_date  = ARG_VAL(9)
   LET sdate    = cl_batch_bg_date_convert(ls_date)
   LET b01      = ARG_VAL(10)
   LET g_bgjob  = ARG_VAL(11)
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
 
#NO.FUN-570149 start--
#   OPEN WINDOW p170_w AT p_row,p_col WITH FORM "arm/42f/armp170"
#       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
#    CALL cl_ui_init()
     CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
   WHILE TRUE
      IF g_bgjob = 'N' THEN
         CALL p170()
         IF cl_sure(21,21) THEN
            LET g_success = 'Y'
            BEGIN WORK
            CALL p170_cur()
            CALL p170_ins()
            IF g_success = 'Y' THEN
               COMMIT WORK
               CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
            ELSE
               ROLLBACK WORK
               CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
            END IF
            IF l_flag THEN
               CONTINUE WHILE
            ELSE
               CLOSE WINDOW p170_w
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
       ELSE
         LET g_success = 'Y'
         BEGIN WORK
         CALL p170_cur()
         CALL p170_ins()
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
#   CALL p170()
#   CLOSE WINDOW p170_w
     CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
#   IF INT_FLAG THEN LET INT_FLAG = 0 END IF
#NO.FUN-570149 end---
END MAIN
 
FUNCTION p170()
DEFINE   li_result   LIKE type_file.num5          #No.FUN-550064  #No.FUN-690010 SMALLINT
#  DEFINE l_flag    SMALLINT         #No.FUN-570149
DEFINE   lc_cmd     LIKE type_file.chr1000        #No.FUN-690010 VARCHAR(500)        #No.FUN-570149
DEFINE   l_n        LIKE type_file.num5           #FUN-5A0075  #No.FUN-690010 SMALLINT
#No.FUN-570149 --start--
   OPEN WINDOW p170_w AT p_row,p_col WITH FORM "arm/42f/armp170"
      ATTRIBUTE (STYLE = g_win_style)
 
    CALL cl_ui_init()
#No.FUN-570149 --end---
 
   CLEAR FORM
   WHILE TRUE
      LET g_action_choice = ''
 
      CONSTRUCT BY NAME g_wc ON rmi01 
 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
#No.FUN-930030 --Begin
         ON ACTION controlp
            CASE
               WHEN INFIELD(rmi01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_rmi"
                  LET g_qryparam.state    = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rmi01
                  NEXT FIELD rmi01
            END CASE
#No.FUN-930030 --End
         ON ACTION locale
#            LET g_action_choice='locale'  #NO.FUN-570149 
            LET g_change_lang = TRUE       #NO.FUN-570149
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
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond('rmiuser', 'rmigrup') #FUN-980030
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
         CLOSE WINDOW p170_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
#        RETURN
      END IF
      #No.FUN-570149 ---end---
 
      LET bdate = NULL        # 給予初值
      LET edate = NULL
      LET in1   = g_rmz.rmz02
      LET out1  = g_rmz.rmz04
      LET out2  = g_rmz.rmz03
      LET out3  = g_rmz.rmz01
      LET a01   = g_rmz.rmz16
      LET sdate = g_today
      LET b01   = 20
      LET g_bgjob = 'N'           #No.FUN-570149
 
    # DISPLAY BY NAME bdate,edate,in1,out1,out2,out3,a01,sdate,b01
 
      #INPUT BY NAME bdate,edate,in1,out1,out2,out3,a01,sdate,b01
      INPUT BY NAME bdate,edate,in1,out1,out2,out3,a01,sdate,b01,g_bgjob #NO.FUN-570149
            WITHOUT DEFAULTS 
 
         AFTER FIELD bdate      #不良單分析單日期:起
            IF cl_null(bdate) THEN
               NEXT FIELD bdate
            END IF
 
         AFTER FIELD edate     #不良單分析單日期:止 
            IF cl_null(edate) THEN
               NEXT FIELD edate
            END IF
            IF edate < bdate THEN CALL cl_err('','aap-100',0)
               NEXT FIELD edate
            END IF
 
         AFTER FIELD a01      #調撥單單別
            IF cl_null(a01) THEN
               NEXT FIELD a01
            END IF
        #No.FUN-550064 --start--                                                                                                    
            CALL s_check_no("aim",a01,"","4","","","")                                                                                 
            RETURNING li_result,a01                                                                                                 
            CALL s_get_doc_no(a01) RETURNING a01
            IF (NOT li_result) THEN                  
#           CALL s_mfgslip(a01,'aim',4)  #檢查單別
#           IF NOT cl_null(g_errno) THEN         #抱歉, 有問題
#              CALL cl_err(a01,g_errno,0)
               NEXT FIELD a01
            END IF
        #No.FUN-550064 --end--                                                                                                    
 
         AFTER FIELD sdate    #調撥單日期
            IF cl_null(sdate) THEN
               NEXT FIELD sdate
            END IF
#FUN-5A0075 add--start
         AFTER FIELD in1
           IF NOT cl_null(in1) THEN
             SELECT COUNT(*) INTO l_n  FROM imd_file
              WHERE imd01 = in1
             IF l_n = 0 THEN
                CALL cl_err('','mfg0094',0)
                NEXT FIELD in1
             END IF 
             #No.FUN-AA0062  --Begin
             IF NOT s_chk_ware(in1) THEN
                NEXT FIELD in1
             END IF
             #No.FUN-AA0062  --End             
           END IF
 
         AFTER FIELD out1
           IF NOT cl_null(out1) THEN
             SELECT COUNT(*) INTO l_n  FROM imd_file
              WHERE imd01 = out1
             IF l_n = 0 THEN
                CALL cl_err('','mfg0094',0)
                NEXT FIELD out1
             END IF 
             #No.FUN-AA0062  --Begin
             IF NOT s_chk_ware(out1) THEN
                NEXT FIELD out1
             END IF
             #No.FUN-AA0062  --End  
           END IF
 
         AFTER FIELD out2
           IF NOT cl_null(out2) THEN
              SELECT COUNT(*) INTO l_n  FROM imd_file
               WHERE imd01 = out2
              IF l_n = 0 THEN
                 CALL cl_err('','mfg0094',0)
                 NEXT FIELD out2
              END IF 
             #No.FUN-AA0062  --Begin
             IF NOT s_chk_ware(out2) THEN
                NEXT FIELD out2
             END IF
             #No.FUN-AA0062  --End 
           END IF
 
         AFTER FIELD out3
           IF NOT cl_null(out3) THEN
             SELECT COUNT(*) INTO l_n  FROM imd_file
              WHERE imd01 = out3
             IF l_n = 0 THEN
                CALL cl_err('','mfg0094',0)
                NEXT FIELD out3
             END IF
             #No.FUN-AA0062  --Begin
             IF NOT s_chk_ware(out3) THEN
                NEXT FIELD out3
             END IF
             #No.FUN-AA0062  --End  
           END IF
#FUN-5A0075 add--end
         AFTER FIELD b01      #調撥單單身筆數
            IF cl_null(b01) THEN
               NEXT FIELD b01 
            END IF
 
         ON ACTION CONTROLP
            CASE 
               WHEN INFIELD(a01)     #查詢單据
                  CALL q_smy(FALSE,FALSE,a01,'AIM',4) RETURNING a01 #TQC-670008
#                  CALL FGL_DIALOG_SETBUFFER( a01 )
                  DISPLAY BY NAME a01 
                  NEXT FIELD a01
               WHEN INFIELD(in1)     #查詢倉庫
#                 CALL q_imd(8,10,in1,'A') RETURNING in1
#                 CALL FGL_DIALOG_SETBUFFER( in1 )
#No.FUN-AA0062  --Begin
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.form = "q_imd"
#                  LET g_qryparam.default1 = in1
#                  LET g_qryparam.arg1     = 'SW'        #倉庫類別 #MOD-4A0213
#                  CALL cl_create_qry() RETURNING in1
                   CALL q_imd_1(FALSE,TRUE,in1,"","","","") RETURNING in1
#No.FUN-AA0062  --End
#                  CALL FGL_DIALOG_SETBUFFER( in1 )
                  DISPLAY BY NAME in1 
                  NEXT FIELD in1
               WHEN INFIELD(out1)     #查詢倉庫
#                 CALL q_imd(8,10,out1,'A') RETURNING out1
#                 CALL FGL_DIALOG_SETBUFFER( out1 )
#No.FUN-AA0062  --Begin                  
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.form = "q_imd"
#                  LET g_qryparam.default1 = out1
#                  LET g_qryparam.arg1     = 'SW'        #倉庫類別 #MOD-4A0213
#                  CALL cl_create_qry() RETURNING out1
                   CALL q_imd_1(FALSE,TRUE,out1,"","","","") RETURNING out1
#No.FUN-AA0062  --End
#                  CALL FGL_DIALOG_SETBUFFER( out1 )
                  DISPLAY BY NAME out1 
                  NEXT FIELD out1
               WHEN INFIELD(out2)     #查詢倉庫
#                 CALL q_imd(8,10,out2,'A') RETURNING out2
#                 CALL FGL_DIALOG_SETBUFFER( out2 )
#No.FUN-AA0062  --Begin 
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.form = "q_imd"
#                  LET g_qryparam.default1 = out2
#                  LET g_qryparam.arg1     = 'SW'        #倉庫類別 #MOD-4A0213
#                  CALL cl_create_qry() RETURNING out2
                  CALL q_imd_1(FALSE,TRUE,out2,"","","","") RETURNING out2
#No.FUN-AA0062  --End
#                  CALL FGL_DIALOG_SETBUFFER( out2 )
                  DISPLAY BY NAME out2 
                  NEXT FIELD out2
               WHEN INFIELD(out3)     #查詢倉庫
#                 CALL q_imd(8,10,out3,'A') RETURNING out3
#                 CALL FGL_DIALOG_SETBUFFER( out3 )
#No.FUN-AA0062  --Begin
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.form = "q_imd"
#                  LET g_qryparam.default1 = out3
#                   LET g_qryparam.arg1     = 'SW'        #倉庫類別 #MOD-4A0213
#                  CALL cl_create_qry() RETURNING out3
                   CALL q_imd_1(FALSE,TRUE,out3,"","","","") RETURNING out3
#No.FUN-AA0062  --End
#                  CALL FGL_DIALOG_SETBUFFER( out3 )
                  DISPLAY BY NAME out3 
                  NEXT FIELD out3
            END CASE
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION locale
#FUN-570149--end---
      #  LET g_action_choice='locale'
      #  CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_change_lang = TRUE
         EXIT INPUT
#FUN-570149--end---
 
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT
         ON ACTION CONTROLG CALL cl_cmdask()
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
#FUN-5A0075 add--start
      AFTER INPUT
        IF NOT cl_null(in1) THEN
          SELECT COUNT(*) INTO l_n  FROM imd_file
           WHERE imd01 = in1
          IF l_n = 0 THEN
           CALL cl_err('','mfg0094',0)
           NEXT FIELD in1
          END IF
        END IF
 
        IF NOT cl_null(out1) THEN
          SELECT COUNT(*) INTO l_n  FROM imd_file
           WHERE imd01 = out1
          IF l_n = 0 THEN
           CALL cl_err('','mfg0094',0)
           NEXT FIELD out1
          END IF
        END IF
 
        IF NOT cl_null(out2) THEN
          SELECT COUNT(*) INTO l_n  FROM imd_file
           WHERE imd01 = out2
          IF l_n = 0 THEN
           CALL cl_err('','mfg0094',0)
           NEXT FIELD out2
          END IF
        END IF
 
        IF NOT cl_null(out3) THEN
          SELECT COUNT(*) INTO l_n  FROM imd_file
           WHERE imd01 = out3
          IF l_n = 0 THEN
           CALL cl_err('','mfg0094',0)
           NEXT FIELD out3
          END IF
        END IF
#FUN-5A0075 add--end
 
      END INPUT
#FUN-570149 --start--
#     IF g_action_choice = 'locale' THEN
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   #FUN-550037(smin)
         CONTINUE WHILE
      END IF
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p170_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
#        RETURN
      END IF
 
#NO.FUN-570149 mark--
#      IF cl_sure(0,0) THEN
#         LET g_sql = " SELECT rmd33,rmd31,rmd04,rmd05,sum(rmd12) ",
#                     " FROM rmi_file,rmd_file ",
#                     " WHERE rmi01=rmd31 AND rmiconf='Y' ",
#                     "   AND rmd21 IS NOT NULL ",
#                     "   AND rmd08 = '2' AND (rmd34 IS NULL OR rmd34=' ')",
#                     "   AND rmi02 BETWEEN ","'",bdate,"' AND '",edate,"'",
#                     #980825 modi rmd33 not in '0' -> not in '0','1' 先不含FQC
#                     #  後為良品的,良品以RK單方式來和EI單來沖銷 
#                     #"   AND rmd33 not in ('0','1')  AND ",g_wc CLIPPED,
#                      "   AND rmd33 not in ('0')  AND ",g_wc CLIPPED,  #MOD-570321
#                     " GROUP BY rmd33,rmd31,rmd04,rmd05 ",
#                     " ORDER BY rmd33,rmd31,rmd04,rmd05 "
#      
#         PREPARE p170_prepare FROM g_sql
#         DECLARE p170_cs CURSOR FOR p170_prepare
#         BEGIN WORK
#         LET g_success = 'Y'
#         CALL p170_ins()
#         IF g_count= 0 THEN
#            CALL cl_err('','aap-129',1)     # 無符合條件資料
#            CLOSE p170_cs
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
#      CLOSE p170_cs
#      EXIT WHILE
#   END WHILE
#   CLOSE WINDOW p170_w
#NO.FUN-570149 mark---
 
#NO.FUN-570149 start--
      IF g_bgjob = "Y" THEN
         SELECT zz08 INTO lc_cmd FROM zz_file WHERE zz01 = "armp170"
         IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
            CALL cl_err('armp170','9031',1)
         ELSE
            LET g_wc=cl_replace_str(g_wc, "'", "\"")
            LET lc_cmd = lc_cmd CLIPPED,
                         " '",g_wc CLIPPED,"'",
                         " '",bdate CLIPPED,"'",
                         " '",edate CLIPPED,"'",
                         " '",in1 CLIPPED,"'",
                         " '",out1 CLIPPED,"'",
                         " '",out2 CLIPPED,"'",
                         " '",out3 CLIPPED,"'",
                         " '",a01 CLIPPED,"'",
                         " '",sdate CLIPPED,"'",
                         " '",b01 CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'"
            CALL cl_cmdat('armp170',g_time,lc_cmd CLIPPED)
         END IF
         CLOSE WINDOW p170_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF
      EXIT WHILE
   END WHILE
#NO.FUN-570149 end---------
END FUNCTION
 
#NO.FUN-570149 start--
FUNCTION p170_cur()
    LET g_sql = " SELECT rmd33,rmd31,rmd04,rmd05,sum(rmd12) ",
                " FROM rmi_file,rmd_file ",
                " WHERE rmi01=rmd31 AND rmiconf='Y' ",
                "   AND rmd21 IS NOT NULL ",
                "   AND rmd08 = '2' AND (rmd34 IS NULL OR rmd34=' ')",
                "   AND rmi02 BETWEEN ","'",bdate,"' AND '",edate,"'",
                #980825 modi rmd33 not in '0' -> not in '0','1' 先不含FQC
                #  後為良品的,良品以RK單方式來和EI單來沖銷 
                #"   AND rmd33 not in ('0','1')  AND ",g_wc CLIPPED,
                 "   AND rmd33 not in ('0')  AND ",g_wc CLIPPED,  #MOD-570321
               #" GROUP BY 1,2,3,4 ",              #No.TQC-6C0213 mark  
               #" ORDER BY 1,2,3,4 ",              #No.TQC-6C0213 mark 
                " GROUP BY rmd33,rmd31,rmd04,rmd05 ",              #No.TQC-6C0213 
                " ORDER BY rmd33,rmd31,rmd04,rmd05 "               #No.TQC-6C0213 
 
    PREPARE p170_prepare FROM g_sql
    DECLARE p170_cs CURSOR FOR p170_prepare
END FUNCTION
#NO.FUN-570149 end---
 
FUNCTION p170_ins()
    INITIALIZE g_rmd.*   TO NULL
    LET g_rmd31_t = ' '
    FOREACH p170_cs INTO g_rmd.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('資料被他人鎖住',SQLCA.sqlcode,0)     # 資料被他人LOCK
         LET g_success = 'N'
         EXIT FOREACH
      END IF
      IF g_rmd.rmd31 != g_rmd31_t OR g_cnt=b01 THEN
         INITIALIZE g_imm.* TO NULL
         CALL p170_ins_imm()
         IF g_i THEN   #有問題
            EXIT FOREACH
         END IF
         LET g_cnt=0
      END IF
      IF g_success = 'Y' THEN
         IF g_rmd.d12qty IS NULL THEN LET g_rmd.d12qty=0 END IF
         IF g_rmd.d12qty <0 THEN LET g_rmd.d12qty=g_rmd.d12qty*-1 END IF
         IF g_success = 'Y' THEN
            CALL p170_ins_imn()
            IF g_success = 'N' THEN
               EXIT FOREACH
            END IF
         ELSE
            EXIT FOREACH
         END IF
      ELSE
         EXIT FOREACH
      END IF
      LET g_rmd31_t = g_rmd.rmd31
      LET g_count   = g_count+1
    END FOREACH
   
END FUNCTION
 
FUNCTION p170_ins_imm()  # 單頭 Insert
DEFINE   li_result   LIKE type_file.num5          #No.FUN-550064       #No.FUN-690010 SMALLINT
        #No.FUN-550064 --start--                                                                                                    
            CALL s_auto_assign_no("aim",a01,sdate,"4","","","","","")                                                     
            RETURNING li_result,g_imm.imm01                                                                                         
            IF (NOT li_result) THEN              
               LET g_success = 'N' 
               RETURN 
            END IF
#    CALL s_smyauno(a01,sdate) RETURNING g_i,g_imm.imm01
#    IF g_i THEN 
#       LET g_success = 'N' RETURN END IF
       #No.FUN-550064 ---end---    
    LET g_imm.imm02   = sdate
    LET g_imm.imm03   = 'N'
    LET g_imm.imm04   = 'N'
    LET g_imm.immconf = 'N' #FUN-660029
    LET g_imm.imm10   = '1'
    LET g_imm.immacti = 'Y'
    LET g_imm.immuser = g_user
    LET g_imm.immgrup = g_grup
    LET g_imm.imm14=g_grup #FUN-680006
    LET g_imm.immplant = g_plant #FUN-980007
    LET g_imm.immlegal = g_legal #FUN-980007
    LET g_imm.immoriu = g_user      #No.FUN-980030 10/01/04
    LET g_imm.immorig = g_grup      #No.FUN-980030 10/01/04
    #FUN-A60034--add---str---
    #MOD-B60208 add
    SELECT smyapr INTO g_smy.smyapr FROM smy_file
     WHERE smyslip = a01
    IF cl_null(g_smy.smyapr) THEN LET g_smy.smyapr='N' END IF
    #MOD-B60208 add--end
    #FUN-A70104--mod---str---
    LET g_imm.immmksg = g_smy.smyapr #是否簽核
    LET g_imm.imm15 = '0'            #簽核狀況
    LET g_imm.imm16 = g_user         #申請人
    #FUN-A70104--mod---end---
    #FUN-A60034--add---end---
    INSERT INTO imm_file VALUES(g_imm.*)
    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#       CALL cl_err('p170_ins_imm:',SQLCA.sqlcode,1) #FUN-660111
      CALL cl_err3("ins","imm_file",g_imm.imm01,"",SQLCA.sqlcode,"","p170_ins_imm:",1) # FUN-660111
       LET g_success = 'N'
    END IF
    IF g_bgjob = 'N' THEN           #FUN-570149
        MESSAGE g_imm.imm01 sleep 1
        CALL ui.Interface.refresh()
    END IF
END FUNCTION
 
FUNCTION p170_ins_imn()  # 單身 Insert
    DEFINE l_imni RECORD LIKE imni_file.*      #FUN-B70074
    DEFINE l_store       STRING                #FUN-CB0087
    
    INITIALIZE g_imn.* TO NULL
    LET g_imn.imn01 = g_imm.imm01
    LET g_cnt       = g_cnt+1
    LET g_imn.imn02 = g_cnt            # 項次
    LET g_imn.imn03 = g_rmd.rmd04
    LET g_imn.imn04 = in1
    LET g_imn.imn09 = g_rmd.rmd05
    LET g_imn.imn10 = g_rmd.d12qty
    CASE g_rmd.rmd33
      WHEN '1'  LET g_imn.imn15 = out3    #RMA倉 
               #LET g_imn.imn28='RK04'
      WHEN '2'  LET g_imn.imn15 = out1    #不良倉
               #LET g_imn.imn28='IR02'
      WHEN '3'  LET g_imn.imn15 = out2    #報廢倉
               #LET g_imn.imn28='IR01'
    END CASE
    #No.TQC-930045 add --begin
    LET g_imn.imn05 = ' '
    LET g_imn.imn06 = ' '
    LET g_imn.imn16 = ' '
    LET g_imn.imn17 = ' '
    #No.TQC-930045 add --end
    LET g_imn.imn20 = g_rmd.rmd05
    LET g_imn.imn21 = '1'
    LET g_imn.imn22 = g_rmd.d12qty
    LET g_imn.imn9301=s_costcenter(g_imm.imm14)  #FUN-680006
    LET g_imn.imn9302=g_imn.imn9301  #FUN-680006
    LET g_imn.imnplant = g_plant #FUN-980007
    LET g_imn.imnlegal = g_legal #FUN-980007
    #FUN-CB0087---qiull---add---str---
    IF g_aza.aza115 = 'Y' THEN
       LET l_store = ''
       IF NOT cl_null(g_imn.imn04) THEN
          LET l_store = l_store,g_imn.imn04
       END IF
       IF NOT cl_null(g_imn.imn15) THEN
          IF NOT cl_null(l_store) THEN
             LET l_store = l_store,"','",g_imn.imn15
          ELSE
             LET l_store = l_store,g_imn.imn15
          END IF
       END IF
       CALL s_reason_code(g_imn.imn01,'','',g_imn.imn03,l_store,g_imm.imm16,g_imm.imm14) RETURNING g_imn.imn28
       IF cl_null(g_imn.imn28) THEN
          CALL cl_err('','aim-425',1)
          LET g_success = 'N'
          RETURN 
       END IF
    END IF
    #FUN-CB0087---qiull---add---end---
    INSERT INTO imn_file VALUES(g_imn.*)
    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#       CALL cl_err('p170_ins_imn:',SQLCA.sqlcode,1) # FUN-660111
      CALL cl_err3("ins","imn_file",g_imn.imn01,g_imn.imn02,SQLCA.sqlcode,"","p170_ins_imn",1) # FUN-660111
       LET g_success = 'N'
       RETURN
    #FUN-B70074-add-str--
    ELSE
       IF NOT s_industry('std') THEN 
          INITIALIZE l_imni.* TO NULL
          LET l_imni.imni01 = g_imn.imn01
          LET l_imni.imni02 = g_imn.imn02
          IF NOT s_ins_imni(l_imni.*,g_imn.imnplant) THEN 
             LET g_success = 'N'
             RETURN
          END IF       
       END IF
    #FUN-B70074-add-end-- 
    END IF
    UPDATE rmd_file            # update rmd
           SET rmd34=g_imm.imm01
           WHERE rmd33=g_rmd.rmd33 AND rmd31=g_rmd.rmd31 AND
                 rmd04=g_rmd.rmd04 AND rmd05=g_rmd.rmd05
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#         CALL cl_err('p170_ins_imn: up rmd',SQLCA.sqlcode,1) #FUN-660111
         CALL cl_err3("upd","rmd_file",g_rmd.rmd04,g_rmd.rmd05,SQLCA.sqlcode,"","p170_ins_imn: up rmd",1) # FUN-660111
         LET g_success = 'N'
      END IF
END FUNCTION
