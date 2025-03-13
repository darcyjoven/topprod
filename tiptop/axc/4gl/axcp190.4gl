# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axcp190.4gl
# Descriptions...: 成會傳票拋轉總帳作業
# Date & Author..: 97/08/08 By Roger
# Modify.........: No.MOD-490217 04/09/10 by yiting 料號欄位使用like方式
# Modify.........: No.MOD-4C0005 04/12/01 By Carol 單價/金額欄位放大(20),位數改為dec(20,6)
# Modify.........: No.FUN-4C0099 05/01/10 By kim 報表轉XML功能
# Modify.........: No.MOD-530850 05/03/31 By will 增加料件的開窗
# Modify ........: No.FUN-560190 05/06/23 By wujie 單據編號修改,p_gz修改
# Modify.........: No.FUN-570240 05/07/25 By yoyo 料件編號欄位加controlp
# Modify ........: No.FUN-570168 05/07/29 By will 增加取得傳票缺號號碼的功能
# Modify.........: No.TQC-5B0166 05/11/21 By vivien 傳票缺號挑選視窗修改,傳票日期設置為系統日期
# Modify.........: No.MOD-5C0083 05/12/15 By Smapmin 總帳傳票單別要可以輸入完整的單號
# Modify.........: No.FUN-660127 06/06/23 By Czl cl_err --> cl_err3
# Modify.........: No.FUN-670006 06/07/10 By Jackho  帳別權限修改
# Modify.........: No.FUN-680122 06/08/29 By zdyllq 類型轉換
# Modify.........: No.FUN-690125 06/10/16 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0146 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.FUN-730057 07/03/29 By bnlent 會計科目加帳套
# Modify.........: No.TQC-840066 08/04/28 By Mandy AXD系統欲刪,原使用 AXD 模組相關欄位的程式進行調整
# Modify.........: No.FUN-840125 08/06/18 By sherry q_m_aac.4gl傳入參數時，傳入帳轉性質aac03= "0.轉帳轉票"
# Modify.........: No.FUN-840211 08/07/23 By sherry 拋轉的同時要產生總號(aba11)
# Modify.........: No.FUN-980009 09/08/20 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.TQC-980179 09/08/21 By Pengu compile出現沒有sr.gem01錯誤
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980094 09/09/14 By TSD.hoho GP5.2 跨資料庫語法修改
# Modify.........: No.FUN-980059 09/09/17 By arman  GP5.2架構,修改SUB相關傳入參數  
# Modify.........: No.FUN-990069 09/09/25 By baofei GP集團架構修改,sub相關參數 
# Modify.........: No.TQC-9B0021 09/11/05 By Carrier SQL STANDARDIZE
# Modify.........: No.FUN-A10036 10/01/13 By baofei 手動修改INSERT INTO xxx_file ，增加xxx_file xxxoriu, xxxorig這二個欄位
# Modify.........: No.FUN-A50102 10/06/10 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:MOD-A80136 10/08/18 By Dido 新增至 aba_file 時,提供 aba24 預設值 
# Modify.........: No.FUN-AA0059 10/10/26 By chenying 料號開窗控管
# Modify.........: NO.CHI-AC0010 10/12/16 By sabrina 調整temptable名稱，改成agl_tmp_file
# Modify.........: No:TQC-B70021 11/07/19 By wujie 抛转tic_file
# Modify.........: No:CHI-CB0004 12/11/12 By Belle 修改總號計算方式
# Modify.........: No:FUN-C80092 12/09/12 By xujing 成本相關作業程式日誌
# Modify.........: No.CHI-C80041 12/12/24 By bart 排除作廢

DATABASE ds
 
GLOBALS "../../config/top.global"
 
    DEFINE tm  RECORD                  # Print condition RECORD
		bdate, edate	LIKE type_file.dat,            #No.FUN-680122DATE,
		bslip, eslip	LIKE aab_file.aab02,           #No.FUN-680122CHAR(5),             #No.FUN-560190
 		bpart, epart	LIKE tlf_file.tlf01,  #No.MOD-490217
		b_lev, e_lev	LIKE type_file.num5,           #No.FUN-680122SMALLINT,
		b_stk, e_stk	LIKE type_file.chr1,           #No.FUN-680122CHAR(1),
		order_flag	LIKE type_file.chr1,           #No.FUN-680122 VARCHAR(1)
		report_flag	LIKE type_file.chr1,           #No.FUN-680122 VARCHAR(1)
		more    	LIKE type_file.chr1            #No.FUN-680122 VARCHAR(1)        # Input more condition(Y/N)
              END RECORD,
 	  g_sql		string,  #No.FUN-580092 HCN
	  g_dbs_gl	LIKE type_file.chr21,          #No.FUN-680122CHAR(21),
	  g_plant_gl	LIKE type_file.chr21,          #No.FUN-980059CHAR(21),
	  p_plant	LIKE azp_file.azp01,           #No.FUN-680122CHAR(10),
          p_plant_old   LIKE tmn_file.tmn01,           #No.FUN-680122CHAR(10),     #No.FUN-570168  --add
	  p_bookno	LIKE aaa_file.aaa01,   #No.FUN-670006
	  gl_no		LIKE bxi_file.bxi01,  #No.FUN-680122 VARCHAR(16),           #FUN-560190
	  gl_date	LIKE type_file.dat,            #No.FUN-680122 DATE, 
	  g_yy,g_mm	LIKE type_file.num5,           #No.FUN-680122 SMALLINT,
	  gl_no_b,gl_no_e	LIKE bxi_file.bxi01,   #No.FUN-680122 VARCHAR(16),     #FUN-560190
 	  g_credit,g_debit	LIKE type_file.num20_6,  #No.FUN-680122DEC(20,6),  #MOD-4C0005
	  g_seq			LIKE type_file.num5,     #No.FUN-680122SMALLINT,
          g_actno	LIKE type_file.chr20,          #No.FUN-680122CHAR(20),
          g_actname	LIKE type_file.chr1000,        #No.FUN-680122CHAR(30),
          g_deptno	LIKE aab_file.aab02,           #No.FUN-680122CHAR(6),
          g_dc		LIKE type_file.chr1,           #No.FUN-680122CHAR(1),
           g_amt		LIKE type_file.num20_6,        #No.FUN-680122DEC(20,6),             #MOD-4C0005
          g_tot_bal             LIKE ccq_file.ccq03          #No.FUN-680122DECIMAL(13,2)              # User defined variable
