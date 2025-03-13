# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: armp120.4gl
# Descriptions...: RMA轉銷退單作業
# Date & Author..: 98/03/30 By plum
# Modify.........: No.FUN-550064 05/05/27 By Trisy 單據編號加大
# Modify.........: NO.FUN-560014 05/06/08 By jackie 單據編號修改
# Modify.........: NO.FUN-570149 06/03/13 By yiting 背景作業
# Modify.........: No.FUN-660111 06/06/12 By pxlpxl substitute cl_err() for cl_err3()
# Modify.........: No.TQC-670008 06/07/05 By rainy 權限修正
# Modify.........: No.FUN-680006 06/08/02 By kim GP3.5 利潤中心
# Modify.........: No.FUN-690010 06/09/05 By huchenghao 類型轉換
# Modify.........: No.FUN-6A0085 06/10/25 By douzh l_time轉g_time
# Modify.........: No.FUN-870007 09/08/13 By Zhangyajun 流通零售功能修改
# Modify.........: No.FUN-980007 09/08/17 By TSD.zeak GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A70130 10/08/11 By huangtao 修改q_oay*()的參數
# Modify.........: No.FUN-AB0061 10/11/16 By chenying 銷退單加基礎單價字段ohb37
# Modify.........: No.FUN-AB0096 10/11/25 By vealxu 因新增ogb50的not null欄位,所導致其他作業無法insert into資料的問題修正
# Modify.........: No.FUN-AC0055 10/12/21 By suncx 取消預設ohb71值，新增oha55欄位預設值
# Modify.........: No:FUN-B30211 11/03/30 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:FUN-B70074 11/07/20 By fengrui 添加行業別表的新增於刪除
# Modify.........: No.FUN-BB0085 11/12/20 By xianghui 增加數量欄位小數取位
# Modify.........: No.FUN-CB0087 12/12/20 By qiull 庫存單據理由碼改善

 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE 
       g_rm            RECORD
        rma01         LIKE rma_file.rma01,
        rmc04         LIKE rmc_file.rmc04,
        rmb12_t       LIKE rmb_file.rmb12,
        rmb13         LIKE rmb_file.rmb13
             END RECORD,
      g_rmac          RECORD
        rma03         LIKE rma_file.rma03,
        rma04         LIKE rma_file.rma04,
        rma08         LIKE rma_file.rma08,
        rma13         LIKE rma_file.rma13,
        rma14         LIKE rma_file.rma14,
        rma15         LIKE rma_file.rma15,
        rma16         LIKE rma_file.rma16,
        rma17         LIKE rma_file.rma17,
        rma18         LIKE rma_file.rma18,
        rmc05         LIKE rmc_file.rmc05,
        rmc06         LIKE rmc_file.rmc06
             END RECORD,
      g_rmj           RECORD LIKE rmj_file.*,
      g_oha           RECORD LIKE oha_file.*,
      g_ohb           RECORD LIKE ohb_file.*,
      g_rma01_t       LIKE rma_file.rma01,
      g_rmc04_t       LIKE rmc_file.rmc04,
       g_wc,g_sql      string,  #No.FUN-580092 HCN
      bdate           LIKE type_file.dat,     #No.FUN-690010 DATE,       # 銷退日期
      cdate           LIKE type_file.dat,     #No.FUN-690010 DATE,       # 結案日期
#No.FUN-560014 --start-
      ano             LIKE oea_file.oea01,    #No.FUN-690010 VARCHAR(16),   # 銷退單單號
      g_startno       LIKE oea_file.oea01,    #No.FUN-690010 VARCHAR(16),   #
      g_lastno        LIKE oea_file.oea01,    #No.FUN-690010 VARCHAR(16),   #
#No.FUN-560014 ---end--
      g_t,g_t1        LIKE oay_file.oayslip,    # 銷退單單別No.FUN-550064   #No.FUN-690010 VARCHAR(5)
      g_count         LIKE type_file.num5,    #No.FUN-690010 SMALLINT,   # 符合條件的筆數
      g_check         LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1),    # 指定銷退單單號的check
      p_row,p_col     LIKE type_file.num5,    #No.FUN-690010 SMALLINT
#No.FUN-570149 --start--
      g_change_lang   LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(01),
      l_flag          LIKE type_file.chr3,    #No.FUN-690010 VARCHAR(3),
      ls_date         STRING
#No.FUN-570149 --end---
 
