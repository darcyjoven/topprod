# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axcp720.4gl (copy from axcp710.4gl)
# Descriptions...: RUNCARD製程轉入工單製程作業
# Date & Author..: 06/08/30 By kim For GP 3.5
# Modify.........: No.FUN-6A0146 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.FUN-710027 07/01/22 By dxfwo 增加修改單身批處理錯誤統整功能
# Modify.........: NO.TQC-790100 07/09/17 BY Joe 修正Primary Key後, 程式判斷錯誤訊息時必須改變做法
# Modify.........: NO.FUN-8A0086 08/10/21 By lutingting完善錯誤訊息匯總 
# Modify.........: No.FUN-980009 09/08/20 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-9A0021 09/10/15 By Lilan 將YEAR/MONTH的語法改成用BETWEEN語法
# Modify.........: No.FUN-9B0042 09/11/06 By wujie 5.2SQL转标准语法
# Modify.........: No.FUN-A60076 10/06/25 By huangtao GP5.25 製造功能優化-平行製程(批量修改)
# Modify.........: No:FUN-B30211 11/03/31 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No.FUN-A70095 11/06/14 By lixh1 撈取報工單(shb_file)的所有處理作業,必須過濾是已確認的單據
# Modify.........: No.TQC-B80022 11/08/02 By jason INSERT INTO ecm_file給ecm66預設值'Y'
# Modify.........: No.CHI-B80096 11/09/02 By fengrui 對組成用量(ecm62)/底數(63)的預設值處理,計算標準產出量(ecm65)的值

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm RECORD
          yy LIKE type_file.num5,         #No.FUN-680122 smallint,
          mm LIKE type_file.num5          #No.FUN-680122 smallint
          END RECORD
 
DEFINE  g_row,g_col   LIKE type_file.num5          #No.FUN-680122 SMALLINT
#     DEFINEl_time  LIKE type_file.chr8            #No.FUN-6A0146
DEFINE  g_flag        LIKE type_file.num5          #No.FUN-680122 SMALLINT
DEFINE  g_change_lang LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   IF s_shut(0) THEN RETURN END IF
 
   INITIALIZE g_bgjob_msgfile TO NULL
   LET tm.yy   = ARG_VAL(1)
   LET tm.mm   = ARG_VAL(2)
   LET g_bgjob = ARG_VAL(3)
 
   IF cl_null(g_bgjob) THEN LET g_bgjob = 'N' END IF
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
 
#   CALL cl_used('axcp720',l_time,1) RETURNING l_time  #No.FUN-6A0146
#   CALL cl_used('axcp720',g_time,1) RETURNING g_time  #No.FUN-6A0146
    CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-B30211
    WHILE TRUE
      LET g_success = 'Y'
      LET g_change_lang = FALSE
      IF g_bgjob = 'N' THEN
         CALL p720_tm(0,0)
         IF cl_sure(20,20) THEN
            CALL cl_wait()
            BEGIN WORK	
            CALL axcp720()
            CALL s_showmsg()        #No.FUN-710027
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
               CLOSE WINDOW p720_w
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
         CLOSE WINDOW p720_w
      ELSE
         BEGIN WORK	
         CALL axcp720()
         CALL s_showmsg()        #No.FUN-710027 
         IF g_success = 'Y' THEN
            COMMIT WORK
         ELSE
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE
#   CALL cl_used('axcp720',l_time,2) RETURNING l_time  #No.FUN-6A0146
#   CALL cl_used('axcp720',g_time,2) RETURNING g_time  #No.FUN-6A0146
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
END MAIN
 
FUNCTION p720_tm(p_row,p_col)
   DEFINE   p_row,p_col   LIKE type_file.num5          #No.FUN-680122 SMALLINT
