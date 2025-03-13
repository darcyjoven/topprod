# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: anmp830.4gl
# Descriptions...: 每月利息收入暫估作業
# Date & Author..: 96/11/25 By paul
# Modify.........: No.FUN-570127 06/03/08 By yiting 批次背景執行
# Modify.........: No.MOD-640499 06/04/18 By Smapmin 按照QBE條件刪除gxh_file
# Modify.........: No.FUN-660148 06/06/21 By Hellen cl_err --> cl_err3
# Modify.........: No.MOD-670052 06/07/17 By Smapmin 若計息方式為月付,則起算日期為下個月的原存日
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.FUN-710024 07/01/17 By Jackho 增加批處理錯誤統整功能
# Modify.........: No.MOD-780065 07/08/09 By Smapmin mark重複程式段
# Modify.........: No.TQC-830031 08/04/03 By Carol lc_cmd 型態改為type_file.chr1000
# Modify.........: No.FUN-980005 09/08/12 By TSD.Martin GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-9A0021 09/10/16 By Lilan 將程式段多餘的DISPLAY給MARK
# Modify.........: No:MOD-A40117 10/04/20 By sabrina p830_gxf()取l_begin和l_end改用s_azn01方式
# Modify.........: No:CHI-A10014 10/10/19 By sabrina 若aza26='0'且幣別=aza17時，利息以365天計算，其餘則用360天計算
# Modify.........: No:MOD-B30585 11/03/16 By Dido 起算日計算邏輯調整 
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   未加離開前得cl_used(2) 
# Modify.........: No:FUN-B40056 11/05/13 By lixia 刪除資料時一併刪除tic_file的資料
# Modify.........: No:MOD-B70190 11/07/21 By Polly 調整拋轉時，起算日期和匯率會是空值
# Modify.........: No:MOD-C20068 12/02/10 By Polly 調整日期給值的格式
# Modify.........: No:CHI-B30085 12/03/15 By Polly 暫估起始日應多考慮gxi03來推算
# Modify.........: No:MOD-C40124 12/04/18 By Elise 當定存單為外幣時，anmp830會帶入每日匯率賣出的匯率，應改抓每日匯率買入的匯率

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
       g_gxf         RECORD LIKE gxf_file.*,
       g_sql         STRING,                 #No.FUN-580092 HCN   
       g_yy,g_mm     LIKE type_file.num5,    #No.FUN-680107 SMALLINT
       g_date        LIKE type_file.dat,     #No.FUN-680107 DATE
       g_dbs_gl	     LIKE type_file.chr21,   #No.FUN-680107 VARCHAR(21)
       g_wc,g_buf    string,                 #No.FUN-580092 HCN
       g_start,g_end LIKE gxh_file.gxh011
DEFINE g_cnt         LIKE type_file.num10    #No.FUN-680107 INTEGER
DEFINE g_flag        LIKE type_file.chr1     #No.FUN-680107 VARCHAR(1)
DEFINE ls_date       STRING,                 #No.FUN-570127
       g_change_lang LIKE type_file.chr1     #No.FUN-680107 VARCHAR(1) #No.FUN-570127
 
MAIN
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   #No.FUN-570127 --start
    INITIALIZE g_bgjob_msgfile TO NULL
    LET g_wc    = ARG_VAL(1)                         #QBE條件
    LET ls_date = ARG_VAL(2)                         #匯率日期
    LET g_date  = cl_batch_bg_date_convert(ls_date)
    LET g_yy    = ARG_VAL(3)                           #利息年
    LET g_mm    = ARG_VAL(4)                           #利息月
    LET g_bgjob = ARG_VAL(5)
    IF cl_null(g_bgjob) THEN
       LET g_bgjob = 'N'
    END IF
   #No.FUN-570127 --end--
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time

WHILE TRUE
     IF g_bgjob = "N" THEN
        CALL p830()
        CALL p830_ask()         # Ask for data range
        LET g_success= 'Y'
        BEGIN WORK
        IF cl_sure(10,10) THEN
           CALL p830_gxf()
           CALL s_showmsg()          #No.FUN-710024
           IF g_success = 'Y' THEN
              COMMIT WORK
              CALL cl_end2(1) RETURNING g_flag        #批次作業正確結束
           ELSE
              ROLLBACK WORK
              CALL cl_end2(2) RETURNING g_flag        #批次作業失敗
           END IF
           IF g_flag THEN
              CONTINUE WHILE
           ELSE
              CLOSE WINDOW p830
              EXIT WHILE
           END IF
        ELSE
           CONTINUE WHILE
        END IF
     ELSE
        LET g_success = 'Y'
        BEGIN WORK
        CALL p830()
        CALL p830_gxf()
        CALL s_showmsg()          #No.FUN-710024
        IF g_success = "Y" THEN
           COMMIT WORK
        ELSE
           ROLLBACK WORK
        END IF
        CALL cl_batch_bg_javamail(g_success)
        EXIT WHILE
     END IF
   END WHILE
 
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION p830()
# 得出總帳 database name
# g_nmz.nmz02p -> g_plant_new -> s_getdbs() -> g_dbs_new --> g_dbs_gl
   LET g_plant_new = g_nmz.nmz02p  #總帳管理系統所在工廠編號
   CALL s_getdbs()
   LET g_dbs_gl=g_dbs_new
