# Prog. Version..: '5.30.06-13.03.12(00010)'     #
 
#
# Pattern name...: amsp620.4gl
# Descriptions...: 粗略產能規劃
# Date & Author..: 92/01/14 By Carol
# Modify.........: No.FUN-570126 06/03/08 By yiting 批次背景執行
# Modify.........: No.FUN-660108 06/06/12 BY cheunl  cl_err --->cl_err3
# Modify.........: No.FUN-680101 06/08/29 By Dxfwo  欄位類型定義
# Modify.........: No.FUN-6A0081 06/11/06 By atsea l_time轉g_time
# Modify.........: No.MOD-740180 07/03/23 By Pengu 649行會出現-254訊息
# Modify.........: No.TQC-770036 07/07/05 By wujie 抓取工單日期調整檔時，應抓取mpu03，完工日期
# Modify.........: No.FUN-710073 07/12/03 By jamie 1.UI將 '天' -> '天/生產批量'
#                                                  2.將程式有用到 'XX前置時間'改為乘以('XX前置時間' 除以 '生產單位批量(ima56)')
# Modify.........: No.CHI-810015 08/01/17 By jamie 將FUN-710073修改部份還原
# Modify.........: No.FUN-840194 08/06/24 By sherry 增加變動前置時間批量（ima061）
# Modify.........: No.FUN-980005 09/08/13 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-9C0460 09/12/31 By Smapmin 數量應該要可以算到小數第三位
# Modify.........: No:MOD-A10001 10/01/05 By Smapmin 來源為PLM時,預計開工日應由預計完工日推算
# Modify.........: No:CHI-A70049 10/08/27 By Pengu  將多餘的DISPLAY程式mark
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   未加離開前得cl_used(2) 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE rqr       RECORD LIKE rqr_file.*,
       g_rqa     RECORD LIKE rqa_file.*,
       rqb       RECORD LIKE rqb_file.*,
       eco       RECORD LIKE eco_file.*,
       eco_o     RECORD LIKE eco_file.*,
       mpt       RECORD LIKE mpt_file.*,
       mps       RECORD LIKE mps_file.*,
       ver_no    LIKE rqr_file.rqr_v,
       rccp_ver  LIKE rqb_file.rqb02,
       incl_wo,incl_mps,incl_plm   LIKE type_file.chr1,    #NO FUN-680101 VARCHAR(01)
       g_mps00		LIKE type_file.num10,              #NO FUN-680101 INTEGER
       g_argv1		LIKE type_file.chr2                #NO FUN-680101 VARCHAR(2)   
 
DEFINE   g_cnt           LIKE type_file.num10         #NO FUN-680101 INTEGER   
DEFINE   g_i             LIKE type_file.num5          #NO FUN-680101 SMALLINT  #count/index for any purpose
DEFINE   g_msg           LIKE type_file.chr1000       #NO FUN-680101 VARCHAR(72)
DEFINE   p_row,p_col     LIKE type_file.num5,         #NO FUN-680101 SMALLINT
         g_flag          LIKE type_file.chr1,         #No.FUN-570126           #NO FUN-680101 VARCHAR(1)
         g_change_lang   LIKE type_file.chr1          #是否有做語言切換 No.FUN-570126  #NO FUN-680101 VARCHAR(01)
 
MAIN
#     DEFINE    l_time LIKE type_file.chr8            #No.FUN-6A0081
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   #->No.FUN-570126 --start--
   INITIALIZE g_bgjob_msgfile TO NULL
   LET ver_no     = ARG_VAL(1)
   LET rccp_ver   = ARG_VAL(2)
   LET incl_wo    = ARG_VAL(3)
   LET incl_mps   = ARG_VAL(4)
   LET incl_plm   = ARG_VAL(5)
   LET g_bgjob    = ARG_VAL(6)    #背景作業
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
   #->No.FUN-570126 ---end---
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AMS")) THEN
      EXIT PROGRAM
   END IF
 
 
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
#NO.FUN-570126 mark------------
#    LET p_row = 6 LET p_col = 34
 
#    OPEN WINDOW p620_w AT p_row,p_col WITH FORM "ams/42f/amsp620" 
#      ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
#    CALL cl_ui_init()
#    LET ver_no  =''
#    WHILE TRUE 
#       CALL p620_ask()
#       IF INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE END IF
#       IF NOT cl_sure(20,20) THEN EXIT WHILE END IF
#       CALL cl_wait()
#       CALL p620_mrp()
#       ERROR ''
#       IF INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE END IF
#       CALL cl_end(0,0) 
#       EXIT WHILE
#    END WHILE
#    CLOSE WINDOW p620_w
#NO.FUN-570126 mark----------
 