DEFINE   g_cnt           LIKE type_file.num10      #No.FUN-690010 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-690010 SMALLINT
MAIN
#     DEFINE   l_time LIKE type_file.chr8            #No.FUN-6A0085
   OPTIONS
        INPUT NO WRAP
   DEFER INTERRUPT
 
#FUN-570149 --start--
   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_wc        = ARG_VAL(1)
   LET ano         = ARG_VAL(2)
   LET ls_date     = ARG_VAL(3)
   LET bdate       = cl_batch_bg_date_convert(ls_date)
   LET ls_date     = ARG_VAL(4)
   LET cdate       = cl_batch_bg_date_convert(ls_date)
   LET g_bgjob     = ARG_VAL(5)
 
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = 'N'
   END IF
#FUN-570149 ---end---
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ARM")) THEN
      EXIT PROGRAM
   END IF
 
#NO.FUN-570149 start--
#   LET p_row = 10 LET p_col = 10
#   OPEN WINDOW p120_w AT p_row,p_col WITH FORM "arm/42f/armp120"
#       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
#    CALL cl_ui_init()
     CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
#   CALL cl_opmsg('z')
#   LET g_rma01_t = g_rmz.rmz05           #
   WHILE TRUE
      IF g_bgjob = "N" THEN
         CALL p120()
         IF cl_sure(21,21) THEN
            LET g_success = 'Y'
            CALL cl_wait()
            BEGIN WORK
            CALL p120_cur()
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
               CLOSE WINDOW p120_w
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
         CLOSE WINDOW p120_w
      ELSE
         LET g_success = 'Y'
         BEGIN WORK
         CALL p120_cur()
         IF g_success = 'Y' THEN
            COMMIT WORK
         ELSE
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE
#   CALL p120()
#   CLOSE WINDOW p120_w
     CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
#   IF INT_FLAG THEN LET INT_FLAG = 0 END IF
#NO.FUN0-570149 end--
END MAIN
 
FUNCTION p120()
   DEFINE   li_result   LIKE type_file.num5          #No.FUN-550064    #No.FUN-690010 SMALLINT
   DEFINE   l_code      LIKE type_file.chr3      #No.FUN-690010 VARCHAR(3)  
 #  DEFINE   l_flag   VARCHAR(3)            #No.FUN-570149
   DEFINE   lc_cmd     LIKE type_file.chr1000  #No.FUN-690010 VARCHAR(500)          #No.FUN-570149
 
   #No.FUN-570149 --start--
   LET p_row = 10 LET p_col = 10
   OPEN WINDOW p120_w AT p_row,p_col WITH FORM "arm/42f/armp120"
      ATTRIBUTE (STYLE = g_win_style)
 
   CALL cl_ui_init()
   #No.FUN-570149 --end---
 
   CLEAR FORM
 
   WHILE TRUE
      LET g_action_choice = ''
      LET g_check="N"
      LET g_rma01_t = g_rmz.rmz05           #NO.FUN-570149
 
      CONSTRUCT BY NAME g_wc ON rma01,rma07,rma03
 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         ON ACTION locale
#NO.FUN-570149 mark
#            LET g_action_choice='locale'
#            EXIT CONSTRUCT
#NO.FUN-570149 mark
            LET g_change_lang = TRUE               #No.FUN-570149
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
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond('rmauser', 'rmagrup') #FUN-980030
      IF g_change_lang THEN                    #No.FUN-570149
#     IF g_action_choice = 'locale' THEN       #No.FUN-570149
         LET g_change_lang = FALSE             #No.FUN-570149
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   #FUN-550037(smin)
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0                #No.FUN-570149
         CLOSE WINDOW p120_w             #No.FUN-570149
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM                    #No.FUN-570149
#        EXIT WHILE                      #No.FUN-570149
      END IF
 
      LET bdate = g_today
      LET cdate = g_today
 
      DISPLAY BY NAME ano,bdate,cdate
 
      #INPUT BY NAME ano,bdate,cdate WITHOUT DEFAULTS 
      INPUT BY NAME ano,bdate,cdate,g_bgjob WITHOUT DEFAULTS   #NO.FUN-570149
          
         AFTER FIELD ano
  
            IF cl_null(ano) THEN 
               NEXT FIELD ano 
            END IF
      #No.FUN-550064 --start--       
            IF NOT cl_null(ano[1,g_doc_len])  THEN    # AND cl_null(ano[5,10]) THEN
                LET l_code = '60' 
            CALL s_check_no("axm",ano,"",l_code,"oha_file","oha01","")             #No.FUN-560014                                                                     
            RETURNING li_result,g_oha.oha01                                                                                         
            LET ano = s_get_doc_no(g_oha.oha01)   #No.FUN-560014
            DISPLAY BY NAME ano                                                                                                     
            IF (NOT li_result) THEN                                                                                                 
               NEXT FIELD ano                                                                                                       
            END IF                                                                                                                  