END FUNCTION
 
FUNCTION p830_ask()
   DEFINE l_no       LIKE type_file.chr1000    ,  #No.FUN-680107 VARCHAR(100)
          l_i,l_j    LIKE type_file.num5          #No.FUN-680107 SMALLINT
#NO.FUN-570127 start--
   DEFINE lc_cmd        LIKE type_file.chr1000 #TQC-830031-modify #No.FUN-680107 VARCHAR(500) #No.FUN-570127
 
   OPEN WINDOW p830 WITH FORM "anm/42f/anmp830"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   CALL cl_ui_init()
 
   LET g_yy=YEAR(TODAY)
   LET g_mm=MONTH(TODAY)
   LET g_date=TODAY
   LET g_bgjob = 'N'
   WHILE TRUE
#NO.FUN-570127 end--
 
      CONSTRUCT BY NAME g_wc ON gxf01,gxf011,gxf02
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
        ON ACTION locale                    #genero
#           LET g_action_choice = "locale"           #NO.FUN-570127 mark
#          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
           LET g_change_lang = TRUE                  #NO.FUN-570127 
           EXIT CONSTRUCT
 
         ON ACTION exit              #加離開功能genero
            LET INT_FLAG = 1
            EXIT CONSTRUCT
 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
      END CONSTRUCT
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond('gxfuser', 'gxfgrup') #FUN-980030
 
#NO.FUN-570127 start--
#      IF g_action_choice = "locale" THEN  #genero
#         LET g_action_choice = ""
#         CALL cl_dynamic_locale()
#         LET g_flag = 'N'
#         RETURN
#      END IF
 
#      IF INT_FLAG THEN
#         RETURN
#      END IF
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLOSE WINDOW p830
        CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
        EXIT PROGRAM
     END IF
#NO.FUN-570127 end---
 
      #INPUT g_date,g_yy,g_mm WITHOUT DEFAULTS FROM bdate,yy,mm
      INPUT g_date,g_yy,g_mm,g_bgjob WITHOUT DEFAULTS FROM bdate,yy,mm,g_bgjob   #NO.FUN-570127
 
         AFTER FIELD mm
           IF NOT cl_null(g_mm) THEN
              IF g_mm > 12 OR g_mm <= 0 THEN
                 NEXT FIELD mm
              END IF
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
 
 
         ON ACTION exit  #加離開功能genero
            LET INT_FLAG = 1
            EXIT INPUT
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
        #-->No.FUN-570127 --start--
         ON ACTION locale
            LET g_change_lang = TRUE
            EXIT INPUT
        #---No.FUN-570127 --end----------
 
      END INPUT
 
#NO.FUN-570127 start--
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p830
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = "Y" THEN
         LET lc_cmd = NULL
         SELECT zz08 INTO lc_cmd FROM zz_file
          WHERE zz01 = "anmp830"
         IF SQLCA.sqlcode OR cl_null(lc_cmd) THEN
             CALL cl_err('anmp830','9031',1)   
         ELSE
            LET g_wc = cl_replace_str(g_wc,"'", "\"")
            LET lc_cmd = lc_cmd CLIPPED,
                         " '",g_wc CLIPPED,"'",
                         " '",g_date CLIPPED,"'",
                         " '",g_yy CLIPPED,"'",
                         " '",g_mm CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'"
            CALL cl_cmdat('anmp830',g_time,lc_cmd CLIPPED)
         END IF
         CLOSE WINDOW p830
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM
      END IF
      EXIT WHILE
   END WHILE
   #---No.FUN-570127 --end--------------------------------------------------
END FUNCTION
 