#NO.FUN-570126 start--------
    LET g_success = 'Y'
      WHILE TRUE
      IF g_bgjob = "N" THEN
         CALL p620_ask()
         IF cl_sure(18,20) THEN
            LET g_success = 'Y'
            BEGIN WORK
            CALL p620_mrp()
            IF g_success = 'Y' THEN
               COMMIT WORK
               CALL cl_end2(1) RETURNING g_flag
            ELSE
               ROLLBACK WORK
               CALL cl_end2(2) RETURNING g_flag
            END IF
           IF g_flag THEN
              CONTINUE WHILE
           ELSE
              CLOSE WINDOW p620_w
              EXIT WHILE
           END IF
       ELSE
          CONTINUE WHILE
       END IF
    ELSE
       BEGIN WORK
       LET g_success = 'Y'
       CALL p620_mrp()
        IF g_success = "Y" THEN
          COMMIT WORK
       ELSE
          ROLLBACK WORK
       END IF
       CALL cl_batch_bg_javamail(g_success)
       EXIT WHILE
    END IF
 END WHILE
#->No.FUN-570126 ---end---
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
END MAIN
   
FUNCTION p620_wc_default()
   SELECT * INTO rqr.* FROM rqr_file WHERE rqr_v=ver_no
   IF STATUS=0
      THEN 
           LET incl_wo  =rqr.incl_wo
           LET incl_mps =rqr.incl_mps
           LET incl_plm =rqr.incl_plm
      ELSE LET incl_wo  = 'Y'
           LET incl_mps = 'Y'
           LET incl_plm ='Y'
   END IF
END FUNCTION
 
FUNCTION p620_ask()
DEFINE   lc_cmd        LIKE type_file.chr1000  #No.FUN-570126  #NO FUN-680101 VARCHAR(500)
 
#NO.FUN-570126 start---
   LET p_row = 6 LET p_col = 34
 
   OPEN WINDOW p620_w AT p_row,p_col WITH FORM "ams/42f/amsp620" 
      ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   
   CALL cl_ui_init()
 
#NO.FUN-570126 end-----
 WHILE TRUE  #NO.FUN-570126
 
   LET rccp_ver = g_mpz.mpz05
   LET g_bgjob = 'N' #NO.FUN-570126 
   DISPLAY rccp_ver TO FORMONLY.rccp_ver
  
   #INPUT BY NAME ver_no,rccp_ver,incl_wo,incl_mps,incl_plm WITHOUT DEFAULTS 
   INPUT BY NAME ver_no,rccp_ver,incl_wo,incl_mps,incl_plm,g_bgjob  WITHOUT DEFAULTS   #NO.FUN-570126
 
      ON ACTION locale
          #CALL cl_dynamic_locale()                  #NO.FUN-570126 MARK
          #CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
          LET g_change_lang = TRUE                   #NO.FUN-570126 
          EXIT INPUT
 
      AFTER FIELD ver_no
         IF ver_no IS NULL THEN
            NEXT FIELD ver_no
         END IF
         IF cl_null(incl_wo) THEN
            CALL p620_wc_default()
            DISPLAY BY NAME incl_wo,incl_mps,incl_plm 
         END IF
  
      AFTER FIELD rccp_ver
         IF rccp_ver IS NULL THEN 
            LET rccp_ver = ' '
         END IF
  
      AFTER FIELD incl_wo
         IF cl_null(incl_wo) OR incl_wo NOT MATCHES '[YN]' THEN
            NEXT FIELD incl_wo
         END IF
 
      AFTER FIELD incl_mps
         IF cl_null(incl_mps) OR incl_mps NOT MATCHES '[YN]' THEN
            NEXT FIELD incl_mps
         END IF
 
      AFTER FIELD incl_plm
         IF cl_null(incl_plm) OR incl_plm NOT MATCHES '[YN]' THEN
            NEXT FIELD incl_plm
         END IF
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
    
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
    END INPUT
#NO.FUN-570126 start---
#    IF INT_FLAG THEN
#       RETURN
#    END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p620_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM
#       EXIT WHILE
   END IF
 
   IF g_change_lang THEN
      LET g_change_lang = FALSE
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
 
   IF g_bgjob = "Y" THEN
       SELECT zz08 INTO lc_cmd FROM zz_file
        WHERE zz01 = "amsp620"
       IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
           CALL cl_err('amsp620','9031',1)
       ELSE
           LET lc_cmd = lc_cmd CLIPPED,
                       " '",ver_no CLIPPED ,"'",
                        " '",rccp_ver CLIPPED ,"'",
                        " '",incl_wo CLIPPED ,"'",
                        " '",incl_mps CLIPPED ,"'",
                        " '",incl_plm CLIPPED ,"'",
                        " '",g_bgjob CLIPPED,"'"
         CALL cl_cmdat('amsp620',g_time,lc_cmd CLIPPED)
      END IF
      CLOSE WINDOW p620_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM
   END IF
  EXIT WHILE
  #->No.FUN-570126 ---end---