#     DEFINE   l_time   LIKE type_file.chr8            #No.FUN-6A0146
   DEFINE   lc_cmd        LIKE type_file.chr1000       #No.FUN-680122 VARCHAR(500)
 
   LET g_row = 5 LET g_col = 36
 
   OPEN WINDOW p720_w AT g_row,g_col WITH FORM "axc/42f/axcp720"  
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
   
   CALL cl_ui_init()
 
   CALL cl_opmsg('z')
 
   WHILE TRUE
      IF s_shut(0) THEN
         RETURN
      END IF
      CLEAR FORM 
      INITIALIZE tm.* TO NULL			# Default condition
      LET tm.yy = g_ccz.ccz01 
      LET tm.mm = g_ccz.ccz02
      LET g_bgjob = 'N'
 
      INPUT BY NAME tm.yy,tm.mm,g_bgjob WITHOUT DEFAULTS
 
      AFTER FIELD yy
         IF tm.yy IS NULL THEN
            NEXT FIELD yy
         END IF
 
      AFTER FIELD mm
         IF tm.mm IS NULL THEN
            NEXT FIELD mm 
         END IF
         IF tm.mm < 1 OR tm.mm > 12 THEN
            NEXT FIELD mm 
         END IF
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
 
 
      ON ACTION exit  #加離開功能genero
         LET INT_FLAG = 1
         EXIT INPUT
      ON ACTION locale #genero
         LET g_change_lang = TRUE
         EXIT INPUT
 
      BEFORE INPUT
         CALL cl_qbe_init()
 
      ON ACTION qbe_select
         CALL cl_qbe_select()
 
      ON ACTION qbe_save
         CALL cl_qbe_save()
 
      END INPUT
 
      IF g_change_lang THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         LET g_change_lang = FALSE
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0 
         CLOSE WINDOW p720_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO lc_cmd FROM zz_file WHERE zz01 = 'axcp720'
         IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
            CALL cl_err('axcp720','9031',1)
         ELSE
            LET lc_cmd = lc_cmd CLIPPED,
                         " '",tm.yy CLIPPED,"'",
                         " '",tm.mm CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'"
            CALL cl_cmdat('axcp720',g_time,lc_cmd CLIPPED)
         END IF
         CLOSE WINDOW p720_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF
      EXIT WHILE
   END WHILE
END FUNCTION
 
FUNCTION axcp720()
   DEFINE l_sql,l_where   STRING
   DEFINE l_sfb01    LIKE sfb_file.sfb01
   DEFINE l_sfb02    LIKE sfb_file.sfb02
   DEFINE l_sfb08    LIKE sfb_file.sfb08       #CHI-B80096--add--
   DEFINE l_ecm012   LIKE ecm_file.ecm012      #CHI-B80096--add--
   DEFINE l_n        LIKE type_file.num10      #CHI-B80096--add--
   DEFINE l_ins_sfb01 DYNAMIC ARRAY OF LIKE sfb_file.sfb01   #CHI-B80096--add--
   DEFINE l_sgm      RECORD LIKE sgm_file.*
   DEFINE l_ecm      RECORD LIKE ecm_file.*
   DEFINE l_cnt      LIKE type_file.num10      #No.FUN-680122 INTEGER
   DEFINE l_bdate    LIKE type_file.dat        #CHI-9A0021 add
   DEFINE l_edate    LIKE type_file.dat        #CHI-9A0021 add
   DEFINE l_correct  LIKE type_file.chr1       #CHI-9A0021 add
 
  #當月起始日與截止日
   CALL s_azm(tm.yy,tm.mm) RETURNING l_correct,l_bdate,l_edate          #CHI-9A0021 add

   LET l_where=#" WHERE YEAR(shb02)=",tm.yy,                            #CHI-9A0021
               #"   AND MONTH(shb02)=",tm.mm,                           #CHI-9A0021
               " WHERE shb02 BETWEEN '",l_bdate,"' AND '",l_edate,"'",  #CHI-9A0021
               "   AND shb05=sfb01",
               "   AND shbconf = 'Y' ",    #FUN-A70095
              #"   AND SUBSTRING(sfb01,1,",g_doc_len,")=smyslip",
               "   AND sfb01[1,",g_doc_len,"]=smyslip",    #No.FUN-9B0042
               "   AND smy58='Y'"
   
   LET l_sql="DELETE FROM ecm_file WHERE ecm01 IN ",
             "(SELECT DISTINCT sfb01 FROM sfb_file,smy_file,shb_file ",
             l_where,")"
   PREPARE p720_del_ecm FROM l_sql
   EXECUTE p720_del_ecm
   IF SQLCA.sqlcode THEN #不加入SQLerrd[3]=0 的判斷
      LET g_success='N'
      CALL cl_err("del",SQLCA.sqlcode,1)
      RETURN
   END IF
   #Check是否有資料被Lock導致未刪除
   LET l_n = 1 #CHI-B80096--add--
   LET l_cnt=0
   LET l_sql="SELECT COUNT(*) FROM ecm_file WHERE ecm01 IN ",
             "(SELECT DISTINCT sfb01 FROM sfb_file,smy_file,shb_file ",
             l_where,")"
   PREPARE axcp720_cnt_pre FROM l_sql
   DECLARE axcp720_cnt CURSOR FOR axcp720_cnt_pre
   OPEN axcp720_cnt
   FETCH axcp720_cnt INTO l_cnt
   IF l_cnt>0 THEN
      LET g_success='N'
      CALL cl_err("del",SQLCA.sqlcode,1)
      RETURN
   END IF
   CLOSE axcp720_cnt
   
   LET l_sql="SELECT DISTINCT sfb01,sfb02,sgm_file.* ",    
              "FROM sfb_file,smy_file,sgm_file,shb_file ",
              l_where,
              " AND sgm02=sfb01 ORDER BY sfb01,sgm01,sgm03"
   PREPARE axcp720_c_pre FROM l_sql
   DECLARE axcp720_c CURSOR FOR axcp720_c_pre
      CALL s_showmsg_init()   #No.FUN-710027  
      FOREACH axcp720_c INTO l_sfb01,l_sfb02,l_sgm.*     
      #No.FUN-710027--begin 
         IF g_success='N' THEN  
            LET g_totsuccess='N'  
            LET g_success="Y"   
         END IF 
      #No.FUN-710027--end
      IF SQLCA.sqlcode THEN
