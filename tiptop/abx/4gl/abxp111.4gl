# Prog. Version..: '5.30.06-13.04.16(00008)'     #
#
# Pattern name...: abxp111.4gl
# Descriptions...: 保稅BOM整批產生作業
# LIKE type_file.dat & Author..: 06/11/03 By kim
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-990251 09/09/28 By mike 在ima08!='Z'的sql语法中,再加上ima15='Y'     
# Modify.........: No:MOD-9C0160 09/12/17 By Smapmin 將轉換率的檢核拿掉
# Modify.........: No:MOD-A90140 10/09/21 By Summer 元件也應卡只能是保稅料件(ima15='Y') 
# Modify.........: No.FUN-B30211 11/03/31 By yangtingting   1、離開MAIN時沒有cl_used(1)和cl_used(2)
#                                                            2、未加離開前得cl_used(2)
# Modify.........: No:MOD-BB0037 11/11/12 By johung 主件及元件不控卡只能是保稅料件
#                                                   新增主件時若已有BOM資料存在，修改舊版本BOM失效日期為新增日期
# Modify.........: No:MOD-C30359 12/03/12 By fengrui 新錄入的生效日期應該大於之前BOM的生效日期并大於等於失效日期
# Modify.........: No:CHI-B10023 13/04/16 By jt_chen 需考慮abmi600發料單位與庫存單位不同時要做單位轉換

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD				    # Print condition RECORD
        		wc  	STRING,                 # Where condition
           		bnd04   LIKE bnd_file.bnd04,    # 核准文號
           		bnd02   LIKE bnd_file.bnd02,    # BOM有效日
              x       LIKE type_file.num5     # 階數
              END RECORD,
          g_tot         LIKE type_file.num10,
          g_bma01_a     LIKE bma_file.bma01
 
DEFINE   g_bnd04        LIKE bnd_file.bnd04
DEFINE   g_cnt          LIKE type_file.num10
DEFINE   g_i            LIKE type_file.num5   # count/index for any purpose
DEFINE   g_edate        LIKE type_file.dat
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT	        			# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ABX")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time      #FUN-B30211 
   LET tm.wc    = ARG_VAL(1)
   LET tm.bnd04 = ARG_VAL(2)
   LET tm.bnd02 = ARG_VAL(3)
   LET tm.x     = ARG_VAL(4)
   IF cl_null(tm.wc) 
      THEN CALL p111_tm(0,0)			# Input print condition
      ELSE CALL abxp111()		        # Read bmata and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
END MAIN
 