END WHILE
END FUNCTION
 
## 粗略產能規劃參數檔
FUNCTION p620_ins_rqr1()
  DEFINE l_rqr02    LIKE rqr_file.rqr02    #NO FUN-680101 VARCHAR(8)
  
   IF g_bgjob = 'N' THEN  #NO.FUN-570126 
       MESSAGE "Start......"
       CALL ui.Interface.refresh()
   END IF
   INITIALIZE rqr.* TO NULL
     LET rqr.rqr_v   =ver_no
     LET rqr.rqr01   =TODAY
     LET l_rqr02 = TIME
     LET rqr.rqr02   =l_rqr02
     LET rqr.rqr05   =g_user
     LET rqr.incl_wo =incl_wo
     LET rqr.incl_mps=incl_mps
     LET rqr.incl_plm=incl_plm
   DELETE FROM rqr_file WHERE rqr_v=ver_no
   IF STATUS THEN 
#  CALL cl_err('del rqr',STATUS,1)  #No.FUN-660108
   CALL cl_err3("del","rqr_file",ver_no,"",STATUS,"","del rqr",1)       #No.FUN-660108
   END IF
   INSERT INTO rqr_file VALUES(rqr.*)
   IF STATUS THEN 
#  CALL cl_err('ins rqr',STATUS,1)  #No.FUN-660108
   CALL cl_err3("ins","rqr_file",rqr.rqr_v,"",STATUS,"","ins rqr",1)       #No.FUN-660108    
       CALL cl_batch_bg_javamail("N")   #NO.FUN-570126 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
       EXIT PROGRAM 
   END IF
END FUNCTION
 
# 記錄執行截止時間
FUNCTION p620_ins_rqr2()
  DEFINE l_rqr03   LIKE rqr_file.rqr03        #NO FUN-680101 VARCHAR(8)
 
   IF g_bgjob = 'N' THEN  #NO.FUN-570126 
       MESSAGE "End......"
       CALL ui.Interface.refresh()
   END IF
   LET l_rqr03 = TIME
   LET rqr.rqr03=l_rqr03
   LET rqr.rqr04=g_mps00
    UPDATE rqr_file SET rqr03=rqr.rqr03 , rqr04=rqr.rqr04
          WHERE rqr_v=ver_no
   IF STATUS THEN 
#  CALL cl_err('upd rqr',STATUS,1)  #No.FUN-660108
   CALL cl_err3("del","rqr_file",ver_no,"",STATUS,"","upd rqr",1)       #No.FUN-660108  
   END IF
#  UPDATE sma_file SET sma21=TODAY WHERE sma00='0'
END FUNCTION
 
# 將原資料(rqa,rqb,rqr)清除
FUNCTION p620_del()
   CALL p620_upd_rqa()		# 將原資料(rqa_file)已耗產能更新為0
   CALL p620_del_rqb() 		# 將原資料(rqb_file)清除
END FUNCTION
 
FUNCTION p620_upd_rqa()
   UPDATE rqa_file SET rqa06 = 0  WHERE rqa02 =rccp_ver
   IF STATUS THEN
#    CALL cl_err('upd rqa',STATUS,1)  #No.FUN-660108
     CALL cl_err3("upd","rqa_file",rccp_ver,"",STATUS,"","upd rqa",1)       #No.FUN-660108     
       CALL cl_batch_bg_javamail("N")  #NO.FUN-570126
       CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
       EXIT PROGRAM 
   END IF
END FUNCTION
 
FUNCTION p620_del_rqb()
   DELETE FROM rqb_file WHERE rqb02=rccp_ver
   IF STATUS THEN
#  CALL cl_err('del rqb',STATUS,1)  #No.FUN-660108
   CALL cl_err3("del","rqb_file",rccp_ver,"",STATUS,"","del rqb",1)       #No.FUN-660108
   END IF
END FUNCTION
 
FUNCTION p620_declare()		# DECLARE Insert Cursor
   DEFINE l_sql		LIKE type_file.chr1000   #NO FUN-680101 VARCHAR(600)
 
  #LET l_sql="SELECT ima59,ima60,ima61,ima94,ima571,ima56 FROM ima_file ",  #CHI-810015 mark #FUN-710073 add ima56
  #LET l_sql="SELECT ima59,ima60,ima61,ima94,ima571 FROM ima_file ",        #No.FUN-840194 #CHI-810015 mod  #FUN-710073 add ima56
   LET l_sql="SELECT ima59,ima60,ima601,ima61,ima94,ima571 FROM ima_file ", #No.FUN-840194 #CHI-810015 mod  #FUN-710073 add ima56
             "WHERE ima01 = ? " 
   PREPARE p620_sel_ima FROM l_sql
   IF STATUS THEN CALL cl_err('pre sel_ima',STATUS,1) END IF
   DECLARE p620_c_sel_ima CURSOR WITH HOLD FOR p620_sel_ima
   IF STATUS THEN CALL cl_err('dec sel_ima',STATUS,1) END IF
    