DEFINE g_aba            RECORD LIKE aba_file.*
DEFINE g_aac            RECORD LIKE aac_file.*
DEFINE g_statu          LIKE type_file.chr1           #No.FUN-680122 VARCHAR(1)
DEFINE g_aba01t         LIKE aab_file.aab02          #No.FUN-680122 VARCHAR(5)               #FUN-560190
#------for ora修改-------------------
DEFINE g_system         LIKE aba_file.aba18           #No.FUN-680122CHAR(2)
DEFINE g_zero           LIKE type_file.num20_6        #No.FUN-680122decimal(15,3) #TQC-840066
DEFINE g_N              LIKE type_file.chr1           #No.FUN-680122CHAR(1)
DEFINE g_y              LIKE type_file.chr1           #No.FUN-680122CHAR(1)
#------for ora修改-------------------
 
 
DEFINE   g_flag          LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
DEFINE   g_row,g_col     LIKE type_file.num5          #No.FUN-680122SMALLINT
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680122 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680122 SMALLINT
DEFINE   g_j             LIKE type_file.num5          #No.FUN-680122SMALLINT  #No.FUN-570168  --add
DEFINE   g_cka00         LIKE cka_file.cka00   #FUN-C80092 add
DEFINE   g_cka09         LIKE cka_file.cka09   #FUN-C80092 add
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690125 BY dxfwo 
 
   #No.FUN-570168  --begin
   DROP TABLE agl_tmp_file
   CREATE TEMP TABLE agl_tmp_file(
    tc_tmp00   LIKE type_file.chr1 NOT NULL,
    tc_tmp01   LIKE type_file.num5,  
    tc_tmp02   LIKE type_file.chr20)
   IF STATUS THEN CALL cl_err('create tmp',STATUS,0) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM 
   END IF
   CREATE UNIQUE INDEX tc_tmp_01 on agl_tmp_file (tc_tmp02)
   IF STATUS THEN CALL cl_err('create index',STATUS,0) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM 
   END IF
   #No.FUN-570168  --end
 
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.order_flag = '1'
   LET tm.report_flag = '2'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET gl_date = g_today             #NO.TQC-5B0166
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   # g_apz.apz02p -> g_plant_new -> s_getdbs() -> g_dbs_new --> g_dbs_gl
   LET g_apz.apz02b = p_bookno  # 得帳別
 
   LET g_row = 3 LET g_col = 20
 
   OPEN WINDOW axcp190_w AT g_row,g_col WITH FORM "axc/42f/axcp190"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   SELECT * INTO g_apz.* FROM apz_file WHERE apz00='0'
   LET p_plant    = g_apz.apz02p
   LET p_bookno   = g_apz.apz02b
   CALL axcp190_tm()        # Input print condition
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
END MAIN
 
FUNCTION axcp190_tm()
   DEFINE   p_row,p_col   LIKE type_file.num5,          #No.FUN-680122 SMALLINT
            l_flag        LIKE type_file.chr1,          #No.FUN-680122 VARCHAR(1)
            l_cmd         LIKE type_file.chr1000,       #No.FUN-680122CHAR(400), 
            l_cnt         LIKE type_file.num5    #No.FUN-570168  -add        #No.FUN-680122 SMALLINT
   DEFINE   li_result     LIKE type_file.num5    #No.FUN-560190        #No.FUN-680122 SMALLINT
   DEFINE   li_chk_bookno  LIKE type_file.num5,           #No.FUN-680122 SMALLINT  #No.FUN-670006
            l_sql          STRING      #No.FUN-670006  -add
   DEFINE   l_no           LIKE type_file.chr3    #No.FUN-840125                
   DEFINE   l_aac03        LIKE aac_file.aac03    #No.FUN-840125 
   WHILE TRUE
      CLEAR FORM
      MESSAGE ""
      CALL cl_opmsg('p')
      LET gl_no_b=NULL LET gl_no_e=NULL
      LET p_plant_old = p_plant      #No.FUN-570168  --add
      INPUT BY NAME
         tm.bdate, tm.edate,tm.bslip, tm.eslip,tm.bpart, tm.epart,
         tm.b_lev, tm.e_lev,tm.b_stk, tm.e_stk,tm.order_flag, tm.report_flag,
         p_plant, p_bookno, gl_no, gl_date,tm.more
         WITHOUT DEFAULTS ATTRIBUTE(UNBUFFERED)  #No.FUN-570168  --add UNBUFFERED
 
         AFTER FIELD p_plant
            #No.B003 010413 by plum
            IF cl_null(p_plant) THEN
               NEXT FIELD p_plant
            END IF
            SELECT azp01 FROM azp_file WHERE azp01=p_plant
            IF STATUS <>0 THEN
               NEXT FIELD p_plant
            END IF
            #No.B003..end
            LET g_plant_new= p_plant  # 工廠編號
            CALL s_getdbs()
            LET g_dbs_gl=g_dbs_new    # 得資料庫名稱
            #No.B003 010413 by plum
            #No.FUN-570168  --begin
            IF p_plant_old != p_plant THEN
            DELETE FROM tmn_file
             WHERE tmn01 = p_plant_old
               AND tmn02 IN (SELECT tc_tmp02 FROM agl_tmp_file WHERE tc_tmp00 = 'Y')
            DELETE FROM agl_tmp_file
            LET p_plant_old = g_plant_new
            END IF
            #No.FUN-570168  --end
 
         AFTER FIELD p_bookno
            IF cl_null(p_bookno) THEN
               NEXT FIELD p_bookno
            END IF
            IF NOT cl_null(p_bookno) THEN
               #No.FUN-670006--begin
               CALL s_check_bookno(p_bookno,g_user,p_plant) 
                  RETURNING li_chk_bookno
               IF (NOT li_chk_bookno) THEN
                  NEXT FIELD p_bookno
               END IF 
               LET g_plant_new=p_plant 
                 #CALL s_getdbs()  #FUN-A50102
                 LET l_sql = "SELECT COUNT(*) ",
                             #"  FROM ",g_dbs_new CLIPPED,"aaa_file ",
                             "  FROM ",cl_get_target_table(g_plant_new,'aaa_file'),  #FUN-A50102
                             " WHERE aaa01 = '",p_bookno,"' ",
                             "   AND aaaacti IN ('Y','y') "
                 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
                 CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
                 PREPARE p190_pre2 FROM l_sql
                 DECLARE p190_cur2 CURSOR FOR p190_pre2
                 OPEN p190_cur2
                 FETCH p190_cur2 INTO g_cnt  
            END IF 