FUNCTION p111_tm(p_row,p_col)
   DEFINE p_row,p_col	LIKE type_file.num5,
          l_flag        LIKE type_file.num5,
          l_one         LIKE type_file.chr1,            # 資料筆數
          l_bdate       LIKE bmx_file.bmx07,
          l_edate       LIKE bmx_file.bmx08,
          l_bma01       LIKE bma_file.bma01,	# 工程變異之生效日期
          l_cmd		STRING
   DEFINE l_bni         RECORD LIKE bni_file.*
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 6 END IF
 
   OPEN WINDOW p111_w AT p_row,p_col WITH FORM "abx/42f/abxp111" 
      ATTRIBUTE (STYLE = g_win_style)
    
   CALL cl_ui_init()
   CALL cl_opmsg('p')
   
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.bnd02 = g_today                       # BOM有效日
   LET tm.x     = 99                            # 階數(預設)
   SELECT * INTO l_bni.* FROM bni_file
   IF STATUS THEN
      LET g_bnd04 = ''
   ELSE
      LET g_bnd04 = l_bni.bni01 CLIPPED,
                    l_bni.bni02 CLIPPED,
                    l_bni.bni03 CLIPPED
   END IF
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON bma01,ima06
 
         ON ACTION about    
            CALL cl_about()  
 
         ON ACTION help       
            CALL cl_show_help()
 
         ON ACTION controlg     
            CALL cl_cmdask()
 
         ON ACTION locale
            LET g_action_choice = "locale"
            EXIT CONSTRUCT
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
   
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT CONSTRUCT
      END CONSTRUCT
      LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('bmauser', 'bmagrup') #FUN-980030
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW p111_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM
      END IF
      IF tm.wc = " 1=1" THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF
      LET l_one='N'
      # 判斷所下的QBE條件，是否有BOM存在
      IF tm.wc != ' 1=1' THEN
         LET l_cmd="SELECT COUNT(DISTINCT bma01),bma01",
                   " FROM bma_file,ima_file", 
                   " WHERE bma01=ima01 AND ima08 != 'Z' ",
                  #"   AND ima15 = 'Y' ", #MOD-990251   #MOD-BB0037 mark
                   " AND ",tm.wc CLIPPED,
                   " GROUP BY bma01"
         PREPARE p111_cnt_p FROM l_cmd
         DECLARE p111_cnt CURSOR FOR p111_cnt_p
         IF SQLCA.sqlcode THEN 
            CALL cl_err('P0:',SQLCA.sqlcode,1) 
            CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
            EXIT PROGRAM 
         END IF
         OPEN p111_cnt
         FETCH p111_cnt INTO g_cnt,l_bma01
         IF SQLCA.sqlcode OR cl_null(g_cnt) OR g_cnt = 0 THEN
            CALL cl_err(g_cnt,'mfg2601',0)
            CONTINUE WHILE
         ELSE
            IF g_cnt = 1 THEN
               LET l_one='Y'
            END IF
         END IF
      END IF
 
      LET tm.bnd04 = g_bnd04
 
      DISPLAY BY NAME tm.bnd04,tm.bnd02,tm.x
 
      INPUT BY NAME tm.bnd04,tm.bnd02,tm.x WITHOUT DEFAULTS 
 
         AFTER FIELD bnd02
            IF cl_null(tm.bnd02) THEN
                LET tm.bnd02 = g_today
            END IF
 
         AFTER FIELD x
            IF NOT cl_null(tm.x) THEN
               IF tm.x < 1 THEN
                  CALL cl_err('tm.x','mfg1322',0)
                  NEXT FIELD x
               END IF
            END IF 
 
         AFTER INPUT
            IF INT_FLAG THEN EXIT INPUT END IF
           #LET g_edate = tm.bnd02 - 1 UNITS day   #MOD-BB0037 mark
            LET g_edate = tm.bnd02                 #MOD-BB0037
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION about
            CALL cl_about()
 
         ON ACTION help
            CALL cl_show_help()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()	# Command execution
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
   
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT
      END INPUT
      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW p111_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
      CALL abxp111()
      ERROR ""
 
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
         EXIT WHILE
      END IF
 
   END WHILE
   CLOSE WINDOW p111_w
END FUNCTION
 