# 產品製程資源資料
   LET l_sql="SELECT eco_file.*  FROM eco_file ", 
             "WHERE eco01 = ? AND eco02 =? ",
             "ORDER BY eco03 DESC,eco04"    # 製程序號,資源代號
   PREPARE p620_sel_eco FROM l_sql
   IF STATUS THEN CALL cl_err('pre sel_eco',STATUS,1) END IF
   DECLARE p620_c_sel_eco CURSOR WITH HOLD FOR p620_sel_eco
   IF STATUS THEN CALL cl_err('dec sel_eco',STATUS,1) END IF
 
# 每日資源
   LET l_sql="SELECT rqa03,rqa04,rqa05,rqa06 FROM rqa_file ", 
             " WHERE rqa01 = ?  AND rqa02 =  ? ",
             "   AND rqa03 <= ? AND rqa04 >=? "
 
   PREPARE p620_sel_rqa FROM l_sql
   IF STATUS THEN CALL cl_err('pre sel_rqa',STATUS,1) END IF
   DECLARE p620_c_sel_rqa CURSOR WITH HOLD FOR p620_sel_rqa
   IF STATUS THEN CALL cl_err('dec sel_rqa',STATUS,1) END IF
 
# 粗略產能資源耗用明細
   LET l_sql="INSERT INTO rqb_file VALUES (?,?,?,?,?,?,?,?,?,?,?,?,? ,?,?)" #FUN-980005 add ?,? for plant,legal
   PREPARE p620_p_ins_rqb FROM l_sql
   IF STATUS THEN CALL cl_err('pre ins_rqb',STATUS,1) END IF
   DECLARE p620_c_ins_rqb CURSOR WITH HOLD FOR p620_p_ins_rqb 
   IF STATUS THEN CALL cl_err('dec ins_rqb',STATUS,1) END IF
 
   LET l_sql="UPDATE rqa_file SET rqa06 =rqa06 +?",
             " WHERE rqa01 = ? AND rqa02=? ",
             "   AND rqa03 = ? AND rqa04=? "
   PREPARE p620_p_upd_rqa06  FROM l_sql
   IF STATUS THEN CALL cl_err('pre upd_rqa06',STATUS,1) END IF
 
END FUNCTION
 
FUNCTION p620_mrp()
 
    CALL p620_ins_rqr1()		# 版本記錄 begin
    CALL p620_del()		        # 將原資料(rqa,rqb,rqr)清除
    CALL p620_declare()		        # DECLARE Insert Cursor
   
    OPEN p620_c_ins_rqb
    IF STATUS THEN CALL cl_err('open ins_rqb',STATUS,1) END IF
    CALL p620_wo_mps()
    FLUSH p620_c_ins_rqb         # 將insert rqb_file 的 cursor 寫入 database
 
    IF incl_plm = 'Y'
       THEN
       CALL p620_plm()
       FLUSH p620_c_ins_rqb      # 將insert rqb_file 的 cursor 寫入 database
    END IF
 
    CLOSE p620_c_ins_rqb
    CALL p620_ins_rqr2()		# 版本記錄結束
END FUNCTION 
 
# 計算工單及MPS計劃產所耗用的產能
FUNCTION p620_wo_mps()
 DEFINE  l_lot,l_rem  LIKE type_file.num10,    #NO FUN-680101 INTEGER
         l_ima59      LIKE ima_file.ima59,
         l_ima60      LIKE ima_file.ima60,
         l_ima601     LIKE ima_file.ima601,    #No.FUN-840194 
         l_ima61      LIKE ima_file.ima61,
         l_ima94      LIKE ima_file.ima94,
         l_ima571     LIKE ima_file.ima571,
        #l_ima56      LIKE ima_file.ima56,     #CHI-810015 mark #FUN-710073 add
         l_tottime    LIKE rqb_file.rqb09,
         l_leadtime   LIKE type_file.num5,     #NO FUN-680101 SMALLINT
         l_free       LIKE rqa_file.rqa05,     #NO FUN-680101 DEC(15,3)
         wo_bdate     LIKE type_file.dat,      #NO FUN-680101 DATE 
         sg_wo_bdate  LIKE type_file.dat,      #NO FUN-680101 DATE # 建議開工日期
         begin_date   LIKE type_file.dat,      #NO FUN-680101 DATE # 料件製程序開工日期
         date_tmp     LIKE type_file.dat,      #NO FUN-680101 DATE
         l_sql        LIKE type_file.chr1000   #NO FUN-680101 VARCHAR(600)
 
    LET l_sql = "SELECT mpt_file.*  FROM mpt_file ",
                " WHERE mpt_v = '",ver_no,"'"
 