#              CALL s_axmslip(ano,l_code,g_sys)  #檢查單別
#              IF NOT cl_null(g_errno) THEN         #抱歉, 有問題
#                 CALL cl_err(ano,g_errno,0)
#                 NEXT FIELD ano
#              END IF
#           ELSE
#              IF NOT cl_null(ano[1,3]) AND NOT cl_null(ano[5,10]) THEN  #指定單號的check
#                 SELECT COUNT(*) INTO g_cnt FROM oha_file WHERE oha01=ano
#                 IF g_cnt > 0 THEN   #資料重複
#                    CALL cl_err('銷退單','aap-737',1)
#                    NEXT FIELD ano
#                 END IF
#                 LET g_check="Y"
#              ELSE
#                 CALL cl_err('銷退單號','aap-009',1)
#                 NEXT FIELD ano
#              END IF
           END IF
         #No.FUN-550064 ---end--- 
         
         AFTER FIELD bdate
            IF cl_null(bdate) THEN
               NEXT FIELD bdate 
            END IF
         
         AFTER FIELD cdate
            IF cl_null(cdate) THEN
               NEXT FIELD cdate 
            END IF
           
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(ano)     #查詢單据
                  #CALL q_oay(FALSE,FALSE,ano,'60',g_sys) RETURNING ano #TQC-670008
                  CALL q_oay(FALSE,FALSE,ano,'60','axm') RETURNING ano  #TQC-670008  #FUN-A70130 
#                  CALL FGL_DIALOG_SETBUFFER(ano)
                  DISPLAY BY NAME ano 
                  NEXT FIELD ano
            END CASE
 
       ON ACTION locale
       #->No.FUN-570122--start---
       #  LET g_action_choice='locale'
       #  CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
          LET g_change_lang = TRUE
       #->No.FUN-570122--end---
          EXIT INPUT
 
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT
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
 
      
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
      END INPUT
 
#      IF g_action_choice = 'locale' THEN   #NO.FUN-570149 
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   #FUN-550037(smin)
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p120_w                    #No.FUN-570149
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM                           #No.FUN-570149
#        EXIT WHILE                             #No.FUN-570149
      END IF
 
#NO.FUN-570149 mark--
#      LET g_sql = "SELECT rma01,rmc04,sum(rmb12),rmb13 ",
#                 #"FROM rma_file,OUTER (rmc_file, OUTER rmb_file) ",
#                  "FROM rma_file,rmc_file LEFT JOIN rmb_file ON rmc_file.rmc01 = rmb_file.rmb01 ",
#                  "WHERE rma01=rmc01 AND rmc01=rmb_file.rmb01 AND rmc04=rmb_file.rmb03 ",
#                  " AND rmc14='","3","'"," AND rmaconf= '","Y","'",
#                  " AND rmc23 IS NOT NULL AND ",g_wc CLIPPED,
#                  " GROUP BY rma01,rmc04,rmb13 ",
#                  " ORDER BY 1,2 "
 
#      PREPARE p120_prepare FROM g_sql
#      DECLARE p120_cs CURSOR FOR p120_prepare
#NO.FUN-571049 mark--
 
 
      IF g_check="Y" THEN
         LET g_sql= "SELECT COUNT(DISTINCT rma01)  ",
                    "  FROM rma_file " ,
                    "  WHERE rma09='","4","'",
                    "  AND rmaconf= '","Y","'",
                    "  AND ",g_wc CLIPPED
 
         PREPARE p120_precount FROM g_sql
         DECLARE p120_count CURSOR FOR p120_precount
 
         OPEN p120_count
         FETCH p120_count INTO g_cnt
         IF g_cnt!=1 AND g_check="Y" THEN
            CALL cl_err('RMA單號條件錯誤',status,1)
            CLOSE p120_count
            CONTINUE WHILE
         END IF
         CLOSE p120_count
      END IF