FUNCTION abxp111()
   DEFINE l_name	      LIKE type_file.chr20,		# External(Disk) file name
          l_use_flag    LIKE type_file.chr2,
          l_ute_flag    LIKE type_file.chr2,
          l_sql 	      STRING,	                # RDSQL STATEMENT
          l_cmd 	      STRING,	                # RDSQL STATEMENT
          l_chr 	      STRING,		              # RDSQL STATEMENT
          l_flag	      LIKE type_file.chr1,
          l_cnt         LIKE type_file.num5,
          l_bma01       LIKE bma_file.bma01,    # 主件料件
          l_ima1916     LIKE ima_file.ima1916   # 主件料件
   DEFINE l_bnd         RECORD LIKE bnd_file.*
   DEFINE l_bnd2        RECORD LIKE bnd_file.*
 
  BEGIN WORK
  LET g_success = 'Y' 
 
  WHILE TRUE
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND bmauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同部門的資料
     #         LET tm.wc = tm.wc clipped," AND bmagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     LET l_sql = "SELECT DISTINCT bma01,ima1916 ",
                 " FROM bma_file, ima_file",
                 " WHERE ima01 = bma01",
                 " AND ima08 != 'Z' AND ",tm.wc CLIPPED,
                #"   AND ima15 = 'Y' ", #MOD-990251   #MOD-BB0037 mark
                 " ORDER BY bma01 "
     PREPARE p111_prepare1 FROM l_sql
     IF SQLCA.sqlcode THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        LET g_success = 'N'
        EXIT WHILE 
     END IF
     DECLARE p111_cs1 CURSOR WITH HOLD FOR p111_prepare1
 
     LET g_tot = 0
     LET l_flag = 'N'
     FOREACH p111_cs1 INTO l_bma01,l_ima1916
       IF SQLCA.sqlcode THEN
           CALL cl_err('F1:',SQLCA.sqlcode,1) 
           LET g_success = 'N'
           EXIT WHILE
       END IF
       SELECT * FROM bnd_file
           WHERE bnd01 = l_bma01
             AND bnd02 = tm.bnd02
       IF NOT STATUS THEN
           LET l_chr = l_bma01 CLIPPED,'-',tm.bnd02 CLIPPED
           CALL cl_err(l_chr,-239,1)
           LET g_success = 'N'
           EXIT WHILE
       END IF
 
       LET g_bma01_a = l_bma01
       # 展下階元件
       CALL p111_bom(0,l_bma01,1)
       IF g_success = 'N' THEN EXIT WHILE END IF
 

       #若有相同主件料號存在,且其失效日期並未輸入,則系統自動預設本筆資料的
       #生效日期減1為其失效日期
       DECLARE p111_a_curs SCROLL CURSOR FOR SELECT * FROM bnd_file
                                              WHERE bnd01 = l_bma01
                                              ORDER BY bnd02
       OPEN p111_a_curs
       IF NOT STATUS THEN
           FETCH LAST p111_a_curs INTO l_bnd.*
           IF cl_null(l_bnd.bnd03) AND NOT STATUS THEN
              IF l_bnd.bnd02 >= tm.bnd02 THEN          #MOD-C30359 add
                 LET g_success = 'N'                   #MOD-C30359 add
                 CALL  cl_err('','abx9133',1)          #MOD-C30359 add
                 EXIT WHILE                            #MOD-C30359 add 
              ELSE
                 UPDATE bnd_file SET bnd03 = g_edate
                    WHERE bnd01 = l_bnd.bnd01
                      AND bnd02 = l_bnd.bnd02
                 IF SQLCA.sqlcode THEN
                    CALL cl_err('upd bnd03',STATUS,1)
                    LET g_success = 'N'
                    EXIT WHILE
                 END IF 
                 UPDATE bne_file SET bne07 = g_edate
                    WHERE bne01 = l_bnd.bnd01
                      AND bne02 = l_bnd.bnd02
                      AND bne07 IS NULL
                 IF SQLCA.sqlcode THEN
                    CALL cl_err('upd bne07',STATUS,1)
                    LET g_success = 'N'
                    EXIT WHILE
                 END IF 
              END IF
           END IF
       ELSE
           IF l_bnd.bnd03>= tm.bnd02 THEN          #MOD-C30359 add
             LET g_success = 'N'                   #MOD-C30359 add
             CALL  cl_err('','abx9133',1)          #MOD-C30359 add
             EXIT WHILE                            #MOD-C30359 add 
          END IF
       END IF
       CLOSE p111_a_curs 
       
       #新增保稅BOM單頭資料
       INITIALIZE l_bnd2.* TO NULL
       LET l_bnd2.bnd01 = l_bma01
       LET l_bnd2.bnd02 = tm.bnd02
       LET l_bnd2.bnd03 = NULL
       LET l_bnd2.bnd04 = tm.bnd04
       LET l_bnd2.bnd101 = l_ima1916
       LET l_bnd2.bnd102 = 'N'
      
       INSERT INTO bnd_file
          VALUES(l_bnd2.*)
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
          CALL cl_err('ins bnd',STATUS,1)
          LET g_success = 'N'
          EXIT WHILE
       END IF
 
       LET l_flag = 'Y'
     END FOREACH
 
     EXIT WHILE
  END WHILE
 
  IF g_success = 'Y' AND l_flag = 'N' THEN
     CALL cl_err('','mfg2601',1)
     LET g_success = 'N'
  END IF
 