#        CALL cl_err3("sel","sfb_file",l_sfb01,l_sfb02,SQLCA.sqlcode,"","",1) #No.FUN-710027
         CALL s_errmsg('','','',SQLCA.sqlcode,1)              #No.FUN-710027
         LET g_success = 'N'                                  #No.FUN-8A0086
      END IF
      LET l_cnt=0 
      SELECT COUNT(*) INTO l_cnt FROM ecm_file
                                WHERE ecm01=l_sfb01
                                  AND ecm03=l_sgm.sgm03
      IF l_cnt=0 THEN
         INITIALIZE l_ecm.* TO NULL
         LET l_ecm.ecm01  = l_sfb01        #工單編號
         LET l_ecm.ecm02  = l_sfb02        #工單型態
         LET l_ecm.ecm03_par=l_sgm.sgm03_par   #料件編號
         LET l_ecm.ecm03  = l_sgm.sgm03    #製程序號
         LET l_ecm.ecm04  = l_sgm.sgm04    #作業編號
         LET l_ecm.ecm05  = l_sgm.sgm05    #機器編號
         LET l_ecm.ecm06  = l_sgm.sgm06    #工作中心編號
         LET l_ecm.ecm07  = l_sgm.sgm07    #最早起始前置時間調整 
         LET l_ecm.ecm08  = l_sgm.sgm08    #最遲起始前置時間調整 
         LET l_ecm.ecm09  = l_sgm.sgm09    #最早完工前置時間調整 
         LET l_ecm.ecm10  = l_sgm.sgm10    #最遲完工前置時間調整 
         LET l_ecm.ecm11  = l_sgm.sgm11    #製程編號             
         LET l_ecm.ecm12  = l_sgm.sgm12    #損耗率               
         LET l_ecm.ecm121 = l_sgm.sgm121   #盤點作業             
         LET l_ecm.ecm13  = l_sgm.sgm13    #標準人工設置時間     
         LET l_ecm.ecm14  = l_sgm.sgm14    #標準人工生產時間     
         LET l_ecm.ecm15  = l_sgm.sgm15    #標準機器設置時間     
         LET l_ecm.ecm16  = l_sgm.sgm16    #標準機器生產時間     
         LET l_ecm.ecm17  = l_sgm.sgm17    #標準廠外加工時間     
         LET l_ecm.ecm18  = l_sgm.sgm18    #標準等待時間         
         LET l_ecm.ecm19  = l_sgm.sgm19    #標準等待時間         
         LET l_ecm.ecm20  = l_sgm.sgm20    #實際人工生產時間     
         LET l_ecm.ecm21  = l_sgm.sgm21    #實際人工生產時間     
         LET l_ecm.ecm22  = l_sgm.sgm22    #實際機器設置時間     
         LET l_ecm.ecm23  = l_sgm.sgm23    #實際機器生產時間     
         LET l_ecm.ecm24  = l_sgm.sgm24    #實際廠外加工時間     
         #LET l_ecm.ecm25 =                #開工時間
         #LET l_ecm.ecm26 =                #完工時間
         #LET l_ecm.ecm27 =                #no use
         #LET l_ecm.ecm28 =                #no use
         LET l_ecm.ecm291 =l_sgm.sgm291   #Check in Qty
         LET l_ecm.ecm301 =l_sgm.sgm301   #良品轉入量       (+)
         LET l_ecm.ecm302 =l_sgm.sgm302   #重工轉入量       (+)
         LET l_ecm.ecm303 =l_sgm.sgm303   #工單轉入量       (+)
         LET l_ecm.ecm311 =l_sgm.sgm311   #良品轉出量       (-)
         LET l_ecm.ecm312 =l_sgm.sgm312   #重工轉出         (-)
         LET l_ecm.ecm313 =l_sgm.sgm313   #當站報廢量       (-)
         LET l_ecm.ecm314 =l_sgm.sgm314   #當站下線量(入庫) (-)
         LET l_ecm.ecm315 =l_sgm.sgm315   #Bonus Qty        (-)
         LET l_ecm.ecm321 =l_sgm.sgm321   #委外加工量          
         LET l_ecm.ecm322 =l_sgm.sgm322   #委外完工量          
         LET l_ecm.ecm34  =l_sgm.sgm34    #實際損耗率          
         LET l_ecm.ecm35  =l_sgm.sgm35    #C/R 比率            
         LET l_ecm.ecm36  =l_sgm.sgm36    #報廢平均人工分攤比率
         LET l_ecm.ecm37  =l_sgm.sgm37    #排程人工設置時間    
         LET l_ecm.ecm38  =l_sgm.sgm38    #排程人工生產時間    
         LET l_ecm.ecm39  =l_sgm.sgm39    #排程廠外加工時間    
         LET l_ecm.ecm40  =l_sgm.sgm40    #人工數目            
         LET l_ecm.ecm41  =l_sgm.sgm41    #機器數目            
         LET l_ecm.ecm42  =l_sgm.sgm42    #作業重疊程度        
         LET l_ecm.ecm43  =l_sgm.sgm43    #成本計算基準        
         LET l_ecm.ecm45  =l_sgm.sgm45    #作業名稱            
         LET l_ecm.ecm49  =l_sgm.sgm49    #單位人力            
         LET l_ecm.ecm50  =l_sgm.sgm50    #製程開工日          
         LET l_ecm.ecm51  =l_sgm.sgm51    #製程完工日          
         LET l_ecm.ecm52  =l_sgm.sgm52    #委外否              
         LET l_ecm.ecm53  =l_sgm.sgm53    #PQC 否              
         LET l_ecm.ecm54  =l_sgm.sgm54    #Check in 否
         LET l_ecm.ecm55  =l_sgm.sgm55    #Check in 留置碼
         LET l_ecm.ecm56  =l_sgm.sgm56    #Check out 留置碼
         LET l_ecm.ecm57  =l_sgm.sgm57    #轉入單位
         LET l_ecm.ecm58  =l_sgm.sgm58    #轉出單位
         LET l_ecm.ecm59  =l_sgm.sgm59    #單位轉換率
         LET l_ecm.ecm62  =l_sgm.sgm62    #CHI-B80096--add--
         LET l_ecm.ecm63  =l_sgm.sgm63    #CHI-B80096--add--
         LET l_ecm.ecm65  = 0             #CHI-B80096--add--
         LET l_ecm.ecmacti=l_sgm.sgmacti  #資料有效碼
         LET l_ecm.ecmuser=l_sgm.sgmuser  #資料所有者
         LET l_ecm.ecmgrup=l_sgm.sgmgrup  #資料所有群
         LET l_ecm.ecmmodu=l_sgm.sgmmodu  #資料更改者
         LET l_ecm.ecmdate=l_sgm.sgmdate  #最近修改日
 
         LET l_ecm.ecm316 =0              #工單轉出量       (-)
         LET l_ecm.ecmplant = g_plant  #FUN-980009 add 
         LET l_ecm.ecmlegal = g_legal  #FUN-980009 add 
         LET l_ecm.ecmoriu = g_user      #No.FUN-980030 10/01/04
         LET l_ecm.ecmorig = g_grup      #No.FUN-980030 10/01/04
         LET l_ecm.ecm012= l_sgm.sgm012           #FUN-A60076 add by huangtao
         IF cl_null(l_ecm.ecm66) THEN LET l_ecm.ecm66 = 'Y' END IF #TQC-B80022      
         IF cl_null(l_ecm.ecm62) OR l_ecm.ecm62 = 0 THEN LET l_ecm.ecm62 = 1 END IF #CHI-B80096--add--
         IF cl_null(l_ecm.ecm63) OR l_ecm.ecm63 = 0 THEN LET l_ecm.ecm63 = 1 END IF #CHI-B80096--add--
         INSERT INTO ecm_file VALUES (l_ecm.*)
         IF SQLCA.SQLCODE THEN
