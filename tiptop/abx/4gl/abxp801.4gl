# Prog. Version..: '5.30.06-13.03.15(00010)'     #
#
# Pattern name...: abxp801.4gl
# Descriptions...: 保稅入庫單據擷取作業
# Date & Author..: 95/07/02 By Roger
# Modify.........: No.MOD-530861 05/03/31 By kim 若g_bnz.bnz01 is null則不加入where 條件,g_bnz.bnz02相同
# Modify.........: No.FUN-550033 05/05/18 By wujie 單據編號加大
# Modify.........: No.MOD-580323 05/08/28 By jackie 將程序中寫死為中文的錯誤信息改由p_ze維護
# Modify.........: No.MOD-5A0105 05/10/13 By ice 料號欄位放大
# Modify.........: No.FUN-570115 06/03/01 By saki 加入背景作業功能
# Modify.........: No.FUN-680062 06/08/21 By yjkhero  欄位類型轉換 
# Modify.........: No.FUN-690108 06/10/13 By xumin cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0062 06/10/27 By hellen l_time轉g_time	
# Modify.........: No.FUN-6A0007 06/10/31 By kim GP3.5 台虹保稅客製功能回收修改
# Modify.........: No.FUN-6A0083 06/11/09 By xumin 報表寬度不符問題更正
# Modify.........: No.MOD-720102 07/03/16 By pengu 避免使用錯誤操作及防呆入庫擷取增加tlf907=1 之判斷
# Modify.........: No.MOD-840468 08/08/23 By hongmei 控制打印顯示
# Modify.........: No.MOD-920230 09/02/18 By Smapmin 無法抓取入庫單的資料
# Modify.........: No.TQC-920053 09/02/20 By mike MSV BUG
# Modify.........: No.MOD-940203 09/04/14 By Smapmin 保稅異動原因為NULL時,預設pmc1912
# Modify.........: No.TQC-940178 09/05/12 By Cockroach 跨庫SQL一律改為調用s_dbstring()      
# Modify.........: No.MOD-950145 09/05/27 By Smapmin 改由cl_null()判斷是否為null
# Modify.........: No.FUN-980001 09/08/06 By TSD.hoho GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-9C0190 09/12/23 By Smapmin bxi09為空
# Modify.........: No:FUN-A30059 10/03/18 By rainy bxy_file 改為bna_file
# Modify.........: No.FUN-A50102 10/06/02 By lutingting 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:FUN-A70120 10/08/03 BY alex 調整rowid為type_file.row_id
# Modify.........: No:FUN-AB0089 11/02/25 By shenyang  修改本月平均單價
# Modify.........: No.FUN-910088 11/12/31 By chenjing 增加數量欄位小數取位
# Modify.........: No:CHI-C10005 12/02/03 By ck2yuan 倉庫間直接調撥不需擷取,過濾aimt324的tlf不擷取
# Modify.........: No:MOD-C30554 12/03/12 By xujing 擷取失敗，程式tlf05<>aimt324 錯誤，改成tlf13
# Modify.........: No:CHI-D10036 13/02/21 By jt_chen 未勾選[已產生異動單據重新產生]的選項，新增時重複寫入失敗，需顯示匯總訊息;反之，不判斷tlf909是否擷取過，一律刪除存在單據後直接新增

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_bxi    RECORD LIKE bxi_file.*
DEFINE b_bxj    RECORD LIKE bxj_file.*
DEFINE g_t1     LIKE type_file.chr5               #No.FUN-550033        #No.FUN-680062 VARCHAR(5)
DEFINE s_date   LIKE type_file.dat                #No.FUN-680062 DATE
DEFINE p_rva08  LIKE rva_file.rva08
DEFINE p_rva21  LIKE rva_file.rva21
DEFINE g_wc,g_wc2,g_sql STRING  #No.FUN-580092 HCN       
DEFINE yclose   LIKE type_file.num5               #No.FUN-680062 SMALLINT
DEFINE mclose   LIKE type_file.num5                                      #No.FUN-680062    
DEFINE g_bnz           RECORD LIKE bnz_file.*
DEFINE g_i             LIKE type_file.num5      #count/index for any purpose        #No.FUN-680062SMALLINT
DEFINE l_flag          LIKE type_file.chr1                                         #No.FUN-680062CHAR(1)
DEFINE g_change_lang LIKE type_file.chr1        #No.FUN-680062 VARCHAR(01)
DEFINE g_a             LIKE type_file.chr1    #FUN-6A0007
DEFINE g_db_type       LIKE type_file.chr3 #FUN-6A0007
 
MAIN
   OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_wc   = ARG_VAL(1)
   LET g_bgjob= ARG_VAL(2)
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ABX")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690108
 
    LET g_db_type=cl_db_get_database_type() #FUN-6A0007
    SELECT * INTO g_bnz.* FROM bnz_file
     WHERE bnz00 = '0'
    WHILE TRUE
      IF g_bgjob="N" THEN                  # No.FUN-570115
         CLEAR FORM
         CALL p801_p1()
         IF cl_sure(0,0) THEN
            CALL cl_wait()                          # No.FUN-570115
            LET g_success = 'Y'
            BEGIN WORK
         #FUN-6A0007...............begin
         #已產生單據重新產生='Y'則須先刪除相關單據
         IF g_a = 'Y' THEN
            CALL p801_r()
         END IF
         #FUN-6A0007...............end
            CALL p801_s1()
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
      # No.FUN-570115 --start--
         ELSE
            CONTINUE WHILE
         END IF
            CLOSE WINDOW p801_w
      ELSE
         LET g_success = 'Y'         
         BEGIN WORK                 
         CALL p801_s1()
         IF g_success="Y" THEN
            COMMIT WORK
         ELSE
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      # No.FUN-570115 --end--
      END IF
    END WHILE
   # CLOSE WINDOW p801_w                               # No.FUN-570115
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
END MAIN
 