#NO.FUN-570149 start--
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO lc_cmd FROM zz_file
          WHERE zz01 = "armp120"
         IF SQLCA.sqlcode OR cl_null(lc_cmd) THEN
            CALL cl_err('armp120','9031',1)
         ELSE
            LET g_wc=cl_replace_str(g_wc, "'", "\"")
            LET lc_cmd = lc_cmd CLIPPED,
                         " '",g_wc CLIPPED,"'",
                         " '",ano CLIPPED,"'",
                         " '",bdate CLIPPED,"'",
                         " '",cdate CLIPPED,"' ",
                         " '",g_bgjob CLIPPED,"' "
            CALL cl_cmdat('armp120',g_time,lc_cmd CLIPPED)
         END IF
         CLOSE WINDOW p120_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF
      ERROR ""
     EXIT WHILE
#NO.FUN-570149 end---
 
#NO.FUN-570149 mark--
#      IF cl_sure(20,20) THEN
#         LET g_success = 'Y'
#         BEGIN WORK
#         OPEN p120_cs
#         LET g_count=0
#         CALL p120_ins()
#         IF g_count= 0 THEN
#            CALL cl_err('','aap-129',1)     # 無符合條件資料
#            CLOSE p120_cs
#            CONTINUE WHILE
#         END IF
#         IF g_success = 'Y' THEN
#            COMMIT WORK
#            MESSAGE "START NO.",g_startno," TO ",g_lastno
#            CALL ui.Interface.refresh()
#            CALL cl_end2(1) RETURNING l_flag
#         ELSE
#            ROLLBACK WORK
#            CALL cl_end2(2) RETURNING l_flag
#         END IF
#         IF l_flag THEN CONTINUE WHILE ELSE EXIT WHILE END IF
#      END IF
#      CLOSE p120_cs
#      EXIT WHILE 
#   END WHILE
#   CLOSE WINDOW p120_w
#NO.FUN-570149 mark--
   END WHILE
END FUNCTION
 
#No.FUN-570149 --start--
FUNCTION p120_cur()
      LET g_sql = "SELECT rma01,rmc04,sum(rmb12),rmb13 ",
                 #"FROM rma_file,OUTER (rmc_file, OUTER rmb_file) ",
                  "FROM rma_file,rmc_file LEFT JOIN rmb_file ON rmc_file.rmc01 = rmb_file.rmb01 ",
                  "WHERE rma01=rmc01 AND rmc04=rmb03 ",
                  " AND rmc14='","3","'"," AND rmaconf= '","Y","'",
                  " AND rmc23 IS NOT NULL AND ",g_wc CLIPPED,
                  " GROUP BY rma01,rmc04,rmb13 ",
                  " ORDER BY 1,2 "
 
      PREPARE p120_prepare FROM g_sql
      DECLARE p120_cs CURSOR FOR p120_prepare
         OPEN p120_cs
         LET g_count=0
         CALL p120_ins()
         IF g_count= 0 THEN
            CALL cl_err('','aap-129',1)     # 無符合條件資料
            CLOSE p120_cs
            LET g_success = 'N' 
         END IF
END FUNCTION
#NO.FUN-570149 end--
 
FUNCTION p120_ins()
   DEFINE   li_result   LIKE type_file.num5          #No.FUN-550064    #No.FUN-690010 SMALLINT
    INITIALIZE g_rm.*   TO NULL
    INITIALIZE g_rmac.* TO NULL
    FOREACH p120_cs INTO g_rm.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('資料被他人鎖住',SQLCA.sqlcode,0)     # 資料被他人LOCK
         LET g_success = 'N'
         EXIT FOREACH
      END IF
      IF g_rm.rma01 != g_rma01_t THEN
         INITIALIZE g_oha.* TO NULL
        #IF ano[1,3] != ' ' AND ano[5,10] = ' ' THEN
         IF g_check="N" THEN     #條件為: 自動編號
      #No.FUN-550064 --start--                                                                                                      
        CALL s_auto_assign_no("axm",ano,g_today,"60","oha_file","oha01","","","")     #No.FUN-560014 
        RETURNING li_result,g_oha.oha01                                                    
      IF (NOT li_result) THEN                                                                                                       
 