# 64 : 在製量 (W/O)
# 65 : 計劃產 (MPS)
 
    CASE
        WHEN incl_wo = 'Y' AND incl_mps = 'Y'
             LET l_sql = l_sql clipped," AND mpt05 IN('64','65') "
        WHEN incl_wo = 'Y' AND incl_mps = 'N'
             LET l_sql = l_sql clipped," AND mpt05 ='64' "
        WHEN incl_wo = 'N' AND incl_mps = 'Y'
             LET l_sql = l_sql clipped," AND mpt05 ='65' "
        OTHERWISE    # W/O , MPS 都不用計算
             RETURN
    END CASE
 
    PREPARE p620_prempt FROM l_sql
    DECLARE p620_c_mpt CURSOR FOR p620_prempt
    
    FOREACH p620_c_mpt INTO mpt.*
      IF SQLCA.sqlcode THEN 
         CALL cl_err('fetch mpt',STATUS,1) EXIT FOREACH 
      END IF
 
      #-->取料件主檔中的預設製程料號/製程編號
       IF g_bgjob = 'N' THEN  #NO.FUN-570126 
           MESSAGE mpt.mpt01
           CALL ui.Interface.refresh()
       END IF
       OPEN p620_c_sel_ima  USING mpt.mpt01
       #FETCH p620_c_sel_ima INTO l_ima59,l_ima60,l_ima61,l_ima94,l_ima571         #No.FUN-840194 #CHI-810015 拿掉,l_ima56   #FUN-710073 add l_ima56 
       FETCH p620_c_sel_ima INTO l_ima59,l_ima60,l_ima601,l_ima61,l_ima94,l_ima571 #No.FUN-840194 #CHI-810015 拿掉,l_ima56   #FUN-710073 add l_ima56 
       IF SQLCA.sqlcode THEN CALL cl_err('fetch ima',STATUS,1) END IF
 
       #-->工單的預計開工日
       IF mpt.mpt05 = '64' THEN   
          # 工單日期調整檔
#         SELECT mpu03 INTO wo_bdate FROM mpu_file 
          SELECT mpu02 INTO wo_bdate FROM mpu_file       #No.TQC-770036
                       WHERE mpu_v = ver_no AND mpu01 =mpt.mpt06
          IF SQLCA.sqlcode THEN 
             SELECT sfb13 INTO wo_bdate FROM sfb_file
                       WHERE sfb01 = mpt.mpt06 AND sfb87!='X'
             IF SQLCA.sqlcode THEN LET wo_bdate = null END IF
          END IF
#         LET rqb.rqb063 = wo_bdate      #預計開工日
          LET begin_date = wo_bdate      #預計開工日
       ELSE  # MPS 計劃產
          #               固定前置 + 變動前置*數量 + QC 前置 , 單位(天)
          #               ima59,ima60 可由 aecu620 update
          #LET l_leadtime =l_ima59+l_ima60*mpt.mpt08+l_ima61     #No.FUN-840194 #CHI-810015 mark還原 #FUN-710073 mark
          LET l_leadtime =l_ima59+l_ima60/l_ima601*mpt.mpt08+l_ima61 #No.FUN-840194 #CHI-810015 mark還原 #FUN-710073 mark
         #LET l_leadtime =(l_ima59/l_ima56)+(l_ima60/l_ima56)*mpt.mpt08+  #CHI-810015 mark  #FUN-710073 mod
         #                (l_ima61/l_ima56)                               #CHI-810015 mark  #FUN-710073 mod
#         LET rqb.rqb063 =mpt.mpt04 - l_leadtime # 供需日期(實際)-LT
          LET begin_date =mpt.mpt04 - l_leadtime # 供需日期(實際)-LT
       END IF
 
      CALL rccp_allocat(rccp_ver,mpt.mpt01,l_ima94,l_ima571,mpt.mpt06,mpt.mpt08,
                        mpt.mpt05,mpt.mpt061,mpt.mpt03,begin_date,mpt.mpt04)
           RETURNING g_i,sg_wo_bdate
             
#display 'suggest begin date:',sg_wo_bdate  #CHI-A70049 mark
      IF g_i = -1
         THEN
         CONTINUE FOREACH
      END IF
 
   END FOREACH 