#           CALL cl_err3("ins","ecm_file",l_ecm.ecm01,l_ecm.ecm03,SQLCA.SQLCODE,"","",1)  #No.FUN-710027
            CALL s_errmsg('','','',SQLCA.SQLCODE,1) #No.FUN-710027   
            LET g_success='N'
#           EXIT FOREACH       #No.FUN-710027
            CONTINUE FOREACH   #No.FUN-710027
         #CHI-B80096--add--Begin--
         ELSE 
            IF l_n = 1 THEN 
               LET l_ins_sfb01[l_n] = l_sfb01 
               LET l_n =l_n + 1
            ELSE 
               IF l_ins_sfb01[l_n-1] != l_sfb01 THEN
                  LET l_ins_sfb01[l_n] = l_sfb01
                  LET l_n =l_n + 1
               END IF 
            END IF 
         #CHI-B80096--add---End---
         END IF
      ELSE
#         LET l_ecm.ecm012= ' '           #FUN-A60076 add by huangtao
         UPDATE ecm_file SET ecm291=ecm291+l_sgm.sgm291,
                             ecm301=ecm301+l_sgm.sgm301,
                             ecm302=ecm302+l_sgm.sgm302,
                             ecm303=ecm303+l_sgm.sgm303,
                             ecm311=ecm311+l_sgm.sgm311,
                             ecm312=ecm312+l_sgm.sgm312,
                             ecm313=ecm313+l_sgm.sgm313,
                             ecm314=ecm314+l_sgm.sgm314,
                             ecm315=ecm315+l_sgm.sgm315,
                             ecm321=ecm321+l_sgm.sgm321,
                             ecm322=ecm322+l_sgm.sgm322
                       WHERE ecm01=l_sfb01
                         AND ecm03=l_sgm.sgm03
                         AND ecm012= l_sgm.sgm012   #FUN-A60076 add by huangtao
         IF SQLCA.SQLCODE OR (SQLCA.sqlerrd[3]=0) THEN