#           CALL s_armauno(ano,g_today) RETURNING g_i,g_oha.oha01
#           IF g_i THEN   #有問題
#              CALL cl_err(ano,g_errno,0)
      #No.FUN-550064 ---end---  
 
               LET g_success = 'N'
               RETURN
            END IF
         ELSE                    #條件為: 指定銷退單號(一對一:rma對oha)
            LET g_oha.oha01=ano
         END IF
         CALL p120_get_rmac()
         CALL p120_ins_oha()
         LET g_cnt=0
         IF g_success = 'Y' THEN
            CALL p120_up_rma()
            IF g_success = 'N' THEN
               RETURN
            END IF
         END IF
      END IF
      IF g_success = 'Y' THEN
         IF g_rm.rmb12_t IS NULL THEN LET g_rm.rmb12_t=0 END IF
         IF g_rm.rmb13   IS NULL THEN LET g_rm.rmb13  =0 END IF
         CALL p120_get_rmac()
         CALL p120_ins_ohb()
         IF g_success = 'N' THEN
            EXIT FOREACH
         END IF
      ELSE
         EXIT FOREACH
      END IF
      LET g_rma01_t = g_rm.rma01
      LET g_rmc04_t = g_rm.rmc04
      LET g_count   = g_count+1
      IF g_count = 1 AND g_success='Y' THEN
         LET g_startno=g_oha.oha01
      END IF
    END FOREACH
    IF g_success='Y' THEN
       LET g_lastno=g_oha.oha01
    END IF
 
END FUNCTION
 
FUNCTION p120_ins_oha()  # add 銷退單單頭
 
    LET g_oha.oha02   = bdate
    LET g_oha.oha03   = g_rmac.rma03
    LET g_oha.oha032  = g_rmac.rma04
    LET g_oha.oha04   = g_rmac.rma03
    LET g_oha.oha08   = g_rmac.rma08
    LET g_oha.oha09   = "1"
    LET g_oha.oha14   = g_rmac.rma13
    LET g_oha.oha15   = g_rmac.rma14
    LET g_oha.oha16   = g_rmac.rma15
    LET g_oha.oha23   = g_rmac.rma16
    LET g_oha.oha24   = g_rmac.rma17
    LET g_oha.oha48   = g_rmac.rma18
    LET g_oha.oha211  = 0
    LET g_oha.oha50   = 0
    LET g_oha.oha53   = 0
    LET g_oha.oha54   = 0
    LET g_oha.ohaprsw = 0
    LET g_oha.ohaconf = 'N'
    LET g_oha.ohapost = 'N'
    LET g_oha.ohauser = g_user
    LET g_oha.ohagrup = g_grup
    LET g_oha.oha85=' '  #No.FUN-870007
    LET g_oha.oha94='N'  #No.FUN-870007
    LET g_oha.ohaplant = g_plant #FUN-980007
    LET g_oha.ohalegal = g_legal #FUN-980007
 
    LET g_oha.ohaoriu = g_user      #No.FUN-980030 10/01/04
    LET g_oha.ohaorig = g_grup      #No.FUN-980030 10/01/04
    IF cl_null(g_oha.oha57) THEN LET g_oha.oha57 = '1' END IF #FUN-AC0055 add
    INSERT INTO oha_file VALUES(g_oha.*)
    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#       CALL cl_err('p120_ins_oha:',SQLCA.sqlcode,1) # FUN-660111
       CALL cl_err3("ins","oha_file",g_oha.oha01,"",SQLCA.sqlcode,"","p120_ins_oha:",1) # FUN-660111
       LET g_success = 'N'
    END IF
END FUNCTION
 
FUNCTION p120_get_rmac()  #get rma,rmc (rmc01=g_rm.rma01,rmc04=g_rm.rmc04)
    SELECT rma03,rma04,rma08,rma13,rma14,rma15,rma16,rma17,rma18,rmc05,rmc06
           INTO g_rmac.*
           FROM rmc_file,rma_file
           WHERE rmc01=g_rm.rma01 AND rmc04=g_rm.rmc04 AND rmc01=rma01
END FUNCTION
 