END FUNCTION 
   
 
FUNCTION p620_plm()  
 DEFINE  l_lot,l_rem  LIKE type_file.num10,   #NO FUN-680101 INTEGER
         l_ima59      LIKE ima_file.ima59,
         l_ima60      LIKE ima_file.ima60,
         l_ima601     LIKE ima_file.ima601,   #No.FUN-840194
         l_ima61      LIKE ima_file.ima61,
         l_ima94      LIKE ima_file.ima94,
         l_ima571     LIKE ima_file.ima571,
         l_tottime    LIKE rqb_file.rqb09,
         sg_wo_bdate  LIKE type_file.dat,     #NO FUN-680101 DATE # 建議開工日期
         l_sql        LIKE type_file.chr1000, #NO FUN-680101 VARCHAR(600)
         #-----MOD-A10001---------
         l_leadtime   LIKE type_file.num5,   
         begin_date   LIKE type_file.dat    
         #-----END MOD-A10001-----
 
    LET l_sql = "SELECT mps_file.*  FROM mps_file ",
                " WHERE mps_v = '",ver_no,"'",
                "   AND  mps09 > 0 "
 
    PREPARE p620_premps FROM l_sql
    DECLARE p620_c_mps CURSOR FOR p620_premps
    
    FOREACH p620_c_mps INTO mps.*
      IF SQLCA.sqlcode THEN 
         CALL cl_err('fetch mps',STATUS,1) EXIT FOREACH 
      END IF
#
#
 
      #-->取料件主檔中的預設製程編號
       OPEN p620_c_sel_ima  USING mps.mps01
       #FETCH p620_c_sel_ima INTO l_ima59,l_ima60,l_ima61,l_ima94,l_ima571   #No.FUN-840194
       FETCH p620_c_sel_ima INTO l_ima59,l_ima60,l_ima601,l_ima61,l_ima94,l_ima571  #No.FUN-840194
       IF SQLCA.sqlcode THEN CALL cl_err('fetch ima',STATUS,1) END IF
      #-----MOD-A10001---------
      LET l_leadtime =l_ima59+l_ima60/l_ima601*mps.mps09+l_ima61 
      LET begin_date =mps.mps03 - l_leadtime
      #-----END MOD-A10001----- 
      CALL rccp_allocat(rccp_ver,mps.mps01,l_ima94,l_ima571,'PLM',mps.mps09,
                        #'66',' ',mps.mps03,g_today,mps.mps03)   #MOD-A10001
                        '66',' ',mps.mps03,begin_date,mps.mps03)   #MOD-A10001
           RETURNING g_i,sg_wo_bdate
             
#display 'suggest begin date:',sg_wo_bdate  CHI-A70049 mark
 
      UPDATE mps_file SET mps11 = sg_wo_bdate
       WHERE mps01 = mps.mps01
         AND mps03 = mps.mps03
         AND mps_v = mps.mps_v
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 
         THEN 
 #       CALL cl_err('upd mps_file',STATUS,1)  #No.FUN-660108
         CALL cl_err3("upd","mps_file",mps.mps01,mps.mps03,STATUS,"","upd mps_file",1)       #No.FUN-660108
      END IF
      
      IF g_i = -1
         THEN
         CONTINUE FOREACH
      END IF
   END FOREACH 
END FUNCTION 
 
# 更新每日資源耗用, 及寫入耗用明細
FUNCTION p620_upd_rqa_ins_rqb(p_rqa06,p_eco04,p_ver,p_rqb)
DEFINE   p_rqa06  LIKE  rqa_file.rqa06,
         p_eco04  LIKE  eco_file.eco04,
         p_ver    LIKE  rqb_file.rqb02,   #NO FUN-680101 VARCHAR(2)
         p_rqb    RECORD LIKE rqb_file.*
 
   # Update 耗用
#display 'update rqa06+"',p_rqa06,' | ',p_rqb.rqb03,' | ',p_rqb.rqb04   #CHI-A70049 mark 
   EXECUTE p620_p_upd_rqa06 using p_rqa06,
                                  p_eco04,p_ver,
                                  p_rqb.rqb03,p_rqb.rqb04
   IF STATUS THEN CALL cl_err('upd rqa06:',STATUS,1) 
       CALL cl_batch_bg_javamail("N")   #NO.FUN-570126
       CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
       EXIT PROGRAM 
   END IF
 
   LET p_rqb.rqb09 = p_rqa06              #秏用產能
   PUT p620_c_ins_rqb FROM p_rqb.*
   IF STATUS THEN CALL cl_err('ins rqb',STATUS,1) 
       CALL cl_batch_bg_javamail("N")   #NO.FUN-570126
       CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
       EXIT PROGRAM 
   END IF
END FUNCTION
 
FUNCTION rccp_allocat(p_ver,p_item,p_ima94,p_ima571,p_mpt06,p_mpt08,
                      p_rqb05,p_rqb061,p_rqb062,p_rqb063,p_rqb064)