#           CALL cl_err3("upd","ecm_file",l_ecm.ecm01,l_sgm.sgm03,SQLCA.SQLCODE,"","",1)  #No.FUN-710027
            LET g_showmsg=l_sfb01,"/",l_sgm.sgm03                       #No.FUN-710027             
            CALL s_errmsg('ecm01,ecm03',g_showmsg,'',SQLCA.SQLCODE,1)   #No.FUN-710027 
            LET g_success='N'
#           EXIT FOREACH        #No.FUN-710027
            CONTINUE FOREACH    #No.FUN-710027
         END IF
      END IF
   END FOREACH
   #CHI-B80096--add--Begin--
   FOR l_n = 1 TO l_ins_sfb01.getlength()
      LET l_ecm012= ' '
      LET l_sfb08 = ' '
      SELECT DISTINCT sfb08 INTO l_sfb08 FROM sfb_file 
       WHERE sfb01 = l_ins_sfb01[l_n]
       
      DECLARE axcp720_ecm012_cs CURSOR FOR 
       SELECT DISTINCT ecm012 FROM ecm_file
        WHERE ecm01= l_ins_sfb01[l_n]
          AND (ecm015 IS NULL OR ecm015=' ')
      FOREACH axcp720_ecm012_cs INTO l_ecm012 
         EXIT FOREACH
      END FOREACH
      
      CALL s_schdat_output(l_ecm012,l_sfb08,l_ins_sfb01[l_n])
   END FOR 
   #CHI-B80096--add---End---