FUNCTION p120_ins_ohb()  # add 銷退單單身
    DEFINE l_ohbi   RECORD LIKE ohbi_file.* #FUN-B70074  add    
    DEFINE g_oha14       LIKE oha_file.oha14,     #FUN-CB0087
           g_oha15       LIKE oha_file.oha15      #FUN-CB0087
    
    INITIALIZE g_ohb.* TO NULL
    LET g_ohb.ohb01     = g_oha.oha01
    LET g_cnt           = g_cnt+1
    LET g_ohb.ohb03     = g_cnt
    LET g_ohb.ohb04     = g_rm.rmc04
    LET g_ohb.ohb05     = g_rmac.rmc05
    LET g_ohb.ohb05_fac = 1
    LET g_ohb.ohb06     = g_rmac.rmc06
    LET g_ohb.ohb12     = g_rm.rmb12_t
    LET g_ohb.ohb13     = g_rm.rmb13
    LET g_ohb.ohb14     = 0
    LET g_ohb.ohb14t    = 0
    LET g_ohb.ohb15     = g_rm.rmc04
    LET g_ohb.ohb15_fac = 1
    LET g_ohb.ohb16     = 0
    LET g_ohb.ohb60     = 0
    LET g_ohb.ohb32     = 0
    LET g_ohb.ohb34     = 0
    LET g_ohb.ohb930    =s_costcenter(g_oha.oha15) #FUN-680006
    LET g_ohb.ohb64='1' #No.FUN-870007
    LET g_ohb.ohb67=0   #No.FUN-870007
    LET g_ohb.ohb68='N' #No.FUN-870007
    LET g_ohb.ohbplant = g_plant #FUN-980007
    LET g_ohb.ohblegal = g_legal #FUN-980007
    
    LET g_ohb.ohb12 = s_digqty(g_ohb.ohb12,g_ohb.ohb05)     #FUN-BB0085
    #FUN-AB0061----------add---------------str----------------
    IF cl_null(g_ohb.ohb37) OR g_ohb.ohb37 = 0 THEN 
       LET g_ohb.ohb37 = g_ohb.ohb13
    END IF   
    #FUN-AB0061----------add---------------end---------------- 
    #FUN-AB0096 ---------add start----------------------
    #IF cl_null(g_ohb.ohb71) THEN   #FUN-AC0055 mark
    #   LET g_ohb.ohb71 = '1'
    #END IF
    #FUN-AB0096 ---------add end---------------------
    #FUN-CB0087---add---str---
    IF g_aza.aza115 = 'Y' THEN
       SELECT oha14,oha15 INTO g_oha14,g_oha15 FROM oha_file WHERE oha01 = g_ohb.ohb01
       CALL s_reason_code(g_ohb.ohb01,g_ohb.ohb31,'',g_ohb.ohb04,g_ohb.ohb09,g_oha14,g_oha15) RETURNING g_ohb.ohb50
       IF cl_null(g_ohb.ohb50) THEN
          CALL cl_err('','aim-425',1)
          LET g_success = 'N'
          RETURN 
       END IF
    END IF
    #FUN-CB0087---add---end---
    INSERT INTO ohb_file VALUES(g_ohb.*)
    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#       CALL cl_err('p120_ins_ohb:',SQLCA.sqlcode,1) #FUN-660111
      CALL cl_err3("ins","ohb_file",g_ohb.ohb01,g_ohb.ohb03,SQLCA.sqlcode,"","p120_ins_ohb:",1) # FUN-660111
       LET g_success = 'N'
       RETURN
#FUN-B70074--add--insert--
    ELSE
       IF NOT s_industry('std') THEN
          INITIALIZE l_ohbi.* TO NULL
          LET l_ohbi.ohbi01 = g_ohb.ohb01
          LET l_ohbi.ohbi03 = g_ohb.ohb03
          IF NOT s_ins_ohbi(l_ohbi.*,g_ohb.ohbplant) THEN
             LET g_success = 'N'  
             RETURN
          END IF
       END IF 
#FUN-B70074--add--insert--
    END IF
    UPDATE rmc_file            # update rmc(rmc01=rma01)
           SET rmc22 = cdate,rmc23=g_oha.oha01,rmc24=g_ohb.ohb03,rmc21="2"
           WHERE rmc01=g_rm.rma01 AND rmc04=g_rm.rmc04
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
 #        CALL cl_err('p120_ins_oha:',SQLCA.sqlcode,1) # FUN-660111
         CALL cl_err3("upd","rmc_file",g_rm.rma01,"",SQLCA.sqlcode,"","p120_ins_oha:",1) # FUN-660111
         LET g_success = 'N'
      END IF
END FUNCTION
 
FUNCTION p120_up_rma()  # update rma
    UPDATE rma_file SET rma19 = g_today
           WHERE rma01=g_rm.rma01
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#          CALL cl_err('up rma 失敗!',SQLCA.sqlcode,1) # FUN-660111
           CALL cl_err3("upd","rma_file",g_rm.rma01,"",SQLCA.sqlcode,"","up rma 失敗!",1) # FUN-660111
          LET g_success = 'N'
          RETURN
       END IF
END FUNCTION