DEFINE p_ver    LIKE rqb_file.rqb02,     #NO FUN-680101 VARCHAR(2)  #版本   
       p_item   LIKE eco_file.eco01,     #料號
       p_ima94  LIKE ima_file.ima94,     #預設製程編號
       p_ima571 LIKE ima_file.ima571,    #製程料號
       p_mpt06  LIKE mpt_file.mpt06,     #來源單號
       p_mpt08  LIKE mpt_file.mpt08,     #數量
       p_rqb05  LIKE rqb_file.rqb05,     #來源類別 
       p_rqb061 LIKE rqb_file.rqb061,    #來源項次
       p_rqb062 LIKE rqb_file.rqb062,    #供需日期 (依時距推算)
       p_rqb063 LIKE rqb_file.rqb063,    #預計開工日
       p_rqb064 LIKE rqb_file.rqb064     #預計完工日
 
 DEFINE  l_lot,l_rem  LIKE rqb_file.rqb09,     #NO FUN-680101 INTEGER   #MOD-9C0460 num10-->rqb09
         l_tottime    LIKE rqb_file.rqb09,
         l_rccp_sum   LIKE rqb_file.rqb09,
         l_leadtime   LIKE type_file.num5,     #NO FUN-680101 SMALLINT
         l_free       LIKE rqa_file.rqa05,     #NO FUN-680101 DEC(15,3)
         l_rqa05      LIKE rqa_file.rqa05,
         l_rqa06      LIKE rqa_file.rqa06,
         wo_bdate     LIKE type_file.dat,      #NO FUN-680101 DATE 
         l_finish_date LIKE type_file.dat,     #NO FUN-680101 DATE # 完工日期
         date_tmp     LIKE type_file.dat       #NO FUN-680101 DATE
 
DEFINE l_eco    RECORD  LIKE eco_file.*
DEFINE l_eco_o  RECORD  LIKE eco_file.*
DEFINE l_rqb    RECORD  LIKE rqb_file.*
DEFINE l_item   LIKE eco_file.eco01            #No.MOD-740180 add
      
      #-->取產品製程資源資料
      # 先以原主件抓產品制程資料
       SELECT COUNT(*) INTO g_cnt FROM eco_file
        WHERE eco01 = p_item
          AND eco02 = p_ima94
      #---------------No.MOD-740180 modify
      #IF g_cnt = 0       # 原主件無產品制程資料
      #   THEN
      #   OPEN p620_c_sel_eco  USING p_ima571,p_ima94
      #ELSE               # 以料件基本資料之製程料號抓 eco_file
      #   OPEN p620_c_sel_eco  USING p_item,p_ima94
      #END IF
       IF g_cnt = 0       # 原主件無產品制程資料
          THEN
          LET l_item = p_ima571
       ELSE               # 以料件基本資料之製程料號抓 eco_file
          LET l_item = p_item
       END IF
      #---------------No.MOD-740180 end
       IF STATUS  
          THEN   
          LET g_msg = p_item CLIPPED,' 無產品製程資料'
          CALL cl_err(g_msg,'!',1)
#         CONTINUE FOREACH      # -- RETURN
          RETURN -1,''
       END IF
 
      LET l_rqb.rqb02 =p_ver             #版本
      LET l_rqb.rqb05 =p_rqb05           #來源類別 
      LET l_rqb.rqb06 =p_mpt06           #來源單號
      LET l_rqb.rqb061=p_rqb061          #來源項次
      LET l_rqb.rqb062=p_rqb062          #供需日期 (依時距推算)
      LET l_rqb.rqb063=p_rqb063          #預計開工日
      LET l_rqb.rqb064=p_rqb064          #預計完工日
      LET l_rqb.rqb065=p_item            #料號 
      LET l_rqb.rqb08 =p_mpt08           #數量
      LET l_rqb.rqbplant = g_plant       #FUN-980005 add
      LET l_rqb.rqblegal = g_legal       #FUN-980005 add
 
      LET l_finish_date = p_rqb064
 
## ------------------------------------------------------------------------
# 推算原則:
# 先算製程(1)的資源項目, 再推算製程(2)中各資源項目所耗用的產能,以此類推...
# 而在推算完製程(N)中所有資源後,保留耗用資源項目中最大的啟始日期,並與本
# 製程的開工日期比較,兩者取其大為下一製程序的開工日期
# ex : 工單開工日 5/2 製程(1):資源 (a)於 5/1 至 5/7 日可以滿足產能
#                             資源 (b)於 5/1 至 5/7 日無法滿足產能,
#                             而於 5/8 至 5/14 日可以滿足產能
#      而 5/8 > 5/2 日,因此製程(2)的開工日則為 5/8 日
## ------------------------------------------------------------------------
##
       INITIALIZE l_eco_o.* TO NULL
      #---------No.MOD-740180 modify
      #FOREACH p620_c_sel_eco INTO l_eco.* 
       FOREACH p620_c_sel_eco USING l_item,p_ima94 INTO l_eco.* 
      #---------No.MOD-740180 end
          IF SQLCA.sqlcode THEN
             CALL cl_err('fetch eco',STATUS,1) EXIT FOREACH 
          END IF
 