FUNCTION p830_gxf()
   DEFINE l_gxf		 RECORD LIKE gxf_file.*,
          l_gxh		 RECORD LIKE gxh_file.*,
          l_gxh13        LIKE gxh_file.gxh13,
          l_nnn03        LIKE nnn_file.nnn03,
          l_nnl12        LIKE nnl_file.nnl12,
          l_str		 LIKE aaf_file.aaf03,    #No.FUN-680107 VARCHAR(40)
          l_begin,l_end	 LIKE type_file.dat,     #No.FUN-680107 DATE
          l_yy,t_yy	 LIKE type_file.num5,    #No.FUN-680107 SMALLINT
          l_mm,l_dd,j	 LIKE type_file.num5,    #No.FUN-680107 SMALLINT
          l_ins	         LIKE type_file.chr1,    #No.FUN-680107 VARCHAR(1)
          l_sql          STRING,                 #MOD-640499 
          l_npp01        LIKE npp_file.npp01     #MOD-640499
   DEFINE l_x            LIKE type_file.chr8     #No.FUN-680107 VARCHAR(8) #MOD-670052
   DEFINE p_edate        LIKE type_file.dat      #No.FUN-680107 DATE #MOD-670052
   DEFINE l_gxi03        LIKE gxi_file.gxi03     #CHI-B30085 add
   DEFINE l_cnt          LIKE type_file.num5     #CHI-B30085 add
   DEFINE l_y            LIKE type_file.chr8     #CHI-B30085 add 
 
