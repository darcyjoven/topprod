# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: acst201.4gl
# Descriptions...: 模擬版本移轉作業
# Date & Author..: 92/01/15 By MAY
# Modify.........: 92/03/26 By Pin
# Release 4.0....: 92/07/24 By Jones
# search % to modify
# Modify.........: No.FUN-660089 06/06/16 By cheunl cl_err --> cl_err3
# Modify.........: No.FUN-680071 06/09/08 By chen 類型轉換
# Modify.........: No.FUN-6A0064 06/10/27 By king l_time轉g_time
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    csc01_tmp LIKE csc_file.csc01,  #暫存值
    src_csc   RECORD LIKE csc_file.*,  # 來源
    des_csc   RECORD LIKE csc_file.*,  # 目地
    tm        RECORD
              csc01            LIKE csc_file.csc01,
              csc01_2          LIKE csc_file.csc01
               END RECORD,
     g_wc                string,  #No.FUN-580092 HCN
    g_cmd               LIKE type_file.chr1000, #No.FUN-680071 VARCHAR(60)
    l_sql               LIKE type_file.chr1000 #No.FUN-680071 VARCHAR(100)
 
DEFINE   g_msg           LIKE type_file.chr1000 #No.FUN-680071 VARCHAR(72)
MAIN
#     DEFINE   l_time LIKE type_file.chr8            #No.FUN-6A0064
   DEFINE p_row,p_col	LIKE type_file.num5    #No.FUN-680071 SMALLINT
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ACS")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0064
    LET p_row = 3 LET p_col = 2
    OPEN WINDOW acst201_w AT p_row,p_col
      WITH FORM "acs/42f/acst201"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
 
   CALL cl_getmsg('mfg1016',0) RETURNING g_msg
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      MESSAGE g_msg
   ELSE
      DISPLAY g_msg AT 1,1
   END IF
    WHILE TRUE
    LET tm.csc01 = NULL
    LET tm.csc01_2 = NULL
    INITIALIZE des_csc.* TO NULL
    INITIALIZE src_csc.* TO NULL
    CALL csc01()
    CALL csc01_2()
    LET csc01_tmp =NULL
    LET tm.csc01 = NULL
    LET tm.csc01_2 = NULL
    INPUT BY NAME tm.csc01,tm.csc01_2
             WITHOUT DEFAULTS
   ON ACTION locale
    CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
 
          AFTER FIELD csc01
              IF tm.csc01 IS NOT NULL THEN
                 SELECT * INTO src_csc.* FROM csc_file WHERE csc01 = tm.csc01
                 IF SQLCA.sqlcode THEN
#                   CALL cl_err(tm.csc01,'mfg6001',0)   #No.FUN-660089
                    CALL cl_err3("sel","csc_file",tm.csc01,"","mfg6001","","",1)  #No.FUN-660089
                    INITIALIZE src_csc.* TO NULL
                    NEXT FIELD csc01
                  ELSE CALL csc01()
                 END IF
	      END IF
 
          AFTER FIELD csc01_2
              IF tm.csc01_2 IS NOT NULL THEN
                 IF tm.csc01 = tm.csc01_2 THEN
                    CALL cl_err('','mfg6002',0)
                    NEXT FIELD csc01
                 END IF
                 SELECT * INTO des_csc.* FROM csc_file WHERE csc01 = tm.csc01_2
                 IF SQLCA.sqlcode THEN
#                   CALL cl_err(tm.csc01_2,'mfg6001',0)   #No.FUN-660089
                    CALL cl_err3("sel","csc_file",tm.csc01_2,"","mfg6001","","",1)  #No.FUN-660089
                    INITIALIZE des_csc.* TO NULL
                    NEXT FIELD csc01_2
                 ELSE CALL csc01_2()
                 END IF
              END IF
 
              CALL csc01_u()   #更新csc_file
 
#        ON ACTION CONTROLP
#           LET g_cmd = "acsr302",
#                  " '",g_today CLIPPED,"' ''",
#                  " '0' 'Y' '4' '1'",
#                  " ' 1=1' ","'0'"
#           CALL cl_cmdrun(g_cmd CLIPPED)
 
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
    IF INT_FLAG THEN EXIT WHILE END IF
   END WHILE
    CLOSE WINDOW acst201_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0064
END MAIN
 
FUNCTION csc01()
DEFINE   l_gen02   LIKE gen_file.gen02
    LET l_gen02 = NULL
    DISPLAY BY NAME
        src_csc.csc02,src_csc.csc03,src_csc.csc04,src_csc.csc05,
        src_csc.csc06,src_csc.csc07,src_csc.csc08,src_csc.csc09,
        src_csc.csc10,src_csc.csc11,src_csc.csc12,src_csc.csc13,
        src_csc.csc16
    SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = src_csc.csc04
    IF SQLCA.sqlcode THEN LET l_gen02 = NULL END IF
    DISPLAY l_gen02 TO FORMONLY.d01
END FUNCTION
 