END FUNCTION
 
 
FUNCTION p111_bom(p_level,p_key,p_total)
   DEFINE p_level	LIKE type_file.num5,
          p_total       LIKE type_file.num20_6,
          l_total       LIKE type_file.num20_6,
          p_key		LIKE bma_file.bma01,  #主件料件編號
          l_ac,i	LIKE type_file.num5,
          arrno		LIKE type_file.num5,         #BUFFER SIZE (可存筆數)
          l_chr,l_cnt   LIKE type_file.chr1,
          l_fac         LIKE type_file.num20_6,
          sr DYNAMIC ARRAY OF RECORD      #每階存放資料
              bmb15 LIKE bmb_file.bmb15,          #元件耗用特性
              bmb16 LIKE bmb_file.bmb16,          #替代特性
              bmb03 LIKE bmb_file.bmb03,          #元件料號
              bmb23 LIKE bmb_file.bmb23,          #選中率  
              bmb02 LIKE bmb_file.bmb02,          #項次
              bmb06 LIKE bmb_file.bmb06,          #QPA
              bmb08 LIKE bmb_file.bmb08,          #損耗率%
              bmb10 LIKE bmb_file.bmb10,          #發料單位
              bmb10_fac LIKE bmb_file.bmb10_fac,   #CHI-B10023 add
              bmb18 LIKE bmb_file.bmb18,          #投料時距
              bmb09 LIKE bmb_file.bmb09,          #製程序號
              bmb04 LIKE bmb_file.bmb04,          #有效日期
              bmb05 LIKE bmb_file.bmb05,          #失效日期
              bmb14 LIKE bmb_file.bmb14,          #元件使用特性
              bmb17 LIKE bmb_file.bmb17,          #Feature
              bmb11 LIKE bmb_file.bmb11,          #工程圖號
              bmb13 LIKE bmb_file.bmb13,          #插件位置
              bma01 LIKE bma_file.bma01,
              ima55 LIKE ima_file.ima55           #生產單位
          END RECORD,
  	  l_tot,l_times  LIKE type_file.num5,
          l_cmd		 STRING
   DEFINE l_bne          RECORD LIKE bne_file.*
   DEFINE l_ima1916    LIKE ima_file.ima1916
  #DEFINE l_ima15      LIKE ima_file.ima15 #MOD-A90140 add   #MOD-BB0037 mark
 
   IF p_level > tm.x THEN
      CALL cl_err('','mfg2643',1) 
      LET g_success = 'N'
      RETURN
   END IF
   LET p_level = p_level + 1
   IF p_level = 1 THEN
      INITIALIZE sr[1].* TO NULL
      LET sr[1].bmb03 = p_key
   END IF
 
   LET arrno = 600
   WHILE TRUE
        LET l_cmd=
         "SELECT bmb15,bmb16,bmb03,bmb23,bmb02,(bmb06/bmb07),bmb08,bmb10,bmb10_fac,",   #CHI-B10023 add bmb10_fac,
            " bmb18,bmb09,bmb04,bmb05,bmb14,",
            " bmb17,bmb11,bmb13,bma01,'' ",
            " FROM bmb_file, OUTER bma_file",
            " WHERE bmb01='", p_key,"'", 
            " AND bmb_file.bmb03 = bma_file.bma01"
 
        #生效日及失效日的判斷
        IF NOT cl_null(tm.bnd02) THEN
            LET l_cmd=l_cmd CLIPPED, " AND (bmb04 <='",tm.bnd02,
            "' OR bmb04 IS NULL) AND (bmb05 >'",tm.bnd02,
            "' OR bmb05 IS NULL)"
        END IF
        #排列方式
        LET l_cmd=l_cmd CLIPPED, " ORDER BY bmb02"
 
        PREPARE p111_ppp FROM l_cmd
        IF SQLCA.sqlcode THEN
	    CALL cl_err('P1:',SQLCA.sqlcode,1) 
            LET g_success = 'N'
            RETURN
        END IF
        DECLARE p111_cur CURSOR FOR p111_ppp
 
        LET l_ac = 1
        FOREACH p111_cur INTO sr[l_ac].*	# 先將BOM單身存入BUFFER
            LET l_ac = l_ac + 1			# 但BUFFER不宜太大
            IF l_ac = arrno THEN EXIT FOREACH END IF
        END FOREACH
 
        FOR i = 1 TO l_ac-1			# 讀BUFFER傳給REPORT
            LET l_fac = 1
            SELECT ima55,ima1916 INTO sr[i].ima55,l_ima1916 FROM ima_file #MOD-A90140 mark            #MOD-BB0037 reamrk
           #SELECT ima55,ima1916,ima15 INTO sr[i].ima55,l_ima1916,l_ima15 FROM ima_file #MOD-A90140   #MOD-BB0037 mark
                WHERE ima01 = sr[i].bmb03
            IF STATUS THEN
                CALL cl_err('sel ima55',STATUS,1)
                LET g_success = 'N'
                RETURN
            END IF
           #MOD-BB0037 -- mark begin --
           ##MOD-A90140 add --start--
           #IF l_ima15 ='N' THEN
           #   CALL cl_err(sr[i].bmb03,'abx-009',1)
           #   CONTINUE FOR 
           #END IF
           ##MOD-A90140 add --end-- 
           #MOD-BB0037 -- mark end --
            #-----MOD-9C0160---------
            #IF sr[i].ima55 !=sr[i].bmb10 THEN
            #   CALL s_umfchk(sr[i].bmb03,sr[i].bmb10,sr[i].ima55)
            #                 RETURNING l_cnt,l_fac    #單位換算
            #   IF l_cnt = '1'  THEN #有問題
            #      CALL cl_err(sr[i].bmb03,'abm-731',1)
            #      LET g_success = 'N'
            #      RETURN
            #   END IF
            #END IF
            #-----END MOD-9C0160-----
           #與多階展開不同之處理在此:
           #尾階在展開時, 其展開之
           #若為主件(有BOM單頭)
            IF NOT cl_null(sr[i].bma01) AND p_level < tm.x THEN 
                CALL p111_bom(p_level,sr[i].bmb03,p_total*sr[i].bmb06*l_fac)
                IF g_success = 'N' THEN RETURN END IF
            ELSE
                INITIALIZE l_bne.* TO NULL
                LET l_bne.bne01 = g_bma01_a
                LET l_bne.bne02 = tm.bnd02
                SELECT MAX(bne03)+1 INTO l_bne.bne03 FROM bne_file
                    WHERE bne01 = g_bma01_a
                      AND bne02 = tm.bnd02
                IF cl_null(l_bne.bne03) THEN
                    LET l_bne.bne03 = 1
                END IF
 
                LET l_bne.bne05 = sr[i].bmb03
                LET l_bne.bne06 = tm.bnd02    
                LET l_bne.bne07 = NULL
                LET l_bne.bne09 = 'Y'
               #LET l_bne.bne10 = p_total * sr[i].bmb06                              #CHI-B10023 mark
                LET l_bne.bne10 = (p_total * sr[i].bmb06)*sr[i].bmb10_fac            #CHI-B10023 add 
                LET l_bne.bne11 = sr[i].bmb08/100*l_bne.bne10
                LET l_bne.bne08 = l_bne.bne10 + l_bne.bne11
 
                LET l_cnt = 0
                SELECT COUNT(*) INTO l_cnt FROM bne_file
                    WHERE bne01 = g_bma01_a
                      AND bne02 = tm.bnd02
                      AND bne05 = l_bne.bne05
                IF l_cnt = 0 THEN
                   INSERT INTO bne_file VALUES(l_bne.*)
                   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                      CALL cl_err('ins bne',STATUS,1)
                      LET g_success = 'N'
                      RETURN
                   END IF 
                ELSE
                   UPDATE bne_file
                       SET bne08 = bne08 + l_bne.bne08,
                           bne10=bne10+ l_bne.bne10,
                           bne11=bne11+ l_bne.bne11
                        WHERE bne01 = g_bma01_a
                          AND bne02 = tm.bnd02
                          AND bne05 = l_bne.bne05
                   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                      CALL cl_err('upd bne',STATUS,1)
                      LET g_success = 'N'
                      RETURN
                   END IF
                END IF 
            END IF
        END FOR
        IF l_ac < arrno THEN                        # BOM單身已讀完
           EXIT WHILE
        END IF
   END WHILE
END FUNCTION
 