#            SELECT COUNT(*) INTO g_cnt FROM aaa_file WHERE aaa01=p_bookno
             #No.FUN-670006--end
            IF g_cnt=0 THEN
               CALL cl_err('sel aaa',100,0)
               NEXT FIELD p_bookno
            END IF
        #No.B003..end
 
         AFTER FIELD edate
            LET gl_date=tm.edate DISPLAY BY NAME gl_date
 
         AFTER FIELD gl_no
            IF gl_no IS NOT NULL THEN
               #No.B112 010505 by plum
               LET g_errno=' '
#No.FUN-560190 --start--
#            CALL s_check_no("agl",gl_no,"","1","","",g_dbs_gl)       #MOD-5C0083
           #CALL s_check_no("agl",gl_no,"","1","aac_file","aac01",g_dbs_gl)   #MOD-5C0083 #FUN-980094
            CALL s_check_no("agl",gl_no,"","1","aac_file","aac01",p_plant)   #MOD-5C0083 #FUN-980094
            RETURNING li_result,gl_no
#            LET gl_no = s_get_doc_no(gl_no)     #MOD-5C0083
#            DISPLAY BY NAME gl_no      #MOD-5C0083
            IF (NOT li_result) THEN
               NEXT FIELD gl_no
            END IF
            #No.FUN-840125---Begin                                                  
            LET l_no = gl_no                                                        
            SELECT aac03 INTO l_aac03 FROM aac_file WHERE aac01= l_no               
            IF l_aac03 != '0' THEN                                                  
               CALL cl_err(gl_no,'agl-991',0)                                       
               NEXT FIELD gl_no                                                     
            END IF                                                                  
            #No.FUN-840125---End 
#               CALL s_chkno(gl_no) RETURNING g_errno
#               IF NOT cl_null(g_errno) THEN
#                  CALL cl_err(gl_no,g_errno,0)
#                  NEXT FIELD gl_no
#               END IF
#              #No.B112 ..end
#
#               CALL s_m_aglsl(g_dbs_gl,gl_no,'1')
#               IF NOT cl_null(g_errno) THEN
#                  CALL cl_err(gl_no,g_errno,0) NEXT FIELD gl_no
#               END IF
#No.FUN-560190 ---end--
            END IF
 
         AFTER FIELD gl_date
            IF gl_date IS NOT NULL THEN
               SELECT azn02,azn04 INTO g_yy,g_mm FROM azn_file WHERE azn01=gl_date
               IF STATUS THEN
#                 CALL cl_err('read azn:',SQLCA.sqlcode,0)    #No.FUN-660127
                  CALL cl_err3("sel","azn_file",gl_date,"",SQLCA.sqlcode,"","read azn:",0)   #No.FUN-660127
                  NEXT FIELD gl_date 
               END IF
            END IF
 
        #No.B003 010413 by plum
         AFTER INPUT
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
            LET l_flag='N'
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
            IF cl_null(p_plant)    THEN
               LET l_flag='Y'
            END IF
            IF cl_null(p_bookno)   THEN
               LET l_flag='Y'
            END IF
            IF NOT cl_null(gl_no) THEN
               IF cl_null(gl_date)    THEN
                  LET l_flag='Y'
               END IF
            END IF
            IF l_flag='Y' THEN
               CALL cl_err('','9033',0)
               NEXT FIELD p_plant
            END IF
            # 得出總帳 database name
            # g_apz.apz02p -> g_plant_new -> s_getdbs() -> g_dbs_new --> g_dbs_gl
            LET g_plant_new= p_plant  # 工廠編號
            CALL s_getdbs()
            LET g_dbs_gl=g_dbs_new    # 得資料庫名稱
            SELECT azn02,azn04 INTO g_yy,g_mm FROM azn_file WHERE azn01 = gl_date
            IF STATUS THEN