FUNCTION csc01_2()
DEFINE   l_gen02   LIKE gen_file.gen02
    LET l_gen02 = NULL
    SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = des_csc.csc04
    IF SQLCA.sqlcode THEN LET l_gen02 = NULL END IF
    DISPLAY des_csc.csc02 TO FORMONLY.csc02_2
    DISPLAY des_csc.csc03 TO FORMONLY.csc03_2
    DISPLAY des_csc.csc04 TO FORMONLY.csc04_2
    DISPLAY l_gen02 TO FORMONLY.d02
    DISPLAY des_csc.csc05 TO FORMONLY.csc05_2
    DISPLAY des_csc.csc06 TO FORMONLY.csc06_2
    DISPLAY des_csc.csc07 TO FORMONLY.csc07_2
    DISPLAY des_csc.csc08 TO FORMONLY.csc08_2
    DISPLAY des_csc.csc09 TO FORMONLY.csc09_2
    DISPLAY des_csc.csc10 TO FORMONLY.csc10_2
    DISPLAY des_csc.csc11 TO FORMONLY.csc11_2
    DISPLAY des_csc.csc12 TO FORMONLY.csc12_2
    DISPLAY des_csc.csc13 TO FORMONLY.csc13_2
    DISPLAY des_csc.csc16 TO FORMONLY.csc16_2
END FUNCTION
 
#作法: 將模擬版本互換置des_csc.*,src_csc.*後將原來檔案中資料刪除後在依
#      des_csc.*,src_csc.* INSERT 入檔案
FUNCTION csc01_u()
   IF cl_sure(18,18) THEN
    LET csc01_tmp     = des_csc.csc01 #先將目的放置暫存變數
    LET des_csc.csc01 = src_csc.csc01 #來源放置目的
    LET src_csc.csc01 = csc01_tmp     #目的
let g_success='Y'
begin work
    DELETE FROM csc_file WHERE csc01 = tm.csc01
    DELETE FROM csc_file WHERE csc01 = tm.csc01_2
    INSERT INTO csc_file VALUES(des_csc.*)
    INSERT INTO csc_file VALUES(src_csc.*)
    CALL csc01_u1()  #更新csa_file
    CALL csc01_u2()  #更新csb_file
 
		IF g_success='Y' THEN
			CALL cl_cmmsg(1) COMMIT WORK
		ELSE
			CALL cl_rbmsg(1) ROLLBACK WORK
		END IF
   END IF
END FUNCTION
 
#UPDATE csa_file, csb_file
#作法: 將SOURCE的模擬版本改成'X'，在將目地的模擬版本改成SOURCE的版本
FUNCTION csc01_u1()
DEFINE  l_sql1       LIKE type_file.chr1000, #No.FUN-680071 VARCHAR(100)
        l_sql2       LIKE type_file.chr1000, #No.FUN-680071 VARCHAR(100)
        l_sql3       LIKE type_file.chr1000 #No.FUN-680071 VARCHAR(100)
 
    LET l_sql1 = " UPDATE csa_file SET csa02 = 'X'",
                 " WHERE csa02 = '",src_csc.csc01,
		         "'  AND csa03 = '",src_csc.csc02,"'"
    PREPARE t201_pre1  FROM l_sql1
    EXECUTE t201_pre1
	if STATUS  THEN LET g_success='N' END IF
 
    LET l_sql2 = " UPDATE csa_file SET csa02 ='",src_csc.csc01,"'",
                 " WHERE csa02 = '",des_csc.csc01,
				 "'  AND csa03 = '",des_csc.csc02,"'"
    PREPARE t201_pre2  FROM l_sql2
    EXECUTE t201_pre2
	if STATUS  THEN LET g_success='N' END IF
 
    LET l_sql3 = " UPDATE csa_file SET csa02 = '",des_csc.csc01,"'",
                 " WHERE csa02 = 'X'"
    PREPARE t201_pre3  FROM l_sql3
    EXECUTE t201_pre3
	if STATUS  THEN LET g_success='N' END IF
	FREE t201_pre1
	FREE t201_pre2
	FREE t201_pre3
END FUNCTION
 
FUNCTION csc01_u2()
DEFINE   l_sql4   LIKE type_file.chr1000, #No.FUN-680071 VARCHAR(100)
         l_sql5   LIKE type_file.chr1000, #No.FUN-680071 VARCHAR(100)
         l_sql6   LIKE type_file.chr1000 #No.FUN-680071 VARCHAR(100)
 
    LET l_sql4 = " UPDATE csb_file SET csb02 = 'X'",
             " WHERE csb02 = '",src_csc.csc01,
			 "'  AND csb03 = '",src_csc.csc02,"'"
    PREPARE t201_pre4 FROM l_sql4
    EXECUTE t201_pre4
	IF SQLCA.SQLCODE THEN LET g_success='N' END IF
 
    LET l_sql5 = " UPDATE csb_file SET csb02='",src_csc.csc01,"'",
             " WHERE csb02 = '",des_csc.csc01,
			 "'  AND csb03 = '",des_csc.csc02,"'"
    PREPARE t201_pre5 FROM l_sql5
    EXECUTE t201_pre5
    IF SQLCA.SQLCODE THEN LET g_success='N' END IF
 
    LET l_sql6 = " UPDATE csb_file SET csb02='",des_csc.csc01,"'",
             " WHERE csb02 = 'X'"
    PREPARE t201_pre6 FROM l_sql6
    EXECUTE t201_pre6
	IF SQLCA.SQLCODE THEN LET g_success='N' END IF
END FUNCTION
#Patch....NO.TQC-610035 <001> #