#   BEGIN WORK  #NO.FUN-570127 MARK
 
  #MOD-A40117---mark---start---
  #LET l_begin = MDY(g_mm,1,g_yy)   # 以g_yy g_mm 之年月,找出來該月之第一天
  #LET l_mm = g_mm + 1              # 及最後一天之日期,
  #LET l_yy = g_yy                  # 下月第一天減一,即為該月之月底日期
  #IF  l_mm = 13 THEN               # ex:8611 則l_begin = 861101
  #    LET l_mm = 1                 #           l_end =   861130
  #    LET l_yy = l_yy + 1          # 在 g_sql 中檢查,確保8611 落在起訖範圍內
  #END IF                           # 若年月拆開個自檢查,在g_sql中會有bug
  #LET l_end = MDY(l_mm,1,l_yy)
  #LET l_end = l_end - 1
   CALL s_azn01(g_yy,g_mm) RETURNING l_begin,l_end
  #MOD-A40117---mark---end---
 
   LET g_sql   ="SELECT * ",
                " FROM gxf_file  ",
                " WHERE ",g_wc CLIPPED,
                "   AND gxf03 <= '",l_end,"'",
                "   AND gxf05 >= '",l_begin,"'",
                "   AND gxf11!=3 AND gxf11!=4 ",
                "   AND gxfconf='Y' "
 
   PREPARE p830_gxf_p  FROM g_sql
   IF STATUS THEN
      CALL cl_err('prepare p830_gxf_p',STATUS,1)
      LET g_success = 'N'
      RETURN
   END IF
 
   DECLARE p830_gxf_c  CURSOR WITH HOLD FOR p830_gxf_p
   IF STATUS THEN
      CALL cl_err('declare p830_gxf_c',STATUS,1)
      LET g_success = 'N'
      RETURN
   END IF
 
   LET g_success = 'Y'
 
   WHILE TRUE
      IF g_bgjob ='N'THEN     #No.FUN-570127
          OPEN WINDOW p830_gxf_w WITH 5 rows, 30 COLUMNS
          CALL cl_getmsg('anm-999',g_lang) RETURNING l_str
      END IF
 
      LET g_cnt=0
      CALL s_showmsg_init()   #No.FUN-710024
      FOREACH p830_gxf_c  INTO l_gxf.*
         INITIALIZE l_gxh.* TO NULL
         LET g_cnt = g_cnt + 1
         SELECT * INTO l_gxh.* FROM gxh_file
	  WHERE gxh011 = l_gxf.gxf011
            AND gxh02 = g_yy
            AND gxh03 = g_mm
         IF STATUS=0 THEN
            IF l_gxh.gxhglno IS NOT NULL THEN CONTINUE FOREACH END IF
            IF l_gxh.gxh13   IS NOT NULL THEN CONTINUE FOREACH END IF
            DELETE FROM gxh_file
             WHERE gxh011= l_gxf.gxf011
               AND gxh02 = g_yy
               AND gxh03 = g_mm
               AND gxh15 = 'N'
            #-----MOD-640499---------
            IF SQLCA.sqlerrd[3] = 1 THEN
               LET l_npp01 = l_gxf.gxf011,g_yy USING '&&&&',g_mm USING '&#'
               DELETE FROM npp_file WHERE nppsys = 'NM' AND npp01 = l_npp01
                                      AND npp00 = '24' AND npp011 = '1'
               DELETE FROM npq_file WHERE npqsys = 'NM' AND npq01 = l_npp01
                                      AND npq00 = '24' AND npq011 = '1'
               DELETE FROM tic_file WHERE tic04 = l_npp01         #FUN-B40056
            ELSE
               CONTINUE FOREACH
            END IF
            #-----END MOD-640499-----
 
         END IF
 
         LET l_gxh.gxh011 = l_gxf.gxf011
         LET l_gxh.gxh01 = l_gxf.gxf01
         LET l_gxh.gxh02 = g_yy
         LET l_gxh.gxh03 = g_mm
         LET l_gxh.gxh04 = l_gxf.gxf04
         LET l_gxh.gxhuser = g_user
         LET l_gxh.gxhgrup = g_grup
         LET l_gxh.gxhdate = g_today
         #-----MOD-670052---------
         IF l_gxf.gxf04 = '1' THEN
           #-MOD-B30585-add-
            LET l_yy = YEAR(l_gxf.gxf03)
            LET l_mm = MONTH(l_gxf.gxf03)
           #-MOD-B30585-end-
            LET l_x = l_gxf.gxf03 USING 'yyyymmdd'
            LET l_x[1,4] = g_yy
           #LET l_x[5,6] = g_mm                                    #MOD-C20068 mark
            LET l_x[5,6] = g_mm USING '##'                         #MOD-C20068 add
           #LET l_gxh.gxh05 = MDY(l_x[5,6],l_x[7,8],l_x[1,4])      #MOD-B30585 mark
           #IF cl_null(l_gxh.gxh05) THEN                           #MOD-B30585 mark
            IF cl_null(l_gxh.gxh05) AND l_yy=l_gxh.gxh02 AND l_mm = l_gxh.gxh03 THEN   #No.MOD-B70190 add
               LET l_gxh.gxh05 = l_gxf.gxf03                                           #No.MOD-B70190 add
            END IF                                                                     #No.MOD-B70190 add
           #IF (g_yy = l_yy AND g_mm <> l_mm OR g_yy <> l_yy) THEN    #MOD-B30585 #CHI-B30085 mark
            IF ((g_yy = l_yy AND g_mm <> l_mm) OR g_yy <> l_yy) THEN  #CHI-B30085 add
           #------------------------------CHI-B30085-------------------start
               LET l_cnt = 0
               SELECT COUNT(*) INTO l_cnt FROM gxi_file,gxj_file
                WHERE gxj031 = l_gxh.gxh011
                  AND gxj01 = gxi01
                  AND gxi03_y = g_yy
                  AND gxi03_m = g_mm
                  AND gxiconf <> 'X'
               IF l_cnt > 0 THEN
                  SELECT gxi03 INTO l_gxi03 FROM gxi_file,gxj_file
                   WHERE gxj031 = l_gxh.gxh011
                     AND gxj01 = gxi01
                     AND gxi03_y = g_yy
                     AND gxi03_m = g_mm
                     AND gxiconf <> 'X'
                  LET l_y = l_gxi03 USING 'yyyymmdd'
                  LET l_gxh.gxh05 = MDY(l_y[5,6],l_y[7,8]+1,l_y[1,4])
               ELSE
           #------------------------------CHI-B30085-------------------start
                  LET l_gxh.gxh05 = MDY(l_x[5,6],1,l_x[1,4])
                 #CALL s_last(l_gxh.gxh05) RETURNING p_edate          #MOD-B30585 mark
                 #LET l_x[7,8] = DAY(p_edate) USING '&&'              #MOD-B30585 mark
                 #LET l_gxh.gxh05 = MDY(l_x[5,6],l_x[7,8],l_x[1,4])   #MOD-B30585 mark
               END IF                                                 #CHI-B30085 add
            END IF
         ELSE
         #-----END MOD-670052-----
            IF g_yy= YEAR(l_gxf.gxf03) AND g_mm=MONTH(l_gxf.gxf03) THEN
               LET l_gxh.gxh05 = l_gxf.gxf03
            ELSE
               LET l_gxh.gxh05 = l_begin
            END IF
         END IF   #MOD-670052
 
         IF g_yy=YEAR(l_gxf.gxf05) AND g_mm=MONTH(l_gxf.gxf05) THEN
            LET l_gxh.gxh06 = l_gxf.gxf05
         ELSE
            LET l_gxh.gxh06 = l_end
         END IF
 
       # LET l_gxh.gxh07 = l_gxh.gxh06 - l_gxh.gxh05    #NO:4639
       # Jason 020122
         #-----MOD-670052---------
         #IF g_yy= YEAR(l_gxf.gxf03) AND g_mm=MONTH(l_gxf.gxf03) THEN
         #   LET l_gxh.gxh07 = l_gxh.gxh06 - l_gxh.gxh05
         #ELSE
            LET l_gxh.gxh07 = l_gxh.gxh06 - l_gxh.gxh05+1
         #END IF
         #-----END MOD-670052-----
        #IF l_gxf.gxf24 <> g_aza.aza17 THEN     #外幣                          #CHI-A10014 mark
         IF g_aza.aza26 <> '0' OR l_gxf.gxf24 <> g_aza.aza17 THEN     #外幣    #CHI-A10014 add
            LET l_gxh.gxh11 = (l_gxf.gxf021*l_gxf.gxf06/100)/360*l_gxh.gxh07
         ELSE
            LET l_gxh.gxh11 = (l_gxf.gxf021*l_gxf.gxf06/100)/365*l_gxh.gxh07
         END IF
       #---------END
         #LET l_gxh.gxh11 = (l_gxf.gxf021*l_gxf.gxf06/100)/365*l_gxh.gxh07   #MOD-780065
         LET l_gxh.gxh08 = l_gxf.gxf06
         LET l_gxh.gxh09 = l_gxf.gxf24
         LET l_gxh.gxh10=l_gxf.gxf25            #No.MOD-B70190 add
         IF l_gxh.gxh10 != '1'   THEN           #No.MOD-B70190 add
           #-----------   99/05/07 NO:0086     -----------------------#
           #CALL s_curr3(l_gxh.gxh09,g_date,'S') RETURNING l_gxh.gxh10  #MOD-C40124 mark
            CALL s_curr3(l_gxh.gxh09,g_date,'B') RETURNING l_gxh.gxh10  #MOD-C40124
           #---------
         END IF                                 #No.MOD-B70190 add
         SELECT azi03,azi04 INTO t_azi03,t_azi04 FROM azi_file
          WHERE azi01=l_gxh.gxh09
         CALL cl_digcut(l_gxh.gxh11,t_azi04) RETURNING l_gxh.gxh11
         LET l_gxh.gxh12 = l_gxh.gxh11 * l_gxh.gxh10
         #no.A010 依幣別取位
         CALL cl_digcut(l_gxh.gxh12,g_azi04) RETURNING l_gxh.gxh12
         #(end)
         LET l_gxh.gxh14 = l_gxf.gxf02
         LET l_gxh.gxh15 = 'N'    #MOD-640499
 
         #FUN-980005  add legal 
         LET l_gxh.gxhlegal = g_legal
         #FUN-980005  end legal 
 
         LET l_gxh.gxhoriu = g_user      #No.FUN-980030 10/01/04
         LET l_gxh.gxhorig = g_grup      #No.FUN-980030 10/01/04
         INSERT INTO gxh_file VALUES (l_gxh.*)
         IF SQLCA.SQLCODE THEN