#              CALL cl_err('read azn:',SQLCA.sqlcode,0)   #No.FUN-660127
               CALL cl_err3("sel","azn_file",gl_date,"",SQLCA.sqlcode,"","read azn:",0)   #No.FUN-660127
               NEXT FIELD gl_date
            END IF
          #No.B003..end
 
         AFTER FIELD more
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,g_bgjob,g_time,g_prtway,g_copies)
               RETURNING g_pdate,g_towhom,g_rlang,g_bgjob,g_time,g_prtway,g_copies
            END IF
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
         ON ACTION CONTROLG
            CALL cl_cmdask()    # Command execution
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
      #MOD-530850
     ON ACTION CONTROLP
        CASE
#No.FUN-560190--begin
          WHEN INFIELD(gl_no)
            CALL s_getdbs()
            LET g_dbs_gl=g_dbs_new
            LET g_plant_gl = p_plant   #No.FUN-980059
            #CALL q_m_aac(FALSE,TRUE,g_dbs_gl,gl_no,'1',' ',' ','AGL')  #No.FUN-840125
         #  CALL q_m_aac(FALSE,TRUE,g_dbs_gl,gl_no,'1','0',' ','AGL')   #No.FUN-840125    #No.FUN-980059
            CALL q_m_aac(FALSE,TRUE,g_plant_gl,gl_no,'1','0',' ','AGL')   #No.FUN-840125  #No.FUN-980059
            RETURNING gl_no  #NO:6842
            DISPLAY BY NAME gl_no
            NEXT FIELD gl_no
#No.FUN-560190--end
          WHEN INFIELD(bpart)
#FUN-AA0059---------mod------------str-----------------          
#            CALL cl_init_qry_var()
#            LET g_qryparam.form = "q_ima"
#            LET g_qryparam.default1 = tm.bpart
#            CALL cl_create_qry() RETURNING tm.bpart
            CALL q_sel_ima(FALSE, "q_ima","",tm.bpart,"","","","","",'' ) 
                RETURNING  tm.bpart
#FUN-AA0059---------mod------------end-----------------    
            DISPLAY BY NAME tm.bpart
            NEXT FIELD bpart
#No.FUN-570240--start
          WHEN INFIELD(epart)
#FUN-AA0059---------mod------------str-----------------          
#            CALL cl_init_qry_var()
#            LET g_qryparam.form = "q_ima"
#            LET g_qryparam.default1 = tm.epart
#            CALL cl_create_qry() RETURNING tm.epart
            CALL q_sel_ima(FALSE, "q_ima","",tm.epart,"","","","","",'' ) 
                RETURNING  tm.epart
#FUN-AA0059---------mod------------end-----------------    
            DISPLAY BY NAME tm.epart
            NEXT FIELD epart