#display 'eco03:',l_eco.eco03,'  |  eco03_o:',l_eco_o.eco03  #CHI-A70049 mark
          IF l_eco.eco03 <> l_eco_o.eco03     # 製程序不同時,(至上一製程)
             THEN
             LET l_finish_date = date_tmp 
#display 'next eco03'   #CHI-A70049 mark
          END IF
 
          #-->計算耗用量
          #eco05:固定秏用 / eco06:變動秏用 / eco07:秏用批量 ,單位(人時/機時)
          #-----MOD-9C0460---------
          #LET l_rem = p_mpt08 MOD l_eco.eco07
          #IF l_rem != 0 THEN 
          #   LET l_lot = (p_mpt08 /l_eco.eco07) + 1
          #ELSE 
          #   LET l_lot = (p_mpt08 /l_eco.eco07)
          #END IF
          LET l_lot = (p_mpt08 /l_eco.eco07)
          #-----END MOD-9C0460----- 
 
          IF cl_null(l_lot) THEN LET l_lot = 0 END IF
 
          LET l_tottime = l_eco.eco05 + (l_lot * l_eco.eco06)
          LET l_rccp_sum = l_tottime               #需要產能總計
          LET l_rqb.rqb01 = l_eco.eco04            #資源代號 
 
# 將該資源項所要耗用的產能依序寫入每日資源的耗用產能欄位,直到產能 allocate完成
 
          LET date_tmp = l_finish_date
 
#       單號,料號,開工日期,完工日期,資源項目,總耗產能
display l_rqb.rqb06 CLIPPED,',',
        l_rqb.rqb01 CLIPPED,',',
        l_rqb.rqb063 CLIPPED,',',
        l_rqb.rqb064 CLIPPED,',',
        l_eco.eco04 CLIPPED,',',
        l_rccp_sum
#sleep 5
 
          WHILE TRUE
              OPEN p620_c_sel_rqa USING l_eco.eco04,p_ver,date_tmp,date_tmp
              FETCH p620_c_sel_rqa INTO l_rqb.rqb03,l_rqb.rqb04,
                                        l_rqa05,l_rqa06 #當日產能,已秏
              IF SQLCA.sqlcode 
                 THEN 
                 LET g_msg = p_mpt06 CLIPPED,' 找不到對應的每日資源資料'
                 CALL cl_err(g_msg,STATUS,1)
#                CONTINUE FOREACH    #  -- RETURN
                 RETURN -1,''
              END IF
 
# 1.若資源起始日期 <= 工單開工日期 <= 資源截止日期, 
#   則將所有未 allocate 的產能全部allocate在本期
#   WHEN 開工日為 NULL 時 , default 為 g_today
# 2.而產能 overflow 的部份, 待 Run amrr610 時建議調整
              IF l_rqb.rqb03  <= l_rqb.rqb063 AND # 資源開始日期<=開工日期
                 l_rqb.rqb063 <= l_rqb.rqb04      # 開工日期  <= 資源截止日期
                 OR
                 date_tmp <= g_today          # 日期  <= 系統日期
                 THEN 
                 CALL p620_upd_rqa_ins_rqb(l_tottime,
                                           l_eco.eco04,p_ver,
                                           l_rqb.*)
                 IF date_tmp <= g_today
                    THEN
                    display '產能規劃日期已<=系統日期'
                 END IF
                 EXIT WHILE
              END IF
 
              LET l_free = l_rqa05 - l_rqa06   # 當期剩餘產能
              IF l_free < 0.1       #  當期剩餘產能 >= 0.1 小時才予計算
                 THEN
                 LET date_tmp = l_rqb.rqb03 - 1          # 找上一筆每日資源
                 CONTINUE WHILE
              END IF
 
              IF l_free > l_tottime     # 可以滿足所需產能
                 THEN
                 # 更新每日資源耗用, 及寫入耗用明細
                 CALL p620_upd_rqa_ins_rqb(l_tottime,
                                           l_eco.eco04,p_ver,
                                           l_rqb.*)
                 EXIT WHILE
              ELSE                      # 可以部份滿足產能
                 CALL p620_upd_rqa_ins_rqb(l_free,
                                           l_eco.eco04,p_ver,
                                           l_rqb.*)
                 LET l_tottime = l_tottime - l_free   # 還剩多少產能未分配
                 LET date_tmp = l_rqb.rqb03 - 1          # 找上一筆每日資源
                 CONTINUE WHILE
              END IF
          END WHILE
          LET l_eco_o.* = l_eco.*
       END FOREACH 
       RETURN 0,date_tmp   # return 建議開工日期
END FUNCTION