FUNCTION p801_p1()
    DEFINE   l_tlf06       LIKE type_file.chr1000            #No.FUN-680062 VARCHAR(80)
    DEFINE   d_tlf06       LIKE type_file.chr1000            #No.FUN-680062 VARCHAR(24)
    DEFINE   bdate,edate   LIKE type_file.dat                #No.FUN-680062 VARCHAR(10)
    DEFINE   l_date        LIKE type_file.dat                #No.FUN-680062 DATE
    DEFINE   l_str         STRING    #No.MOD-580323          #No.FUN-680062    
    DEFINE   lc_cmd        LIKE type_file.chr1000            #No.FUN-680062 VARCHAR(500)
 
   OPEN WINDOW p801_w WITH FORM "abx/42f/abxp801"
      ATTRIBUTE(STYLE=g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
   CLEAR FORM
   # No.FUN-570115 --end--
 
   LET l_date=MDY(MONTH(g_today),1,YEAR(g_today))-1
   LET edate=g_today
   LET bdate=MDY(MONTH(g_today),1,YEAR(g_today))
   LET d_tlf06=bdate CLIPPED,':',edate CLIPPED
   LET yclose=YEAR(l_date)
   LET mclose=MONTH(l_date)
   LET g_bgjob="N"                               #No.FUN-570115
#  INPUT BY NAME g_plant_new WITHOUT DEFAULTS
#    AFTER FIELD g_plant_new
#        IF g_plant_new IS NOT NULL AND NOT s_chknplt(g_plant_new,'','') THEN
#           ERROR "錯誤工廠編號" NEXT FIELD g_plant_new
#        END IF
#        DISPLAY BY NAME g_dbs_new
#       ON ACTION CONTROLR
#          CALL cl_show_req_fields()
#       ON ACTION CONTROLG
#               CALL cl_cmdask()
 
#  END INPUT
#  IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
      DISPLAY BY NAME g_plant_new
   WHILE TRUE                                    #No.FUN-570115
      CONSTRUCT BY NAME g_wc ON tlf036,tlf06,tlf031
 
         BEFORE CONSTRUCT
            DISPLAY d_tlf06 TO tlf06
         #No.FUN-580031 --start--
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         BEFORE FIELD tlf06
            LET l_tlf06=GET_FLDBUF(tlf06)
            IF cl_null(l_tlf06) THEN
               DISPLAY d_tlf06 TO tlf06
            END IF
 
         AFTER FIELD tlf06
            LET l_tlf06=GET_FLDBUF(tlf06)
            IF cl_null(l_tlf06) THEN
 #No.MOD-580323 --start--
               CALL cl_getmsg('abx-801',g_lang) RETURNING l_str
               ERROR l_str
#               ERROR '日期欄位不可輸入空白'
 #No.MOD-580323 --end--
               DISPLAY d_tlf06 TO tlf06
#           NEXT FIELD tlf06
            END IF
 
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
         ON ACTION locale
     #        CALL cl_dynamic_locale()              #No.FUN-570115
     #    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf  No.FUN-570115
     #        CONTINUE CONSTRUCT                    #No.FUN-570115
              LET g_change_lang = TRUE              #No.FUN-570115
              EXIT CONSTRUCT                        #No.FUN-570115
         ON ACTION exit                            #加離開功能
             LET INT_FLAG = 1
             EXIT CONSTRUCT
 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
      END CONSTRUCT
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
      #No.FUN-570115 --start--
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
         CONTINUE WHILE
      END IF
      #No.FUN-570115 --end--
      IF INT_FLAG THEN
         LET INT_FLAG=0
         CLOSE WINDOW p801_w                        #No.FUN-570115
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
         EXIT PROGRAM
      END IF
 
      #No.FUN-570115 --start--
   #FUN-6A0007...............begin
   #畫面新增,"已產生異動單據重新產生"的選項
 
   LET g_a = 'N'   
 
      INPUT BY NAME g_a,g_bgjob WITHOUT DEFAULTS 
   AFTER FIELD g_a         
      IF cl_null(g_a) OR g_a NOT MATCHES '[YN]' THEN
         NEXT FIELD g_a
      END IF
   #FUN-6A0007...............end
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION about         
            CALL cl_about()     
 
         ON ACTION help         
            CALL cl_show_help() 
 
         ON ACTION locale
            LET g_change_lang = TRUE
            EXIT INPUT
      END INPUT
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p801_w                
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
         EXIT PROGRAM
      END IF
      IF g_bgjob="Y" THEN
         SELECT zz08 INTO lc_cmd FROM zz_file
           WHERE zz01="abxp801"
         IF SQLCA.sqlcode OR cl_null(lc_cmd) THEN
            CALL cl_err('abxp801','9031',1)
         ELSE
            LET g_wc = cl_replace_str(g_wc,"'","\"")
            LET lc_cmd=lc_cmd CLIPPED,
                       " '",g_wc CLIPPED,"'",
                       " '",g_bgjob CLIPPED,"'"
            CALL cl_cmdat('abxp801',g_time,lc_cmd CLIPPED)
         END IF
         CLOSE WINDOW p801_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
         EXIT PROGRAM
      END IF
      EXIT WHILE
  END WHILE
  #No.FUN-570115 --end--
END FUNCTION
 
FUNCTION p801_s1()
   DEFINE l_tlf         RECORD LIKE tlf_file.*
   DEFINE no            LIKE type_file.chr20         #No.FUN-680062 VARCHAR(16)
   DEFINE seq           LIKE type_file.num5          #No.FUN-680062 SMALLINT   
   DEFINE l_tlf_rowid   LIKE type_file.row_id        #chr18     FUN-A70120             #該筆tlf_file record 的row id
   DEFINE l_ima08       LIKE ima_file.ima08          #No.FUN-680062 VARCHAR(1)   
   DEFINE l_y,l_m       LIKE type_file.num5          #No.FUN-680062 SMALLINT   
   DEFINE l_name        LIKE type_file.chr20         #External(Disk) file name      #No.FUN-680062 VARCHAR(20)   
   DEFINE l_bnz01,l_bnz02 STRING  #MOD-530861
   DEFINE l_str1        STRING    #No.MOD-580323  
   DEFINE l_date        LIKE type_file.dat           #No.FUN-680062 DATE
   DEFINE bdate,edate   LIKE type_file.chr20         #FUN-570115     #No.FUN-680062 VARCHAR(10)
   DEFINE l_n           LIKE type_file.num5,         #FUN-6A0007
          l_slip        LIKE type_file.chr5          #FUN-6A0007
   DEFINE l_err DYNAMIC ARRAY OF RECORD              #FUN-6A0007
                   tlf036 LIKE tlf_file.tlf036, 
                   tlf037 LIKE tlf_file.tlf037  
                END RECORD 
   DEFINE l_msg,l_msg2 STRING
 
  #No.FUN-570115 --start--
  IF g_bgjob="N" THEN
     #No.MOD-580323 --start--
      CALL cl_getmsg('mfg8011',g_lang) RETURNING l_str1
      MESSAGE l_str1
    #  MESSAGE ' 保稅入庫單據擷取中, 請稍候...... '
     #No.MOD-580323 --end--
  ELSE
     LET l_date=MDY(MONTH(g_today),1,YEAR(g_today))-1
     LET edate=g_today
     LET bdate=MDY(MONTH(g_today),1,YEAR(g_today))
     LET yclose=YEAR(l_date)
     LET mclose=MONTH(l_date)
  END IF
  #No.FUN-570115 --end--
 
  LET l_y=yclose
  LET l_m=mclose
  LET l_m=l_m+1
  IF l_m > 12 THEN
     LET l_m=1
     LET l_y=l_y+1
  END IF
   #MOD-530861...............begin
  LET l_bnz01=''
  LET l_bnz02=''
 #IF g_bnz.bnz01 IS NOT NULL THEN    #MOD-950145 mark
  IF NOT cl_null(g_bnz.bnz01) THEN   #MOD-950145 
    LET l_bnz01="  AND tlf036 NOT MATCHES '",g_bnz.bnz01 CLIPPED, "*' "
  END IF
 
  IF NOT cl_null(g_bnz.bnz02) THEN   #MOD-950145
     LET l_bnz02="  OR tlf036 MATCHES '",g_bnz.bnz02 CLIPPED,"*' "
  END IF
 
  CALL s_showmsg_init()   #CHI-D10036 add
  LET s_date=MDY(l_m,1,l_y)-1
  LET g_sql=
     "SELECT rowid,tlf_file.*",
    #"  FROM ",s_dbstring(g_dbs CLIPPED),"tlf_file",  #TQC-940178 ADD  #FUN-A50102
     "  FROM ",cl_get_target_table(g_plant,'tlf_file'),  #FUN-A50102
     " WHERE tlf909 IS NULL AND ",
     "((tlf03=50 AND tlf907=1",l_bnz01,")",   #MOD-920230
     l_bnz02,") AND ",g_wc CLIPPED,
#    " AND tlf05<>aimt324 "                        #CHI-C10005 add    #MOD-C30554 mark
     " AND tlf13<>aimt324 "                   #MOD-C30554

  CALL l_err.clear() #FUN-6A0007
  CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
  CALL cl_parse_qry_sql(g_sql,g_plant) RETURNING g_sql  #FUN-A50102

  PREPARE p801_p1 FROM g_sql
  DECLARE p801_s1_c CURSOR FOR p801_p1
  CALL cl_outnam('abxp801') RETURNING l_name
  START REPORT p801_rep TO l_name

  FOREACH p801_s1_c INTO l_tlf_rowid,l_tlf.*
    IF STATUS THEN LET g_success='N' RETURN END IF
    LET no=l_tlf.tlf036 LET seq=l_tlf.tlf037
 
    #FUN-6A0007...............begin
    #單別不存在保稅單據檔則不產生
   #LET l_slip = no[1,3]                     #FUN-6A0007
    CALL s_get_doc_no(no) RETURNING l_slip   #FUN-6A0007
    SELECT COUNT(*) INTO l_n
      #FROM bxy_file  WHERE bxy01 = l_slip   #FUN-A30059
      FROM bna_file  WHERE bna01 = l_slip    #FUN-A30059
    IF l_n = 0 THEN
       LET l_n=l_err.getlength()+1
       LET l_err[l_n].tlf036=l_tlf.tlf036
       LET l_err[l_n].tlf037=l_tlf.tlf037
       CONTINUE FOREACH
    END IF
 
    OUTPUT TO REPORT p801_rep(no,seq,l_tlf_rowid,l_tlf.*)
  END FOREACH
  FINISH REPORT p801_rep
  CALL s_showmsg()   #CHI-D10036
  IF l_err.getlength()>0 THEN
     LET l_msg2= cl_get_feldname('tlf036',g_lang) CLIPPED,"|",
                 cl_get_feldname('tlf037',g_lang) CLIPPED
     LET l_msg = cl_getmsg("abx-086",g_lang)
     CALL cl_show_array(base.TypeInfo.create(l_err),l_msg,l_msg2)
  END IF

  CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 

 
FUNCTION p801_r()
   DEFINE l_n          LIKE type_file.num5,
          l_bxi09      LIKE bxi_file.bxi09,
          l_str        LIKE type_file.chr1

  ##計算已產生異動的單據數量,如果為零則不作刪除的動作 
  #FUN-A50102--mod--str--
  #LET g_sql = "SELECT COUNT(*) FROM ",s_dbstring(g_dbs CLIPPED),"tlf_file,bxi_file",
   LET g_sql = "SELECT COUNT(*) ",
               "  FROM ",cl_get_target_table(g_plant,'tlf_file'),
               "      ,",cl_get_target_table(g_plant,'bxi_file'),
  #FUN-A50102--mod--end
              #"  WHERE tlf909 = 'Y' AND tlf036 = bxi01 ",   #CHI-D10036 mark
               "  WHERE tlf036 = bxi01 ",                    #CHI-D10036 add
               "    AND bxi06 = '1' AND ",g_wc CLIPPED
 
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
   CALL cl_parse_qry_sql(g_sql,g_plant) RETURNING g_sql #FUN-A50102
   PREPARE del_pre1 FROM g_sql
   DECLARE del_cur1 CURSOR FOR del_pre1
   OPEN del_cur1
   FETCH del_cur1 INTO l_n
   IF STATUS THEN
      CALL cl_err('fetch del_cur1',STATUS,1)
      LET g_success = 'N' 
      RETURN
   END IF 
   CLOSE del_cur1 
   
   IF l_n = 0 OR cl_null(l_n) THEN
      RETURN
   END IF
 
   #異動日期不可小於等於關帳日期,故不允許作刪除的動作
   IF NOT cl_null(g_bxz.bxz09) THEN
     #FUN-A50102--mod--str--
     #LET g_sql = "SELECT COUNT(*) FROM ",s_dbstring(g_dbs CLIPPED),"tlf_file,bxi_file", #TQC-920053 
      LET g_sql = "SELECT COUNT(*) ",
                  "  FROM ",cl_get_target_table(g_plant,'tlf_file'),
                  "      ,",cl_get_target_table(g_plant,'bxi_file'),
     #FUN-A50102--mod--end
                 #"   WHERE tlf909 = 'Y' AND tlf036 = bxi01 ",   #CHI-D10036 mark
                  "   WHERE tlf036 = bxi01 ",                    #CHI-D10036 add
                  "     AND bxi06 = '1' AND bxi02 <= '",g_bxz.bxz09,
                  "' AND ",g_wc CLIPPED
 
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
      CALL cl_parse_qry_sql(g_sql,g_plant) RETURNING g_sql #FUN-A50102
      PREPARE del_pre2 FROM g_sql
      DECLARE del_cur2 CURSOR FOR del_pre2
      OPEN del_cur2
      FETCH del_cur2 INTO l_n
      IF STATUS THEN
         CALL cl_err('fetch del_cur2',STATUS,1)
         LET g_success = 'Y'
         RETURN
      END IF
      CLOSE del_cur2
     
      IF l_n > 0 THEN
         CALL cl_err('','mfg9999',1)
         LET g_success = 'N'
         RETURN
      END IF 
   END IF                
 
   DROP TABLE x
   #FUN-6A0007...............begin
   #LET g_sql = "SELECT tlf036 FROM ",g_dbs CLIPPED,".tlf_file,bxi_file",
   #            "  WHERE tlf909 = 'Y' AND tlf907 = '1' AND ",g_wc CLIPPED,
   #            "  INTO TEMP x"
  #LET g_sql = "SELECT tlf036 FROM ",g_dbs CLIPPED,l_str,"tlf_file", #TQC-920053
  #LET g_sql = "SELECT tlf036 FROM ",s_dbstring(g_dbs CLIPPED),"tlf_file", #TQC-920053   #FUN-A50102
   LET g_sql = "SELECT tlf036 FROM ",cl_get_target_table(g_plant,'tlf_file'),  #FUN-A50102 
              #"  WHERE tlf909 = 'Y' AND tlf907 = '1' AND ",g_wc CLIPPED,   #CHI-D10036 mark
               "  WHERE tlf907 = '1' AND ",g_wc CLIPPED,                    #CHI-D10036 add
               "  INTO TEMP x"
   #FUN-6A0007...............end
 
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
   CALL cl_parse_qry_sql(g_sql,g_plant) RETURNING g_sql #FUN-A50102
   PREPARE del_pre3 FROM g_sql
   EXECUTE del_pre3 
   IF SQLCA.SQLCODE THEN
      CALL cl_err('execute del_pre3',SQLCA.SQLCODE,1)
      LET g_success = 'N'
      RETURN
   END IF 
 
   DELETE FROM bxi_file 
      WHERE bxi01 IN (SELECT tlf036 FROM x)
   IF SQLCA.SQLERRD[3] = 0 OR STATUS THEN
      CALL cl_err('del bxi_file',STATUS,1)
      LET g_success = 'N'
      RETURN
   END IF
 
   DELETE FROM bxj_file 
      WHERE bxj01 IN (SELECT tlf036 FROM x)
   IF STATUS THEN
      CALL cl_err('del bxj_file',STATUS,1)
      LET g_success = 'N'
      RETURN
   END IF
  #LET l_bxi09 = g_dbs CLIPPED,l_str #TQC-920053
  #LET l_bxi09 = s_dbstring(g_dbs CLIPPED) #TQC-920053
  LET l_bxi09 = g_plant   #FUN-A50102
  #LET g_sql = "UPDATE ",l_bxi09,"tlf_file",  #FUN-A50102
   LET g_sql = "UPDATE ",cl_get_target_table(g_plant,'tlf_file'),  #FUN-A50102 
               " SET tlf909 = NULL WHERE tlf036 IN (SELECT tlf036 FROM x)"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql  #FUN-A50102
   CALL cl_parse_qry_sql(g_sql,g_plant) RETURNING g_sql  #FUN-A50102
   PREPARE upd_tlf909 FROM g_sql
   EXECUTE upd_tlf909 
   IF SQLCA.SQLCODE THEN
      CALL cl_err('upd tlf909',SQLCA.SQLCODE,1)
      LET g_success = 'N'
      RETURN
   END IF
 
END FUNCTION
 
REPORT p801_rep(no,seq,l_tlf_rowid,l_tlf)
  DEFINE no             LIKE bxi_file.bxi01       #單據號碼
  DEFINE l_za05         LIKE za_file.za05
  DEFINE seq            LIKE type_file.num5       #單據項次
  DEFINE l_tlf_rowid    LIKE type_file.row_id     #chr18 FUN-A70120      #該筆tlf_file record 的row id
 #FUN-A30059 begin
  #DEFINE l_bxy04 LIKE bxy_file.bxy04,
  #       l_bxy05 LIKE bxy_file.bxy05,
  DEFINE l_bna05 LIKE bna_file.bna05,
         l_bna08 LIKE bna_file.bna08,
 #FUN-A30059 end
         l_sfb02 LIKE sfb_file.sfb02,
         l_slip  LIKE type_file.chr5          
  DEFINE l_tlf          RECORD LIKE tlf_file.*
  DEFINE l_bxi          RECORD LIKE bxi_file.*
  DEFINE l_bxj          RECORD LIKE bxj_file.*
  DEFINE l_no           LIKE type_file.chr5,
         l_sys          LIKE smy_file.smysys,
         l_kind         LIKE smy_file.smykind,
         l_desc         LIKE smy_file.smydesc,    #No.MOD-840468
         l_type         LIKE oay_file.oaytype,
         l_axm          LIKE type_file.chr1,
         l_bxj11        LIKE bxj_file.bxj11,
         l_bxj15        LIKE bxj_file.bxj15,
         l_bxj17        LIKE bxj_file.bxj17,
         l_bxj20    LIKE bxj_file.bxj20,
         l_bxj21    LIKE bxj_file.bxj21,
         l_bxj22    LIKE bxj_file.bxj22,  #FUN-6A0007
         l_bxj23    LIKE bxj_file.bxj23,  #FUN-6A0007
         l_inb13        LIKE inb_file.inb13,
#FUN-AB0089--add--begin
          l_inb132 LIKE inb_file.inb132,
          l_inb133 LIKE inb_file.inb133,
          l_inb134 LIKE inb_file.inb134,
          l_inb135 LIKE inb_file.inb135,
          l_inb136 LIKE inb_file.inb136,
          l_inb137 LIKE inb_file.inb137,
          l_inb138 LIKE inb_file.inb138,
#FUN-AB0089--add--end 
         l_inb14        LIKE inb_file.inb14, 
         l_pmm22        LIKE pmm_file.pmm22,
         l_rvv39        LIKE rvv_file.rvv39,
         l_rvv17        LIKE rvv_file.rvv17,
         l_rvu03        LIKE rvu_file.rvu03,
         l_ohb12        LIKE ohb_file.ohb12,
         l_ohb13        LIKE ohb_file.ohb13,
         l_ohb14        LIKE ohb_file.ohb14,
         l_oha09        LIKE oha_file.oha09,
         l_oha24        LIKE oha_file.oha24,
         l_ima106       LIKE ima_file.ima106,
         l_rate         LIKE oha_file.oha24
  DEFINE l_str          LIKE type_file.chr1,
         l_bxi09        LIKE bxi_file.bxi09
          
 
  OUTPUT TOP MARGIN g_top_margin 
         LEFT MARGIN g_left_margin 
         BOTTOM MARGIN g_bottom_margin 
         PAGE LENGTH g_page_line
 
  ORDER BY no,seq
 
  FORMAT
 
   BEFORE GROUP OF no
      INITIALIZE l_bxi.* TO NULL
      LET l_bxi.bxi01 =no
      LET p_rva21=NULL
      LET l_bxi.bxi02 =l_tlf.tlf06
      LET l_bxi.bxi03 =l_tlf.tlf19
      LET l_bxi.bxi05 =l_tlf.tlf13
      LET l_bxi.bxi06 ='1'
      #若為入庫單,要放發票號碼
      LET l_bxi.bxi11 =  YEAR(l_bxi.bxi02) USING '&&&&'  #申報年度
      LET l_bxi.bxi12 =  MONTH(l_bxi.bxi02)              #申報月份
      IF l_bxi.bxi05 = 'apmt150' THEN          
         DECLARE cur_rvb22 CURSOR FOR
           SELECT rvb22  FROM rvb_file,rvu_file,rva_file
            WHERE rvb01 = rva01 AND rvb01 = rvu02
              AND rvaconf = 'Y' AND rvu01 = l_bxi.bxi01
          OPEN cur_rvb22
          FETCH cur_rvb22 INTO l_bxi.bxi04
          IF STATUS THEN 
             LET l_bxi.bxi04 = NULL
          END IF
      END IF
      LET l_bxi.bxi08 ='XX'
     #LET l_slip=l_bxi.bxi01[1,3]                       #FUN-6A0007
      CALL s_get_doc_no(l_bxi.bxi01) RETURNING l_slip   #FUN-6A0007
   ##FUN-A30059 begin
      #SELECT bxy04,bxy05 INTO l_bxy04,l_bxy05 FROM bxy_file
      # WHERE bxy01=l_slip
      SELECT bna05,bna08 INTO l_bna05,l_bna08 FROM bna_file
       WHERE bna01=l_slip
   ##FUN-A30059 end
      IF STATUS = 0 THEN
        #FUN-A30059 begin
         #IF NOT cl_null(l_bxy05) THEN
         #   LET l_bxi.bxi08 =l_bxy05
         #END IF
         IF NOT cl_null(l_bna08) THEN
            LET l_bxi.bxi08 =l_bna08
         END IF
        #FUN-A30059 end
        #IF l_bxy05='B1' THEN   #FUN-A30059
        IF l_bna08='B1' THEN    #FUN-A30059
           SELECT sfb02 INTO l_sfb02 FROM sfb_file WHERE sfb01 =l_tlf.tlf026
           IF STATUS = 0 AND l_sfb02=7 THEN        #sfb02=7 委外工單
              LET l_bxi.bxi08 ='B2'
           END IF
        END IF
      END IF
    
     #TQC-940178 MARK&ADD START-------------
     #IF g_db_type='IFX' THEN
     #   LET l_str=":"
     #ELSE
     #   LET l_str="."
     #END IF
 
     #LET l_bxi09 = g_dbs CLIPPED,l_str
     #LET l_bxi09 = s_dbstring(g_dbs CLIPPED)  #add
     LET l_bxi09 = g_plant #FUN-A50102
     #TQC-940178 END -----------------------
      LET l_bxi.bxiconf ='Y'
 
      #保稅異動代碼取值(bxi08),和"收款客戶/付款廠商"(bxi13)取值
     #LET l_no = l_bxi.bxi01[1,3]                     
      CALL s_get_doc_no(l_bxi.bxi01) RETURNING l_no   
      LET l_sys = NULL    LET l_kind = NULL 
      LET l_type = NULL   LET l_axm = 'N'
#No.MOD-840468--Begin      
#     SELECT smysys,smykind INTO l_sys,l_kind
#        FROm smy_file WHERE smyslip = l_no
      SELECT smysys,smykind,smydesc INTO l_sys,l_kind,l_desc
         FROm smy_file WHERE smyslip = l_no   
#No.MOD-840468--End        
      IF NOT cl_null(l_sys) THEN
         CASE
            WHEN l_sys = 'aim' AND l_kind = '2'  #雜收單
               SELECT ina100 INTO l_bxi.bxi08
                  FROM ina_file WHERE ina01 = no
               IF STATUS THEN LET l_bxi.bxi08 = NULL END IF
 
            WHEN l_sys = 'apm' AND l_kind = '7'  #入庫單
               SELECT rvu100 INTO l_bxi.bxi08
                  FROM rvu_file WHERE rvu01 = no 
               IF STATUS THEN LET l_bxi.bxi08 = NULL END IF
               #-----MOD-940203---------
               IF cl_null(l_bxi.bxi08) THEN
                  SELECT pmc1912 INTO l_bxi.bxi08 FROM pmc_file
                    WHERE pmc01 = l_bxi.bxi03
                  IF STATUS THEN LET l_bxi.bxi08 = NULL END IF
               END IF
               #-----END MOD-940203-----
 
               SELECT pmc04 INTO l_bxi.bxi13 FROM pmc_file
                  WHERE pmc01 = l_bxi.bxi03
               IF STATUS THEN LET l_bxi.bxi13 = NULL END IF
 
            WHEN l_sys = 'aim' AND l_kind = '8'  #其他異動單據
               LET l_axm = 'Y' 
         END CASE
         #抓不到先給保稅單別對應的保稅原因代碼,抓不到則給'XX'
         #IF cl_null(l_bxi.bxi08) THEN LET l_bxi.bxi08 = l_bxy05 END IF   #FUN-A30059
         IF cl_null(l_bxi.bxi08) THEN LET l_bxi.bxi08 = l_bna08 END IF    #FUN-A30059
         IF cl_null(l_bxi.bxi08) THEN LET l_bxi.bxi08 = 'XX' END IF
      END IF
      #銷退單處理方式
      IF l_axm = 'Y' OR cl_null(l_sys) THEN
         SELECT oaytype INTO l_type FROM oay_file 
           WHERE oayslip = l_no
         IF l_type = '60' THEN   #銷退單   
            SELECT oha100,oha03 INTO l_bxi.bxi08,l_bxi.bxi13
               FROM oha_file WHERE oha01 = no
            IF STATUS THEN
               LET l_bxi.bxi08 = NULL
               LET l_bxi.bxi13 = NULL
            END IF
         END IF
         #抓不到先給保稅單別對應的保稅原因代碼,抓不到則給'XX'
         #IF cl_null(l_bxi.bxi08) THEN LET l_bxi.bxi08 = l_bxy05 END IF    #FUN-A30059
         IF cl_null(l_bxi.bxi08) THEN LET l_bxi.bxi08 = l_bna08 END IF     #FUN-A30059
         IF cl_null(l_bxi.bxi08) THEN LET l_bxi.bxi08 = 'XX' END IF
      END IF   
 
     #異動命令作業別(bxi15)取值:(依異動命令來取值)
      CASE 
           WHEN l_bxi.bxi05 = 'aimt302' OR l_bxi.bxi05 = 'aimt312'
                LET l_bxi.bxi15 = '1'   #雜收
           WHEN l_bxi.bxi05 = 'asfi526' OR l_bxi.bxi05 = 'asfi527' OR
                l_bxi.bxi05 = 'asfi528' OR l_bxi.bxi05 = 'asfi529'
                LET l_bxi.bxi15 = '5'   #工單退料
           WHEN l_bxi.bxi05 = 'asft6201'
                LET l_bxi.bxi15 = '6'   #完工入庫
           WHEN l_bxi.bxi05 = 'apmt150' OR l_bxi.bxi05 = 'apmt230'
                LET l_bxi.bxi15 = '7'   #採購入庫
           WHEN l_bxi.bxi05 = 'aomt800'
                LET l_bxi.bxi15 = 'A'   #銷貨退回
           OTHERWISE
                LET l_bxi.bxi15 = 'B'   #其它
      END CASE
 
      #LET l_bxi.bxi09 = s_dbstring(g_dbs CLIPPED)  #MOD-9C0190
      LET l_bxi.bxi09 = g_plant #FUN-A50102
      LET l_bxi.bxiplant = g_plant  ##FUN-980001 add
      LET l_bxi.bxilegal = g_legal  ##FUN-980001 add
 
      INSERT INTO bxi_file VALUES(l_bxi.*)
      #CHI-D10036 -- add start --
      IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
         CALL s_errmsg('bxi01',l_bxi.bxi01,'ins bxi',STATUS,1)
         LET g_success = 'N'
      END IF
      #CHI-D10036 -- add end --
 
      PRINT
#No.MOD-840468--Begin      
      PRINT COLUMN 1,g_x[11] CLIPPED,
            COLUMN 10,l_bxi.bxi01 CLIPPED,
            COLUMN 27,g_x[12] CLIPPED,l_desc
#           COLUMN 27,g_x[12] CLIPPED,
#           COLUMN 33,l_bxi.bxi02 CLIPPED,
#           COLUMN 41,g_x[13] CLIPPED,
#           COLUMN 46,l_bxi.bxi07 CLIPPED,
#           COLUMN 57,g_x[14] CLIPPED,
#           COLUMN 66,STATUS CLIPPED
#No.MOD-840468--End      
 
   ON EVERY ROW
      INITIALIZE l_bxj.* TO NULL
      LET l_bxj22 = NULL    #060810 By TSD.miki
      LET l_bxj23 = NULL    #060810 By TSD.miki
      LET l_sys = NULL       LET l_kind = NULL
      LET l_bxj11 = NULL     LET l_bxj17 = NULL
      LET l_bxj20 = 0    LET l_bxj21 = l_bxi.bxi08
      LET l_inb13 = 0        LET l_inb14 = 0
      LET l_pmm22 = NULL     LET l_rvv39 = 0
      LET l_rvv17 = 0        LET l_rvu03 = NULL
      LET l_type = NULL      LET l_ohb14 = 0
      LET l_oha24 = 0        LET l_oha09 = NULL
      LET l_ohb13 = 0        LET l_ohb12 = 0
      LET l_ima106 = NULL    LET l_axm = 'N'
 
      SELECT smysys,smykind INTO l_sys,l_kind 
         FROM smy_file WHERE smyslip = l_no
 
      IF NOT cl_null(l_sys) THEN
         CASE 
            WHEN l_sys = 'aim' AND l_kind = '2'    #雜收單
               SELECT ina101,ina102,inb13,inb132,inb133,inb134,inb135,inb136,inb137,inb138,inb14,inb911,inb912   #FUN-AB0089
                 INTO l_bxj11,l_bxj17,l_inb13,l_inb132,l_inb133,l_inb134,l_inb135,l_inb136,l_inb137,l_inb138,l_inb14,l_bxj22,l_bxj23
                 FROM ina_file,inb_file
                WHERE ina01 = inb01 AND ina01 = no AND inb03 = seq
               IF cl_null(l_inb13) THEN LET l_inb13 = 0 END IF
#FUN-AB0089--add--begin
               IF cl_null(l_inb132) THEN LET l_inb132 = 0 END IF
               IF cl_null(l_inb133) THEN LET l_inb133 = 0 END IF
               IF cl_null(l_inb134) THEN LET l_inb134 = 0 END IF
               IF cl_null(l_inb135) THEN LET l_inb135 = 0 END IF
               IF cl_null(l_inb136) THEN LET l_inb136 = 0 END IF
               IF cl_null(l_inb137) THEN LET l_inb137 = 0 END IF
               IF cl_null(l_inb138) THEN LET l_inb138 = 0 END IF
#FUN-AB0089--add--end
               IF cl_null(l_inb14) THEN LET l_inb14 = 0 END IF
               LET l_bxj15 = cl_digcut(l_inb14,t_azi04)
               LET l_bxj20 = cl_digcut(l_inb13+l_inb132+l_inb133+l_inb134+l_inb13+l_inb136+l_inb137+l_inb138,t_azi03)
 
            WHEN l_sys = 'apm' AND l_kind = '7'    #入庫單
               SELECT rva08,rva21,pmm22,rvv39,rvv17,rvu03
                  INTO l_bxj11,l_bxj17,l_pmm22,l_rvv39,l_rvv17,l_rvu03
                  FROM rvu_file,rvv_file,rva_file,rvb_file,pmm_file
                   WHERE rvu01 = rvv01 AND rva01 = rvu02 AND
                         rva01 = rvb01 AND rvv05 = rvb02 AND  
                         rvb04 = pmm01 AND
                         rvu01 = no AND rvv02 = seq
               #取入庫日期的海關賣出匯率
               CALL s_curr3(l_pmm22,l_rvu03,'D') RETURNING l_rate
               IF cl_null(l_rate)  THEN LET l_rate = 0 END IF
               IF cl_null(l_rvv39) THEN LET l_rvv39 = 0 END IF
               IF cl_null(l_rvv17) THEN LET l_rvv17 = 0 END IF
               # bxj15 =rvv39*入庫日期所取的海關賣出匯率,再取本幣金額的位數值
               # bxj20=bxj15/rvv17,再取本幣單價的位數值
               LET l_bxj15 = cl_digcut(l_rvv39 * l_rate,t_azi04)
               LET l_bxj20= cl_digcut(l_bxj15/l_rvv17,t_azi03)
            WHEN l_sys = 'aim' AND l_kind = '8'         #其他異動單
               LET l_axm = 'Y'            
            WHEN l_sys = 'asf' AND l_kind = '4'         #託外退料單
               SELECT ima53  INTO l_bxj20           #最近採購單價
                 FROM ima_file
                 WHERE ima01 = l_tlf.tlf01
               IF cl_null(l_bxj20) THEN LET l_bxj20=0 END IF
               LET l_bxj15 = cl_digcut(l_bxj20 * l_tlf.tlf10 * l_tlf.tlf60,
                                       t_azi04)
               LET l_bxj20= cl_digcut(l_bxj20,t_azi03)   
               IF l_bxi.bxi05 = 'asfi526' OR l_bxi.bxi05 = 'asfi527' OR
                  l_bxi.bxi05 = 'asfi528' OR l_bxi.bxi05 = 'asfi529' THEN
                  SELECT sfb22,sfb221 INTO l_bxj22,l_bxj23
                    FROM sfe_file,sfb_file
                   WHERE sfe02 = no
                     AND sfe28 = seq
                     AND sfe01 = sfb01
               END IF
         END CASE
      END IF
      IF l_axm = 'Y' OR cl_null(l_sys) THEN
         SELECT oaytype INTO l_type FROM oay_file 
            WHERE oayslip = l_no
         IF l_type = '60' THEN        #銷退單
            SELECT oha101,oha102,ohb14,oha24,oha09,ohb13,ohb12,
                   ohb33,ohb34
              INTO l_bxj11,l_bxj17,l_ohb14,l_oha24,l_oha09,l_ohb13,l_ohb12,
                   l_bxj22,l_bxj23
              FROM oha_file,ohb_file
             WHERE oha01 = ohb01 AND oha01 = no AND ohb03 = seq
            IF cl_null(l_ohb14) THEN LET l_ohb14 = 0 END IF
            IF cl_null(l_oha24) THEN LET l_oha24 = 0 END IF
            IF cl_null(l_ohb13) THEN LET l_ohb13 = 0 END IF
            IF cl_null(l_ohb12) THEN LET l_ohb12 = 0 END IF
          # bxj15 =原幣未稅金額(ohb14)*匯率oha24,再取本幣金額的位數值
          # 若為'5'折讓(oha09='5'), bxj20=ohb13*匯率oha24,再取本幣單價的位數值
          # 其餘 bxj20=bxj15/ohb12,再取本幣單價的位數值
            LET l_bxj15 = cl_digcut(l_ohb14*l_oha24,t_azi04)
            IF l_oha09 = '5' THEN
               LET l_bxj20 = cl_digcut(l_ohb13*l_oha24,t_azi03)
            ELSE
               LET l_bxj20 = cl_digcut(l_bxj15/l_ohb12,t_azi03)
            END IF
         END IF
        #抓取bxj21(折合原因代碼)
         SELECT ima106 INTO l_ima106
            FROM ima_file WHERE ima01 = l_tlf.tlf01
         IF l_ima106 = '1' THEN
            LET l_bxj21 = g_bxz.bxz103
         END IF
      END IF
 
      LET l_bxj.bxj01 =no
      LET l_bxj.bxj03 =seq
      LET l_bxj.bxj04 =l_tlf.tlf01
      SELECT ima25 INTO l_bxj.bxj05 FROM ima_file 
         WHERE ima01=l_tlf.tlf01
      LET l_bxj.bxj06 =l_tlf.tlf10*l_tlf.tlf60
      LET l_bxj.bxj06 = s_digqty(l_bxj.bxj06,l_bxj.bxj05)    #FUN-910088--add--
      LET l_bxj.bxj18 =l_tlf.tlf11
      LET l_bxj.bxj19 =l_tlf.tlf10
      LET l_bxj.bxj07 =l_tlf.tlf031    ## 96/10/29 ADD 庫別移到單身
      LET l_bxj.bxj10 =l_tlf.tlf17
      LET l_bxj.bxj11 = l_bxj11
      LET l_bxj.bxj17 = l_bxj17
      LET l_bxj.bxj15 = l_bxj15
      LET l_bxj.bxj20 = l_bxj20
      LET l_bxj.bxj21 = l_bxj21
      LET l_bxj.bxj22 = l_bxj22
      LET l_bxj.bxj23 = l_bxj23
      LET l_bxj.bxj12=l_tlf.tlf026
 
      LET l_bxj.bxjplant = g_plant  ##FUN-980001 add
      LET l_bxj.bxjlegal = g_legal  ##FUN-980001 add
 
      INSERT INTO bxj_file VALUES(l_bxj.*)
      
      IF STATUS=0 THEN
        #LET g_sql="UPDATE ",s_dbstring(g_dbs CLIPPED),"tlf_file ", #FUN-A50102
         LET g_sql="UPDATE ",cl_get_target_table(g_plant,'tlf_file'),  #FUN-A50102
                     " SET tlf909='Y' WHERE rowid=?" 
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
         CALL cl_parse_qry_sql(g_sql,g_plant) RETURNING g_sql   #FUN-A50102
         PREPARE p801_up_tlf FROM g_sql
         EXECUTE p801_up_tlf USING l_tlf_rowid
      #CHI-D10036 -- add start --
      ELSE
         CALL s_errmsg('bxj01',l_bxj.bxj01,'ins bxj',STATUS,1)       
         LET g_success = 'N'
      #CHI-D10036 -- add end --
      END IF
 
END REPORT