#No.FUN-570240--end
         OTHERWISE
            EXIT CASE
       END CASE
    #--
 
     #No.FUN-570168  --begin
      ON ACTION get_missing_voucher_no
         IF cl_null(gl_no) THEN
            NEXT FIELD gl_no
         END IF
 
         DELETE FROM tmn_file
          WHERE tmn01 = p_plant
            AND tmn02 IN (SELECT tc_tmp02 FROM agl_tmp_file WHERE tc_tmp00 = 'Y')
         DELETE FROM agl_tmp_file
 
         CALL s_agl_missingno(p_plant,g_dbs_gl,g_apz.apz02b,gl_no,'','',gl_date,0)
 
         SELECT COUNT(*) INTO l_cnt FROM agl_tmp_file
          WHERE tc_tmp00='Y'
         IF l_cnt > 0 THEN
            CALL cl_err(l_cnt,'aap-501',0)
         ELSE
            CALL cl_err('','aap-502',0)
         END IF
      #No.FUN-570168  --end
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
         ON ACTION exit  #加離開功能genero
            LET INT_FLAG = 1
            EXIT INPUT
         ON ACTION locale                    #genero
            LET g_action_choice = "locale"
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
            EXIT INPUT
 
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
      IF g_action_choice = "locale" THEN  #genero
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         #No.FUN-570168  --start
         LET INT_FLAG = 0 CLOSE WINDOW axcp190_w
         DELETE FROM tmn_file
          WHERE tmn01 = p_plant
            AND tmn02 IN (SELECT tc_tmp02 FROM agl_tmp_file WHERE tc_tmp00 = 'Y')
            CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
         EXIT PROGRAM
         #No.FUN-570168  --end
      END IF
      IF tm.bslip IS NULL THEN
         LET tm.bslip=' '
      END IF
      IF tm.eslip IS NULL THEN
         LET tm.eslip='z'
      END IF
      IF tm.bpart IS NULL THEN
         LET tm.bpart=' '
      END IF
      IF tm.epart IS NULL THEN
         LET tm.epart='z'
      END IF
      IF tm.b_lev IS NULL THEN
         LET tm.b_lev=0
      END IF
      IF tm.e_lev IS NULL THEN
         LET tm.e_lev=999
      END IF
      IF tm.b_stk IS NULL THEN
         LET tm.b_stk=' '
      END IF
      IF tm.e_stk IS NULL THEN
         LET tm.e_stk='z'
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='axcp190'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
             CALL cl_err('axcp190','9031',1)   
         ELSE
            LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                            " '",g_pdate CLIPPED,"'",
                            " '",g_towhom CLIPPED,"'",
                            " '",g_lang CLIPPED,"'",
                            " '",g_bgjob CLIPPED,"'",
                            " '",g_prtway CLIPPED,"'",
                            " '",g_copies CLIPPED,"'"
            CALL cl_cmdat('axcp190',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW axcp190_w
         #No.FUN-570168  --start
         DELETE FROM tmn_file
          WHERE tmn01 = p_plant
            AND tmn02 IN (SELECT tc_tmp02 FROM agl_tmp_file WHERE tc_tmp00 = 'Y')
         #No.FUN-570168  --end
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
         EXIT PROGRAM
      END IF
      IF cl_sure(21,21) THEN   #genero
         CALL cl_wait()
         CALL axcp190()
         IF g_flag THEN
            CONTINUE WHILE
         END IF
      END IF
      ERROR ""
   END WHILE
 
   CLOSE WINDOW axcp190_w
END FUNCTION
 
FUNCTION axcp190()
   DEFINE l_name	LIKE type_file.chr20,          #No.FUN-680122  VARCHAR(20),       # External(Disk) file name
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0146
          l_sql		LIKE type_file.chr1000,      # RDSQL STATEMENT        #No.FUN-680122CHAR(600),
          l_chr		LIKE type_file.chr1,          #No.FUN-680122 VARCHAR(1)
          l_flag	LIKE type_file.chr1,          #No.FUN-680122 VARCHAR(1)
          xxx		LIKE fan_file.fan02,         #No.FUN-680122CHAR(3),
          u_sign	LIKE type_file.num5,           #No.FUN-680122SMALLINT,
          l_za05	LIKE type_file.chr1000,        #No.FUN-680122 VARCHAR(40)
          l_tlf		RECORD LIKE tlf_file.*,
          sr            RECORD order1	LIKE fan_file.fan02,         #No.FUN-680122CHAR(3),
                                  no		LIKE cre_file.cre08,           #No.FUN-680122CHAR(10),
                                  seq		LIKE type_file.num5,           #No.FUN-680122 SMALLINT,
                                  dc		LIKE type_file.chr1,           #No.FUN-680122CHAR(1),
                                  actno		LIKE type_file.chr20,          #No.FUN-680122CHAR(20), 
                                  deptno	LIKE aab_file.aab02,           #No.FUN-680122CHAR(6),
                                   amt		LIKE type_file.num20_6           #No.FUN-680122 DEC(20,6) #MOD-4C0005
                        END RECORD
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
    #FUN-C80092---add---str---
     LET g_cka09 = "bdate='",tm.bdate,"';edate=",tm.edate,"';bslip='",tm.bslip,"';eslip='",tm.eslip,"';",
                   "bpart='",tm.bpart,"';epart='",tm.epart,"';b_lev=",tm.b_lev,";e_lev=",tm.e_lev,";",
                   "b_stk='",tm.b_stk,"';e_stk='",tm.e_stk,"';order_flag='",tm.order_flag,"';",
                   "report_flag='",tm.report_flag,"';p_plant='",p_plant,"';p_bookno='",p_bookno,"';",
                   "gl_no='",gl_no,"';gl_date='",gl_date,"';more='",tm.more,"'"
     CALL s_log_ins(g_prog,'','','',g_cka09) RETURNING g_cka00   #FUN-C80092 add
    #FUN-C80092---add---end--- 
     #No.TQC-9B0021  --Begin
     #DECLARE axcp190_curs1 CURSOR FOR
     #   SELECT tlf_file.*
     #           FROM tlf_file, ima_file, smy_file #imd_file
     #          WHERE tlf06 BETWEEN tm.bdate AND tm.edate
     #           AND (tlf02=50 OR tlf03=50)
     #           AND tlf01       BETWEEN tm.bpart AND tm.epart
     #           AND SUBSTRING(tlf905,1,g_doc_len) BETWEEN tm.bslip AND tm.eslip     #No.FUN-560190
     #           AND tlf01 =ima01 AND ima57 BETWEEN tm.b_lev AND tm.e_lev
     #           #AND tlf902=imd01 AND imd09 BETWEEN tm.b_stk AND tm.e_stk
     #           AND SUBSTRING(tlf905,1,g_doc_len)=smyslip AND smy53='Y'                     #No.FUN-560190

     LET g_sql = " SELECT tlf_file.* ",
                 "   FROM tlf_file, ima_file, smy_file ", #imd_file
                 "  WHERE tlf06 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                 "   AND (tlf02=50 OR tlf03=50) ",
                 "   AND tlf01       BETWEEN '",tm.bpart,"' AND '",tm.epart,"'",
                 "   AND tlf905[1,",g_doc_len,"] BETWEEN '",tm.bslip,"' AND '",tm.eslip,"'",     #No.FUN-560190
                 "   AND tlf01 =ima01 AND ima57 BETWEEN ",tm.b_lev," AND ",tm.e_lev,
                 "   AND tlf905[1,",g_doc_len,"]=smyslip AND smy53='Y'  "                  #No.FUN-560190
     PREPARE p190_str_p1 FROM g_sql
     DECLARE axcp190_curs1 CURSOR FOR p190_str_p1
     #No.TQC-9B0021  --End  
 
     CALL cl_outnam('axcp190') RETURNING l_name
     START REPORT axcp190_rep TO l_name
     LET g_pageno = 0
     LET g_success = 'Y'
     BEGIN WORK
     FOREACH axcp190_curs1 INTO l_tlf.*
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       IF tm.order_flag='1'
       #No.FUN-560190 --start--
       #   THEN LET sr.order1 =l_tlf.tlf905[1,3]
           THEN CALL s_get_doc_no(l_tlf.tlf905) RETURNING sr.order1
       #No.FUN-560190 --end--
         ELSE LET sr.order1 =' '
       END IF
       IF l_tlf.tlf21 IS NULL THEN LET l_tlf.tlf21 = 0 END IF
       LET sr.no   =l_tlf.tlf905
       LET sr.seq  =l_tlf.tlf906
       LET sr.amt  =l_tlf.tlf21
       LET sr.dc   ='1'
       LET sr.actno=l_tlf.tlf15
       IF l_tlf.tlf03=50 OR l_tlf.tlf03=60	# 借方科目取 tlf03
          THEN LET sr.deptno=NULL
          ELSE LET sr.deptno=l_tlf.tlf19
       END IF
       IF (l_tlf.tlf13='aimt324' OR l_tlf.tlf13='aimt720') AND
          l_tlf.tlf02=50 AND sr.actno IS NULL
          THEN {調撥出庫無借方}
          ELSE IF sr.actno  IS NULL THEN LET sr.actno =' ' END IF
               IF sr.deptno IS NULL THEN LET sr.deptno=' ' END IF
               OUTPUT TO REPORT axcp190_rep(sr.*)
       END IF
       LET sr.dc   ='2'
       LET sr.actno=l_tlf.tlf16
       IF l_tlf.tlf02=50 OR l_tlf.tlf02=60	# 貸方科目取 tlf02
          THEN LET sr.deptno=NULL
          ELSE LET sr.deptno=l_tlf.tlf19
       END IF
       IF (l_tlf.tlf13='aimt324' OR l_tlf.tlf13='aimt720') AND
          l_tlf.tlf03=50 AND sr.actno IS NULL
          THEN {調撥入庫無貸方}
          ELSE IF sr.actno  IS NULL THEN LET sr.actno =' ' END IF
               IF sr.deptno IS NULL THEN LET sr.deptno=' ' END IF
               OUTPUT TO REPORT axcp190_rep(sr.*)
       END IF
     END FOREACH
 
     FINISH REPORT axcp190_rep
 
     IF gl_no IS NOT NULL THEN
     #---genero
        IF g_success = 'Y' THEN
            COMMIT WORK
            CALL s_log_upd(g_cka00,'Y')          #FUN-C80092 add
#            CALL s_m_prtgl(g_dbs_gl,p_bookno,gl_no_b,gl_no_e)   #FUN-990069
            CALL s_m_prtgl(g_plant_gl,p_bookno,gl_no_b,gl_no_e)   #FUN-990069
            CALL cl_end2(1) RETURNING g_flag        #批次作業正確結束
        ELSE
            ROLLBACK WORK
            CALL s_log_upd(g_cka00,'N')          #FUN-C80092 add
            CALL cl_end2(2) RETURNING g_flag        #批次作業失敗
        END IF
        CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     ELSE
        CALL cl_err('','aap-129',1)
        CALL cl_end2(2) RETURNING g_flag            #批次作業失敗
     END IF
     IF g_flag THEN
        RETURN
     ELSE
        #No.FUN-570168  --start
        DELETE FROM tmn_file
         WHERE tmn01 = p_plant
           AND tmn02 IN (SELECT tc_tmp02 FROM agl_tmp_file WHERE tc_tmp00 = 'Y')
        #No.FUN-570168  --end
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
        EXIT PROGRAM
     END IF
     #---genero
 
END FUNCTION
 
REPORT axcp190_rep(sr)
   DEFINE l_last_sw	LIKE type_file.chr1,           #No.FUN-680122CHAR(1),
          l_gem02  LIKE gem_file.gem02,
          sr               RECORD order1	LIKE fan_file.fan02,         #No.FUN-680122CHAR(3),
                                  no		LIKE cre_file.cre08,           #No.FUN-680122 VARCHAR(10),
                                  seq		LIKE type_file.num5,           #No.FUN-680122SMALLINT,
                                  dc		LIKE type_file.chr1,           #No.FUN-680122 VARCHAR(1),
                                  actno		LIKE type_file.chr20,          #No.FUN-680122CHAR(20),
                                  deptno	LIKE aab_file.aab02,           #No.FUN-680122CHAR(6),
                                   amt		LIKE type_file.num20_6          #No.FUN-680122 DEC(20,6)  #MOD-4C0005
                        END RECORD
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER BY sr.order1, sr.no, sr.seq, sr.dc, sr.actno
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<','/pageno'
      PRINT g_head CLIPPED,pageno_total
      PRINT g_x[11],tm.bdate,'-',tm.edate
      PRINT g_dash
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
            g_x[36],g_x[37],g_x[38],g_x[39]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.order1
      IF tm.report_flag='1' THEN
         PRINT sr.order1;
      END IF
      DROP TABLE p190_tmp
      CREATE TEMP TABLE p190_tmp (
          actno  LIKE type_file.chr20,
          deptno LIKE type_file.chr6,
          dc     LIKE type_file.chr1,
          amt	 LIKE type_file.num20_6 )   #MOD-4C0005
   BEFORE GROUP OF sr.no
      IF tm.report_flag='1' THEN
         PRINT COLUMN g_c[32],sr.no, sr.seq USING '###&';
      END IF
   ON EVERY ROW
      IF tm.report_flag='1' THEN
         LET g_actname=NULL
         SELECT aag02 INTO g_actname FROM aag_file WHERE aag01=sr.actno
                                                     AND aag00=p_bookno    #No.FUN-730057
         IF SQLCA.sqlcode THEN LET g_actname = NULL END IF
         SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=sr.deptno     #No.TQC-980179 modify  
         IF SQLCA.sqlcode THEN LET l_gem02 = NULL END IF
         PRINT COLUMN g_c[34],sr.actno[1,11],
               COLUMN g_c[35],g_actname[1,21],
               COLUMN g_c[36],sr.deptno,
               COLUMN g_c[37],l_gem02,
               COLUMN g_c[38],sr.dc,
               COLUMN g_c[39],cl_numfor(sr.amt,39,0)
      END IF
      UPDATE p190_tmp SET amt=amt+sr.amt
             WHERE actno =sr.actno
               AND deptno=sr.deptno
               AND dc    =sr.dc
      IF SQLCA.SQLERRD[3]=0 THEN
         INSERT INTO p190_tmp VALUES(sr.actno,sr.deptno,sr.dc,sr.amt)
      END IF
   AFTER GROUP OF sr.order1
      CALL p190_ins_aba(sr.order1)
      PRINT g_x[9],gl_no
      PRINT COLUMN g_c[31],sr.order1,
            COLUMN g_c[32],g_x[10] CLIPPED ;
      DECLARE c CURSOR FOR
              SELECT p190_tmp.* FROM p190_tmp ORDER BY dc,actno,deptno
      FOREACH c INTO g_actno, g_deptno, g_dc, g_amt, g_actname
         LET g_actname=NULL
         SELECT aag02 INTO g_actname FROM aag_file WHERE aag01=g_actno
                                                     AND aag00=p_bookno   #No.FUN-730057
         IF SQLCA.sqlcode THEN LET g_actname = NULL END IF
         SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=sr.deptno     #No.TQC-980179 modify  
         IF SQLCA.sqlcode THEN LET l_gem02 = NULL END IF
         PRINT COLUMN g_c[34],g_actno[1,11],
               COLUMN g_c[35],g_actname[1,21],
               COLUMN g_c[36],g_deptno,
               COLUMN g_c[37],l_gem02,
               COLUMN g_c[38],g_dc,
               COLUMN g_c[39],cl_numfor(g_amt,39,0)
         CALL p190_ins_abb()
      END FOREACH
      CALL s_flows('2',p_bookno,gl_no,gl_date,g_N,'',TRUE)   #No.TQC-B70021
      CALL p190_upd_aba()
      PRINT g_dash2
   ON LAST ROW
     #PRINT g_dash
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_c[39],g_x[7] CLIPPED
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash
              PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_c[39],g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
END REPORT
 
FUNCTION p190_ins_aba(p_order1)
     DEFINE p_order1	LIKE cre_file.cre08           #No.FUN-680122CHAR(10)
     DEFINE li_result   LIKE type_file.num5     #No.FUN-560190        #No.FUN-680122 SMALLINT
     DEFINE l_missingno   LIKE aba_file.aba01  #No.FUN-570168  --add
     DEFINE l_flag1       LIKE type_file.chr1                #No.FUN-570168  --add        #No.FUN-680122 VARCHAR(1)
     DEFINE l_aba11       LIKE aba_file.aba11   #FUN-840211
     DEFINE  l_plant  LIKE azp_file.azp01 #FUN-980009 add
     DEFINE  l_legal  LIKE azw_file.azw02 #FUN-980009 add
     DEFINE l_yy1         LIKE type_file.num5   #CHI-CB0004
     DEFINE l_mm1         LIKE type_file.num5   #CHI-CB0004
 
     IF gl_no IS NULL THEN RETURN END IF
     #No.FUN-570168  --begin
     LET l_flag1='N'
     LET l_missingno = NULL
     LET g_j=g_j+1
     SELECT tc_tmp02 INTO l_missingno
       FROM agl_tmp_file
      WHERE tc_tmp01=g_j AND tc_tmp00 = 'Y'
     IF NOT cl_null(l_missingno) THEN
        LET l_flag1='Y'
        LET gl_no=l_missingno
        DELETE FROM agl_tmp_file WHERE tc_tmp02 = gl_no
     END IF
   #缺號使用完，再在流水號最大的編號上增加
   IF l_flag1='N' THEN
   #No.FUN-570168  --end
#No.FUN-560190 --start--
    #CALL s_auto_assign_no("agl",gl_no,gl_date,"1","","",g_dbs_gl,"",p_bookno) #FUN-980094 mark
     CALL s_auto_assign_no("agl",gl_no,gl_date,"1","","",p_plant,"",p_bookno) #FUN-980094
          RETURNING li_result,gl_no
#     CALL s_m_aglau(g_dbs_gl,p_bookno,gl_no,gl_date,g_yy,g_mm,0)
#          RETURNING g_i,gl_no
#     IF g_i != 0 THEN LET g_success = 'N' END IF
     IF li_result = 0 THEN LET g_success = 'N' END IF
#No.FUN-560190 ---end--
     END IF  #No.FUN-570168  -add
       #No.FUN-840211---Begin
     IF g_aaz.aaz81 = 'Y' THEN
      LET l_yy1 = YEAR(gl_date)    #CHI-CB0004
      LET l_mm1 = MONTH(gl_date)   #CHI-CB0004 
        SELECT MAX(aba11)+1 INTO l_aba11 FROM aba_file
         WHERE aba00 = p_bookno
         AND YEAR(aba02) = l_yy1 AND MONTH(aba02) = l_mm1  #CHI-CB0004
         AND aba19 <> 'X'  #CHI-C80041
     #CHI-CB0004--(B)
      IF cl_null(l_aba11) OR l_aba11 = 1 THEN
         LET l_aba11 = YEAR(gl_date)*1000000+MONTH(gl_date)*10000+1
      END IF
     #CHI-CB0004--(E)
     #IF cl_null(l_aba11) THEN LET l_aba11 = 1 END IF  #CHI-CB0004
           LET g_aba.aba11 = l_aba11
     ELSE 
           LET g_aba.aba11 = ' '        
     END IF      
  #No.FUN-840211---End
     #LET g_sql="INSERT INTO ",g_dbs_gl,"aba_file",
     LET g_sql="INSERT INTO ",cl_get_target_table(g_plant_new,'aba_file'),   #FUN-A50102
                        "(aba00,aba01,aba02,aba03,aba04,aba05,",
                        " aba06,aba07,aba08,aba09,aba12,abamksg,abapost,",
                        " abaprno,abaacti,abauser,abagrup,abadate,",
                        " abasign,abadays,abaprit,abasmax,abasseq,aba11,",
                        " apalegal,abaoriu,abaorig,aba24)",  #FUN-A10036   #FUN-840211 add aba11 #FUN-980009 add abalegal #MOD-A80136 add aba24
                   " VALUES(?,?,?,?,?,?, ?,?,?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,?, ?,?,?,?)"  #FUN-A10036  #FUN-840211 add ? #FUN-980009 add ? #MOD-A80136 add ?
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
     LET l_plant = g_plant_new  #FUN-980009 add 
     CALL s_getlegal(l_plant) RETURNING l_legal  #FUN-980009 add 
     
     PREPARE p190_1_p4 FROM g_sql
## ----
     #自動賦予簽核等級
     LET g_aba.aba01=gl_no
     LET g_aba01t = gl_no[1,g_doc_len]               #No.FUN-560190
     SELECT aac08,aacatsg,aacdays,aacprit,aacsign  #簽核處理 (Y/N)
       INTO g_aba.abamksg,g_aac.aacatsg,g_aba.abadays,
            g_aba.abaprit,g_aba.abasign
       FROM aac_file WHERE aac01 = g_aba01t
     IF g_aba.abamksg MATCHES  '[Yy]'
        THEN
        IF g_aac.aacatsg matches'[Yy]'   #自動付予
           THEN
           CALL s_sign(g_aba.aba01,4,'aba01','aba_file')
                RETURNING g_aba.abasign
        END IF
        SELECT COUNT(*) INTO g_aba.abasmax
            FROM azc_file
            WHERE azc01=g_aba.abasign
     END IF
## ----
    #----------------------  for ora修改 ------------------------------------
     LET g_system = 'GL'
     LET g_zero   = 0
     LET g_N      = 'N'
     LET g_Y      = 'Y'
     EXECUTE p190_1_p4 USING p_bookno,gl_no,gl_date,g_yy,g_mm,gl_date,
                             g_system,p_order1,g_zero,g_zero,g_N,
                             g_aba.abamksg,g_N,
                             g_zero,g_Y,g_user,g_grup,g_today,
                 g_aba.abasign,g_aba.abadays,g_aba.abaprit,g_aba.abasmax,g_zero
                 ,g_aba.aba11,l_legal,g_user,g_grup,g_user  #FUN-A10036   #FUN-840211 add aba11 #FUN-980009 add l_legal #MOD-A80136 add g_user
    #EXECUTE p190_1_p4 USING p_bookno,gl_no,gl_date,g_yy,g_mm,gl_date,
    #                           'GL',p_order1,'0','0','N',g_aba.abamksg,'N',
    #                           '0','Y',g_user,g_grup,g_today,
    #             g_aba.abasign,g_aba.abadays,g_aba.abaprit,g_aba.abasmax,'0'
    #----------------------  for ora修改 ------------------------------------
     IF SQLCA.sqlcode THEN
         CALL cl_err('ins aba:',SQLCA.sqlcode,1) LET g_success = 'N'
     END IF
     DELETE FROM tmn_file WHERE tmn01 = p_plant AND tmn02 = gl_no  #No.FUN-570168 -add
     IF gl_no_b IS NULL THEN LET gl_no_b = gl_no END IF
     LET gl_no_e = gl_no
     LET g_credit = 0 LET g_debit  = 0
     LET g_seq = 0
END FUNCTION
 
FUNCTION p190_ins_abb()
     DEFINE  l_plant  LIKE azp_file.azp01 #FUN-980009 add
     DEFINE  l_legal  LIKE azw_file.azw02 #FUN-980009 add
 
     IF gl_no IS NULL THEN RETURN END IF
     LET g_seq = g_seq + 1
     #LET g_sql = "INSERT INTO ",g_dbs_gl,"abb_file",
     LET g_sql = "INSERT INTO ",cl_get_target_table(g_plant_new,'abb_file'),  #FUN-A50102
                        "(abb00,abb01,abb02,abb03,",
                        " abb05,abb06,abb07,abblegal)", #FUN-980009 add abblegal
                 " VALUES(?,?,?,?, ?,?,?, ?)" #FUN-980009 add ?
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
     LET l_plant = g_plant_new  #FUN-980009 add 
     CALL s_getlegal(l_plant) RETURNING l_legal  #FUN-980009 add 
     PREPARE p400_1_p5 FROM g_sql
     EXECUTE p400_1_p5 USING
                p_bookno,gl_no,g_seq,g_actno,
                g_deptno,g_dc,g_amt,l_legal #FUN-980009 add l_legal
     IF SQLCA.sqlcode THEN
        CALL cl_err('ins abb:',SQLCA.sqlcode,1) LET g_success = 'N'
     END IF
     IF g_dc = '1'
        THEN LET g_debit  = g_debit  + g_amt
        ELSE LET g_credit = g_credit + g_amt
     END IF
END FUNCTION
 
FUNCTION p190_upd_aba()
   IF gl_no IS NULL THEN RETURN END IF
   #LET g_sql = "UPDATE ",g_dbs_gl,"aba_file SET aba08 =?,aba09 = ? ",
   LET g_sql = "UPDATE ",cl_get_target_table(g_plant_new,'aba_file'),  #FUN-A50102
                 " SET aba08 =?,aba09 = ? ",
               " WHERE aba01 = ? AND aba00 = ?"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
   PREPARE p400_1_p6 FROM g_sql
   EXECUTE p400_1_p6 USING g_debit,g_credit,gl_no,p_bookno
   IF SQLCA.sqlcode THEN
      CALL cl_err('upd aba08/09:',SQLCA.sqlcode,1) LET g_success = 'N'
   END IF
       #No.FUN-560190 --start--
#   LET gl_no[6,16]=''
   LET gl_no[g_no_sp,g_no_ep]=''
       #No.FUN-560190 --end--
END FUNCTION
#Patch....NO.TQC-610037 <001> #
#CHI-AC0010