#No.FUN-710027--begin 
   IF g_totsuccess="N" THEN
      LET g_success="N"
   END IF 
#No.FUN-710027--end
END FUNCTION
 
{
REPORT p720_rep1(p_shi,p_shb) 
  DEFINE p_shi  RECORD  LIKE shi_file.*,
         p_shb  RECORD LIKE shb_file.*,
         l_cag  RECORD LIKE cag_file.*,
         shi05_sum  LIKE shi_file.shi05  
 
  ORDER BY p_shi.shi02,p_shi.shi04  
  FORMAT 
     AFTER GROUP OF p_shi.shi04 
        LET shi05_sum=GROUP SUM(p_shi.shi05)
        LET l_cag.cag01=p_shi.shi02  #轉入工單編號
        LET l_cag.cag02=tm.yy 
        LET l_cag.cag03=tm.mm
        LET l_cag.cag04=p_shb.shb10 #料號
        LET l_cag.cag05=p_shi.shi04 #轉入工單之製程序
        LET l_cag.cag06=p_shi.shi03 #轉入工單之作業編號
        LET l_cag.cag11=p_shb.shb05 #轉出工單編號
        LET l_cag.cag15=p_shb.shb06 #轉出工單之製程序
        LET l_cag.cag16=p_shb.shb081 #轉出工單之作業編號
        LET l_cag.cag20=shi05_sum #工單轉入量
        LET l_cag.cagdate=p_shb.shb03 #首次報工日 
        LET l_cag.cagplant=g_plant  #FUN-980009 add
        LET l_cag.caglegal=g_legal  #FUN-980009 add
        INSERT INTO cag_file VALUES(l_cag.*) 
        ##NO.TQC-790100 START--------------------------
        ##IF STATUS<0 AND STATUS !=-239 THEN 
        IF SQLCA.SQLCODE AND (NOT cl_sql_dup_value(SQLCA.SQLCODE)) THEN
        ##NO.TQC-790100 END----------------------------
          CALL cl_err('INS cag error',STATUS,1) LET g_success='N' 
        END IF 
END REPORT 
}
 
 
 
{
REPORT p720_rep2(p_shd,p_shb) 
  DEFINE p_shd  RECORD  LIKE shd_file.*,
         p_shb  RECORD LIKE shb_file.*,
         l_cah  RECORD LIKE cah_file.*,
         shi05_sum  LIKE shi_file.shi05  
 
  ORDER BY p_shb.shb05,p_shd.shd06
  FORMAT 
    ON EVERY ROW
        IF p_shd.shd07 IS NULL THEN LET p_shd.shd07=0 END IF 
        IF p_shd.shd08 IS NULL THEN LET p_shd.shd08=0 END IF 
        IF p_shd.shd09 IS NULL THEN LET p_shd.shd09=0 END IF 
        LET l_cah.cah01=p_shb.shb05   #工單編號
        LET l_cah.cah02=tm.yy
        LET l_cah.cah03=tm.mm
        LET l_cah.cah04=p_shd.shd06   #料號
        LET l_cah.cah05=p_shb.shb06   #製程序
        LET l_cah.cah06=p_shb.shb081  #作業編號
        LET l_cah.cah07=p_shd.shd07   #數量
        LET l_cah.cah08=p_shd.shd09   #金額
        LET l_cah.cah08a=0  #下線材料成本
        LET l_cah.cah08b=0  #下線人工成本
        LET l_cah.cah08c=0  #下線製造費用
        LET l_cah.cah08d=0  #下線加工成本
        LET l_cah.cah08e=0  #下線其它成本
        LET l_cah.cahplant=g_plant #FUN-980009 add
        LET l_cah.cahlegal=g_legal #FUN-980009 add
        INSERT INTO cah_file VALUES(l_cah.*) 
        IF STATUS THEN CALL cl_err('INS cah error',STATUS,1) 
          LET g_success='N' 
        END IF 
END REPORT 
}