#           CALL cl_err("ins gxh ",SQLCA.SQLCODE,1)    #No.FUN-660148
#No.FUN-710024--begin
#            CALL cl_err3("ins","gxh_file",l_gxh.gxh011,l_gxh.gxh02,SQLCA.sqlcode,"","ins gxh ",1) #No.FUN-660148
            LET g_showmsg=l_gxh.gxh011,"/",l_gxh.gxh02,"/",l_gxh.gxh03  
            CALL s_errmsg('gxh011,gxh02,gxh03',g_showmsg,"ins gxh ",SQLCA.SQLCODE,1)
#No.FUN-710024--end
            LET g_success = 'N'
         END IF
         IF g_cnt = 1 THEN LET g_start = l_gxh.gxh011 END IF
      END FOREACH
      IF SQLCA.sqlcode THEN
#No.FUN-710024--begin
#         CALL cl_err('Foreach gxf error !',SQLCA.sqlcode,1)
         CALL s_errmsg('','','Foreach gxf error !',SQLCA.sqlcode,1) 
#No.FUN-710024--end
         LET g_success = 'N'
      END IF
      IF g_cnt = 0 THEN
#No.FUN-710024--begin
#         CALL cl_err('','aap-129',1)
         CALL s_errmsg('','','','aap-129',1) 
#No.FUN-710024--end
         LET g_success = 'N'
      END IF
 
      LET g_end = l_gxh.gxh011
      IF g_bgjob ='N'THEN     #No.FUN-570127
          MESSAGE 'gxh011 from ',g_start, ' to ',g_end
          CALL ui.Interface.refresh()
      END IF
      CLOSE WINDOW p830_gxf_w
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
#Patch....NO.TQC-610036 <001> #
