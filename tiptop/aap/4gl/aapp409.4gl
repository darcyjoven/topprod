# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aapp409.4gl
# Descriptions...: AP系統傳票拋轉還原
# Date & Author..: 97/04/20 By Roger
# Modify.........: 97/04/16 By Danny (將apc_file改成npp_file)
# Modify.........: No.FUN-560099 05/06/20 By Smapmin 單號長度不足
# Modify.........: MOD-570223 05/07/19 By Yiting 傳票還原時,應判斷AP系統關帳日
# Modify.........: MOD-590081 05/09/20 By Smapmin 取消call s_abhmod()
# Modify.........: NO.MOD-5B0192 05/11/28 BY yiting 應付傳票拋轉還原作業,若使用>其應付票據不需要先有傳票時,則會造成無法還原
# Modify.........: No.FUN-570112 06/02/23 By yiting 批次背景執行
# Modify.........: No.MOD-630092 06/03/24 By Smapmin 修正MOD-5B0192
# Modify.........: No.MOD-640404 06/04/11 By Smapmin 傳票拋轉還原時,將該傳票所對應到的付款單號之異動記錄的傳票單號與日期清空
# Modify.........: No.FUN-660122 06/06/16 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-660117 06/06/21 By Rainy Char改為 Like
# Modify.........: No.FUN-660141 06/07/07 By day  帳別權限修改
# Modify.........: No.FUN-680029 06/08/22 By Rayven 新增多帳套功能
# Modify.........: No.FUN-690028 06/09/12 By flowld 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0055 06/10/25 By douzh l_time轉g_time
# Modify.........: No.MOD-6B0075 06/11/14 By xufeng 將還原時關帳日多余的判斷去掉
# Modify.........: No.CHI-780008 07/08/13 By Smapmin 還原MOD-590081
# Modify.........: No.FUN-840204 08/05/03 By ve007 已拋轉傳票，其中一張傳票已確認，執行拋轉傳票還原后，增加不能拋轉還原的提示信息
# Modify.........: No.MOD-930242 09/03/26 By Sarah aapp409會回寫nmf_file,也皆需同步回寫nmd_file
# Modify.........: No.FUN-980001 09/08/04 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980020 09/08/31 By douzh GP5.2架構重整，修改sub相關傳參
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-990033 09/09/02 By Sarah 需先判斷nmz05='Y'才檢查aap-998訊息
# Modify.........: No:MOD-990182 09/10/19 By sabrina 單據已做過付款沖帳則不可還原 
# Modify.........: No.FUN-990031 09/10/23 By lutingtingGP5.2財務營運中心欄位調整,營運中心要控制在同一法人下 
# Modify.........: No:MOD-9B0179 09/11/26 By Sarah 修正MOD-990182,WHERE條件加上apf00='33'
# Modify.........: No:CHI-A20014 10/02/25 By sabrina 送簽中或已核准不可還原
# Modify.........: No.FUN-A50102 10/06/01 By lutingting 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:MOD-A80246 10/09/01 By Dido 若已有產生至 amdi100 則不可還原 
# Modify.........: No:MOD-A90070 10/09/09 By Dido 立沖為同張傳票則可予已還原
# Modify.........: No:MOD-B20015 11/02/09 By wujie 检查g_existno时区分帐套
# Modify.........: No:FUN-B30211 11/03/30 By yangtingting 未加離開前的 cl_used(2)
# Modify.........: No.FUN-B50090 11/05/16 By suncx 財務關帳日期加嚴控管修正
# Modify.........: No.FUN-B40056 11/06/03 By guoch 刪除資料時一併刪除tic_file的資料
# Modify.........: No:CHI-B60058 11/06/30 By Sarah 若g_bgjob='Y'時使用彙總訊息方式呈現
# Modify.........: No:TQC-B90199 11/09/27 By yinhy 延續 EXT-B90098 處理,將相關使用到錯誤訊息 agl-910 判斷部分
# Modify.........: No:MOD-C20146 12/02/20 By Polly 傳票還原刪除tic_file，時，先判斷是否有tic_file資料
# Modify.........: No.FUN-C70093 12/07/23 By minpp 成本分摊抛转还原且aqa00='2'时，抛转还原后回写ccbglno=NULL
# Modify.........: No:MOD-CB0026 12/12/21 By yinhy 背景作業拋轉憑證時先檢查營運中心是否在當前法人下
# Modify.........: No.FUN-CB0096 13/01/10 by zhangweib 增加log檔記錄程序運行過程
# Modify.........: No.FUN-D40105 13/08/22 by yangtt 憑證編號開窗可多選
# Modify.........: No.TQC-D60072 13/08/22 by yangtt 報錯訊息要有憑證編號
# Modify.........: No:MOD-G30031 16/03/09 By doris 1.輸入時,傳票編號不允許打*號

 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_wc,g_sql   string  #No.FUN-580092 HCN
DEFINE g_dbs_gl     LIKE type_file.chr21  # No.FUN-690028 VARCHAR(21)
#DEFINE p_plant      VARCHAR(12)            #FUN-660117 remark
DEFINE p_plant      LIKE azp_file.azp01  #FUN-660117
# Prog. Version..: '5.30.06-13.03.12(02)            #FUN-660117 remark
DEFINE p_acc        LIKE apz_file.apz02b #FUN-660117
DEFINE p_acc1       LIKE apz_file.apz02c #No.FUN-680029
DEFINE gl_date      LIKE type_file.dat     #No.FUN-690028 DATE
DEFINE gl_yy,gl_mm  LIKE type_file.num5    #No.FUN-690028 SMALLINT
DEFINE g_existno    LIKE npp_file.nppglno     #FUN-660117    
DEFINE g_existno1   LIKE npp_file.nppglno     #No.FUN-680029 
DEFINE g_str        LIKE type_file.chr3    #No.FUN-690028 VARCHAR(3)
DEFINE g_mxno       LIKE type_file.chr8    #No.FUN-690028 VARCHAR(8)
DEFINE i            LIKE type_file.num10   #No.FUN-690028 INTEGER
DEFINE g_aaz84      LIKE aaz_file.aaz84 #還原方式 1.刪除 2.作廢 no.4868
DEFINE g_cnt           LIKE type_file.num10      #No.FUN-690028 INTEGER
DEFINE g_msg           LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(72)
DEFINE g_change_lang   LIKE type_file.chr1                  #是否有做語言切換 No.FUN-57011  #No.FUN-690028 VARCHAR(1)
#No.FUN-CB0096 ---start--- Add
DEFINE g_id     LIKE azu_file.azu00
DEFINE l_id     STRING
DEFINE l_time   LIKE type_file.chr8
#No.FUN-CB0096 ---end  --- Add
#FUN-D40105--add--str--
DEFINE l_time_t LIKE type_file.chr8
DEFINE g_existno_str     STRING
DEFINE bst base.StringTokenizer
DEFINE temptext STRING
DEFINE l_errno LIKE type_file.num10
DEFINE g_existno1_str STRING
DEFINE tm   RECORD
            wc1         STRING
            END RECORD
#FUN-D40105--add--end--
 
MAIN
   DEFINE l_flag      LIKE type_file.chr1    #No.FUN-570112  #No.FUN-690028 VARCHAR(1)
   DEFINE l_npp       RECORD LIKE npp_file.*      
   DEFINE l_cnt       LIKE type_file.num5                #No.FUN-690028 SMALLINT
   DEFINE l_abapost   LIKE type_file.chr1     #NO.FUN-690028 VARCHAR(1)
   DEFINE l_aba19     LIKE aba_file.aba19 
   DEFINE l_abaacti   LIKE aba_file.abaacti
   DEFINE l_aba00     LIKE aba_file.aba00 
   DEFINE l_aaa07     LIKE aaa_file.aaa07 
   DEFINE l_npp00     LIKE npp_file.npp00 
   DEFINE l_npp01     LIKE npp_file.npp01
   DEFINE l_npp07     LIKE npp_file.npp07     
   DEFINE l_nppglno   LIKE npp_file.nppglno  
#No.FUN-680029--end
   DEFINE l_cnt1      LIKE type_file.num5       #MOD-990182 add
   DEFINE l_aba20     LIKE aba_file.aba20       #CHI-A20014 add 
 
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
 
#->No.FUN-570112 --start--
   INITIALIZE g_bgjob_msgfile TO NULL
   LET p_plant   = ARG_VAL(1)           #總帳營運中心編號
   LET p_acc     = ARG_VAL(2)           #總帳帳別編號
   LET g_existno = ARG_VAL(3)           #原總帳傳票編號
   LET g_bgjob   = ARG_VAL(4)           #背景作業
 
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
#->No.FUN-570112 ---end---
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AAP")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time    #No.FUN-6A0055
   #No.FUN-CB0096 ---start--- Add
    LET l_time = TIME
    LET l_time_t = l_time   #FUN-D40105  add
    LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
    LET l_id = g_plant CLIPPED , g_prog CLIPPED , '100' , g_user CLIPPED , g_today USING 'YYYYMMDD' , l_time
    LET g_sql = "SELECT azu00 + 1 FROM azu_file ",
                " WHERE azu00 LIKE '",l_id,"%' "
    PREPARE aglt110_sel_azu FROM g_sql
    EXECUTE aglt110_sel_azu INTO g_id
    IF cl_null(g_id) THEN
       LET g_id = l_id,'000000'
    ELSE
       LET g_id = g_id + 1
    END IF
    CALL s_log_data('I','100',g_id,'1',l_time,'','')
   #No.FUN-CB0096 ---end  --- Add

   WHILE TRUE
      CALL s_showmsg_init()   #CHI-B60058 add
      IF g_bgjob = "N" THEN
         CALL p409_ask()
         #FUN-D40105--add--str--
         IF tm.wc1 = " 1=1" THEN
            CALL cl_err('','9033',0)
            CONTINUE WHILE
         END IF
         #FUN-D40105--add--end--
         IF cl_sure(18,20) THEN
            LET g_success = 'Y'
            BEGIN WORK
            #FUN-D40105--add--str--
            CALL p409_existno_chk()
            IF g_success = 'N' THEN
                CALL s_showmsg()
                CONTINUE WHILE
            END IF
            #FUN-D40105--add--end--
            CALL p409()
            CALL s_showmsg()   #CHI-B60058 add
            IF g_success = 'Y' THEN
               COMMIT WORK
               CALL cl_end2(1) RETURNING l_flag
            ELSE
               ROLLBACK WORK
               CALL cl_end2(2) RETURNING l_flag
            END IF
            IF l_flag THEN
               CONTINUE WHILE
            ELSE
               CLOSE WINDOW p409
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
         CLOSE WINDOW p409
      ELSE
         LET g_success = 'Y'
#No.FUN-680029--begin
        #FUN-A50102--mark--str--
        #LET g_plant_new=p_plant
        #CALL s_getdbs()
        #LET g_dbs_gl=g_dbs_new
        #FUN-A50102--mark--end
         #No.MOD-CB0026  --Begin
         SELECT * FROM azw_file WHERE azw01 = p_plant
            AND azw02 = g_legal
         IF STATUS <> 0 THEN
                  LET g_success = 'N'
           #CALL cl_err('sel_azw','agl-171',1)            #FUN-D40105 mark
            CALL s_errmsg('sel_azw','','','agl-171',1)    #FUN-D40105 add
            RETURN
         END IF
         #No.MOD-CB0026  --End

         LET tm.wc1 = "g_existno IN ('",g_existno,"')"  #FUN-D40105  add
         CALL p409_existno_chk()  #FUN-D40105  add

        #FUN-D40105--mark--end--
        #LET g_sql="SELECT aba00,aba02,aba03,aba04,abapost,aba19,abaacti,aba20 FROM ",    #CHI-A20014 add aba20
        #          #g_dbs_gl,"aba_file",   #FUN-A50102
        #           cl_get_target_table(p_plant,'aba_file'),    #FUN-A50102
        #          " WHERE aba01 = ? AND aba00 = ? AND aba06='AP'" CLIPPED
        #CALL cl_replace_sqldb(g_sql) RETURNING g_sql           #FUN-A50102
        #CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql   #FUN-A50102
        #PREPARE p409_t_p0 FROM g_sql
        #DECLARE p409_t_c0 CURSOR FOR p409_t_p0
        #IF STATUS THEN
        #  #str CHI-B60058 mod
        #  #CALL cl_err('decl aba_cursor:',STATUS,0)
        #   IF g_bgjob = 'Y' THEN
        #      CALL s_errmsg('','','decl aba_cursor:',STATUS,1)
        #   ELSE
        #      CALL cl_err('decl aba_cursor:',STATUS,0)
        #   END IF
        #  #end CHI-B60058 mod
        #   LET g_success ='N'
        #  #RETURN   #CHI-B60058 mark
        #END IF
        #OPEN p409_t_c0 USING g_existno,p_acc
        #FETCH p409_t_c0 INTO l_aba00,gl_date,gl_yy,gl_mm,l_abapost,l_aba19,
        #                     l_abaacti,l_aba20       #CHI-A20014 add l_aba20 
        #IF STATUS THEN
        #  #str CHI-B60058 mod
        #  #CALL cl_err('sel aba:',STATUS,0) 
        #   IF g_bgjob = 'Y' THEN
        #      CALL s_errmsg('','','sel aba:',STATUS,1)
        #   ELSE
        #      CALL cl_err('sel aba:',STATUS,0) 
        #   END IF
        #  #end CHI-B60058 mod
        #   LET g_success ='N'
        #  #RETURN   #CHI-B60058 mark
        #END IF
        #IF l_abaacti = 'N' THEN
        #  #str CHI-B60058 mod
        #  #CALL cl_err('','mfg8001',1)
        #   IF g_bgjob = 'Y' THEN
        #      CALL s_errmsg('','','','mfg8001',1)
        #   ELSE
        #      CALL cl_err('','mfg8001',1)
        #   END IF
        #  #end CHI-B60058 mod
        #   LET g_success ='N'
        #  #RETURN   #CHI-B60058 mark
        #END IF
       ##CHI-A20014---add---start---
        #IF l_aba20 MATCHES '[Ss1]' THEN
        #  #str CHI-B60058 mod
        #  #CALL cl_err('','mfg3557',1)
        #   IF g_bgjob = 'Y' THEN
        #      CALL s_errmsg('','','','mfg3557',1)
        #   ELSE
        #      CALL cl_err('','mfg3557',1)
        #   END IF
        #  #end CHI-B60058 mod
        #   LET g_success = 'N'
        #  #RETURN   #CHI-B60058 mark
        #END IF
       ##CHI-A20014---add---end---
       ##---增加判斷會計帳別之關帳日期
       ##LET g_sql="SELECT aaa07 FROM ",g_dbs_gl,"aaa_file", " WHERE aaa01= ?"   #FUN-A50102
        #LET g_sql="SELECT aaa07 FROM ",cl_get_target_table(p_plant,'aaa_file')  #FUN-A50102
 	#CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
        #CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql   #FUN-A50102
        #PREPARE p409_x_gl_p0 FROM g_sql
        #DECLARE p409_c_gl_p0 CURSOR FOR p409_x_gl_p0
        #OPEN p409_c_gl_p0 USING l_aba00
        #FETCH p409_c_gl_p0 INTO l_aaa07
        #IF gl_date <= l_aaa07 THEN
        #  #str CHI-B60058 mod
        #  #CALL cl_err(gl_date,'agl-200',0) 
        #   IF g_bgjob = 'Y' THEN
        #      CALL s_errmsg('','',gl_date,'agl-200',1)
        #   ELSE
        #      CALL cl_err(gl_date,'agl-200',0) 
        #   END IF
        #  #end CHI-B60058 mod
        #   LET g_success ='N'
        #  #RETURN   #CHI-B60058 mark
        #END IF
        #------ end -------------------
#MOD-6B0075   --Begin
        #傳票日期小於系統之關帳日,不可還原
#        #IF gl_date < g_sma.sma53 THEN      
#         IF gl_date < g_apz.apz57 THEN   #MOD-570223
#           CALL cl_err('','aap-027',0) 
#           LET g_success ='N'
#           RETURN
#        END IF                                      
#MOD-6B0075  --End
        #IF l_abapost = 'Y' THEN
        #  #str CHI-B60058 mod
        #  #CALL cl_err(g_existno,'aap-130',0)
        #   IF g_bgjob = 'Y' THEN
        #      CALL s_errmsg('','',g_existno,'aap-130',1)
        #   ELSE
        #      CALL cl_err(g_existno,'aap-130',0)
        #   END IF
        #  #end CHI-B60058 mod
        #   LET g_success ='N'
        #  #RETURN   #CHI-B60058 mark
        #END IF
        ##Modi:已確認傳票不能做還原
        #IF l_aba19 ='Y' THEN 
        #  #str CHI-B60058 mod
        #  #CALL cl_err(g_existno,'aap-026',0)
        #   IF g_bgjob = 'Y' THEN
        #      CALL s_errmsg('','',g_existno,'aap-026',1)
        #   ELSE
        #      CALL cl_err(g_existno,'aap-026',0)
        #   END IF
        #  #end CHI-B60058 mod
        #   LET g_success ='N'
        #  #RETURN   #CHI-B60058 mark
        #END IF   
       ##-MOD-A80246-add-  
        #LET l_cnt = 0
        #SELECT COUNT(*) INTO l_cnt 
        #  FROM amd_file
        # WHERE amd28 = g_existno
        #IF l_cnt > 0 THEN
        #  #str CHI-B60058 mod
        #  #CALL cl_err(g_existno,'amd-030',0)
        #   IF g_bgjob = 'Y' THEN
        #      CALL s_errmsg('','',g_existno,'amd-030',1)
        #   ELSE
        #      CALL cl_err(g_existno,'amd-030',0)
        #   END IF
        #  #end CHI-B60058 mod
        #   LET g_success ='N'
        #  #RETURN   #CHI-B60058 mark
        #END IF 
       ##-MOD-A80246-end-  
        ##若為付款單之傳票，付款類別為支票時，
        ##已開票則不可還原 no.5039 02/06/04
        #LET l_cnt = 0 
        #DECLARE npp00_cs3 CURSOR FOR          #改成多筆處理 
        #   SELECT npp00,npp01 FROM npp_file 
        #   WHERE nppsys='AP' AND npp011 = 1 AND nppglno = g_existno AND npptype ='0'  #No.MOD-B20015
        #FOREACH npp00_cs3 INTO l_npp00,l_npp01 
        #   IF STATUS THEN 
        #     #str CHI-B60058 mod
        #     #CALL cl_err('foreach:npp00_cs',STATUS,1)    
        #      IF g_bgjob = 'Y' THEN
        #         CALL s_errmsg('','','foreach:npp00_cs',STATUS,1)
        #      ELSE
        #         CALL cl_err('foreach:npp00_cs',STATUS,1)    
        #      END IF
        #     #end CHI-B60058 mod
        #      EXIT FOREACH 
        #   ELSE 
        #      IF l_npp00 = '3' AND g_nmz.nmz05 = 'Y' THEN   #MOD-990033 add
        #         SELECT COUNT(*) INTO g_cnt FROM aph_file 
        #            WHERE aph01 = l_npp01 
        #            AND aph03 = '1' #支票 
        #            AND aph09 = 'Y' #已開票 
        #         IF g_cnt > 0 THEN 
        #           #str CHI-B60058 mod
        #           #CALL cl_err('','aap-998',1)    
        #            IF g_bgjob = 'Y' THEN
        #               CALL s_errmsg('','','','aap-998',1)
        #            ELSE
        #               CALL cl_err('','aap-998',1)
        #            END IF
        #           #end CHI-B60058 mod
        #            LET l_cnt = l_cnt + 1
        #            EXIT FOREACH
        #         END IF 
        #      END IF   #MOD-990033 add
        #     #MOD-990182---add---start---
        #     #單據若已做付款沖帳，則不可還原
        #      LET l_cnt = 0   LET l_cnt1 = 0
        #      SELECT COUNT(*) INTO l_cnt FROM apg_file,apf_file
        #       WHERE apg04 = l_npp01 AND apf01 = apg01 
        #         AND apf41 != 'X' 
        #         AND apf00  = '33'  #MOD-9B0179 add
        #         AND apf44 != g_existno                           #MOD-A90070
        #      SELECT COUNT(*) INTO l_cnt1 FROM aph_file,apf_file
        #       WHERE aph04 = l_npp01 AND apf01 = aph01 
        #         AND apf41 != 'X' 
        #         AND apf00  = '33'  #MOD-9B0179 add
        #         AND apf44 != g_existno                           #MOD-A90070
        #      #IF l_cnt + l_cnt1 > 0 THEN                         #TQC-B90199
        #      IF l_cnt + l_cnt1 > 0  AND g_apz.apz06 = 'N' THEN   #TQC-B90199
        #        #str CHI-B60058 mod
        #        #CALL cl_err('','agl-910',1)
        #         IF g_bgjob = 'Y' THEN
        #            CALL s_errmsg('','','','agl-910',1)
        #         ELSE
        #            CALL cl_err('','agl-910',1)
        #         END IF
        #        #end CHI-B60058 mod
        #         EXIT FOREACH
        #      END IF
        #     #MOD-990182---add---end---
        #   END IF 
        #END FOREACH 
        #IF l_cnt > 0 THEN 
        #   LET g_success ='N'
        #   RETURN
        #END IF
        # #no.5039(end)
        #IF g_aza.aza63 = 'Y' THEN
        #   SELECT UNIQUE npp07,nppglno INTO l_npp07,l_nppglno
        #      FROM npp_file
        #      WHERE npp01 IN (SELECT npp01 FROM npp_file WHERE npp07 = p_acc AND nppglno = g_existno AND npptype = '0')
        #      AND npptype = '1'
        #   IF cl_null(l_npp07) OR cl_null(l_nppglno) THEN
        #     #str CHI-B60058 mod
        #     #CALL cl_err('','aap-986',1)
        #      IF g_bgjob = 'Y' THEN
        #         CALL s_errmsg('','','','aap-986',1)
        #      ELSE
        #         CALL cl_err('','aap-986',1)
        #      END IF
        #     #end CHI-B60058 mod
        #      LET g_success ='N'
        #     #RETURN   #CHI-B60058 mark
        #   END IF
        #   OPEN p409_t_c0 USING l_nppglno,g_apz.apz02c
        #   FETCH p409_t_c0 INTO l_aba00,gl_date,gl_yy,gl_mm,l_abapost,l_aba19,
        #                        l_abaacti,l_aba20      #CHI-A20014 add l_aba20
        #   IF STATUS THEN
        #     #str CHI-B60058 mod
        #     #CALL cl_err('sel aba:',STATUS,0) 
        #      IF g_bgjob = 'Y' THEN
        #         CALL s_errmsg('','','sel aba:',STATUS,1)
        #      ELSE
        #         CALL cl_err('sel aba:',STATUS,0) 
        #      END IF
        #     #end CHI-B60058 mod
        #      LET g_success ='N'
        #     #RETURN   #CHI-B60058 mark
        #   END IF
        #   IF l_abaacti = 'N' THEN
        #     #str CHI-B60058 mod
        #     #CALL cl_err('','mfg8003',1)
        #      IF g_bgjob = 'Y' THEN
        #         CALL s_errmsg('','','','mfg8003',1)
        #      ELSE
        #         CALL cl_err('','mfg8003',1)
        #      END IF
        #     #end CHI-B60058 mod
        #      LET g_success ='N'
        #     #RETURN   #CHI-B60058 mark
        #   END IF
        #  #CHI-A20014---add---start---
        #   IF l_aba20 MATCHES '[Ss1]' THEN
        #     #str CHI-B60058 mod
        #     #CALL cl_err('','mfg3557',1)
        #      IF g_bgjob = 'Y' THEN
        #         CALL s_errmsg('','','','mfg3557',1)
        #      ELSE
        #         CALL cl_err('','mfg3557',1)
        #      END IF
        #     #end CHI-B60058 mod
        #      LET g_success ='N'
        #     #RETURN   #CHI-B60058 mark
        #   END IF
        #  #CHI-A20014---add---end---
        #   OPEN p409_c_gl_p0 USING l_aba00
        #   FETCH p409_c_gl_p0 INTO l_aaa07
        #   IF gl_date <= l_aaa07 THEN
        #     #str CHI-B60058 mod
        #     #CALL cl_err(gl_date,'agl-200',0) 
        #      IF g_bgjob = 'Y' THEN
        #         CALL s_errmsg('','',gl_date,'agl-200',1)
        #      ELSE
        #         CALL cl_err(gl_date,'agl-200',0) 
        #      END IF
        #     #end CHI-B60058 mod
        #      LET g_success ='N'
        #     #RETURN   #CHI-B60058 mark
        #   END IF
        ##FUN-B50090 add begin-------------------------
        ##重新抓取關帳日期
        #   LET g_sql ="SELECT apz57 FROM apz_file ",
        #              " WHERE apz00 = '0'"
        #   PREPARE t600_apz57_p1 FROM g_sql
        #   EXECUTE t600_apz57_p1 INTO g_apz.apz57
        ##FUN-B50090 add -end--------------------------
        #   IF gl_date < g_apz.apz57 THEN
        #     #str CHI-B60058 mod
        #     #CALL cl_err('','aap-027',0) 
        #      IF g_bgjob = 'Y' THEN
        #         CALL s_errmsg('','','','aap-027',1)
        #      ELSE
        #         CALL cl_err('','aap-027',0) 
        #      END IF
        #     #end CHI-B60058 mod
        #      LET g_success ='N'
        #     #RETURN   #CHI-B60058 mark
        #   END IF 
        #   IF l_abapost = 'Y' THEN
        #     #str CHI-B60058 mod
        #     #CALL cl_err(l_nppglno,'aap-132',0)
        #      IF g_bgjob = 'Y' THEN
        #         CALL s_errmsg('','',l_nppglno,'aap-132',1)
        #      ELSE
        #         CALL cl_err(l_nppglno,'aap-132',0)
        #      END IF
        #     #end CHI-B60058 mod
        #      LET g_success ='N'
        #     #RETURN   #CHI-B60058 mark
        #   END IF
        #   IF l_aba19 ='Y' THEN 
        #    # CALL cl_err(l_nppglno,'anm-116',0) 
        #     #str CHI-B60058 mod
        #     #CALL cl_err(l_nppglno,'anm-116',1)        #No.FUN-840204
        #      IF g_bgjob = 'Y' THEN
        #         CALL s_errmsg('','',l_nppglno,'anm-116',1)
        #      ELSE
        #         CALL cl_err(l_nppglno,'anm-116',1)        #No.FUN-840204
        #      END IF
        #     #end CHI-B60058 mod
        #      LET g_success ='N'
        #     #RETURN   #CHI-B60058 mark
        #   END IF   
        #   LET l_cnt = 0 
        #   DECLARE npp00_cs4 CURSOR FOR
        #      SELECT npp00,npp01 FROM npp_file 
        #      WHERE nppsys='AP' AND npp011 = 1 AND nppglno = l_nppglno AND npptype ='1'   #No.MOD-B20015
        #   FOREACH npp00_cs4 INTO l_npp00,l_npp01 
        #      IF STATUS THEN 
        #         CALL cl_err('foreach:npp00_cs',STATUS,1)    
        #         EXIT FOREACH 
        #      ELSE 
        #         IF l_npp00 = '3' AND g_nmz.nmz05 = 'Y' THEN
        #            SELECT COUNT(*) INTO g_cnt FROM aph_file 
        #               WHERE aph01 = l_npp01 
        #               AND aph03 = '1'
        #               AND aph09 = 'Y'
        #            IF g_cnt > 0 THEN 
        #              #str CHI-B60058 mod
        #              #CALL cl_err('','aap-998',1)    
        #               IF g_bgjob = 'Y' THEN
        #                  CALL s_errmsg('','','','aap-998',1)
        #               ELSE
        #                  CALL cl_err('','aap-998',1)
        #               END IF
        #              #end CHI-B60058 mod
        #               LET l_cnt = l_cnt + 1
        #               EXIT FOREACH
        #            END IF 
        #         END IF 
        #        #MOD-990182---add---start---
        #        #單據若已做付款沖帳，則不可還原
        #         LET l_cnt = 0   LET l_cnt1 = 0
        #         SELECT COUNT(*) INTO l_cnt FROM apg_file,apf_file
        #          WHERE apg04 = l_npp01 AND apf01 = apg01 
        #            AND apf41 != 'X' 
        #            AND apf00  = '33'  #MOD-9B0179 add
        #            AND apf44 != g_existno                           #MOD-A90070
        #         SELECT COUNT(*) INTO l_cnt1 FROM aph_file,apf_file
        #          WHERE aph04 = l_npp01 AND apf01 = aph01 
        #            AND apf41 != 'X' 
        #            AND apf00  = '33'  #MOD-9B0179 add
        #            AND apf44 != g_existno                           #MOD-A90070
        #         #IF l_cnt + l_cnt1 > 0 THEN                         #TQC-B90199
        #         IF l_cnt + l_cnt1 > 0  AND g_apz.apz06 = 'N' THEN   #TQC-B90199
        #           #str CHI-B60058 mod
        #           #CALL cl_err('','agl-910',1)
        #            IF g_bgjob = 'Y' THEN
        #               CALL s_errmsg('','','','agl-910',1)
        #            ELSE
        #               CALL cl_err('','agl-910',1)
        #            END IF
        #           #end CHI-B60058 mod
        #            EXIT FOREACH
        #         END IF
        #        #MOD-990182---add---end---
        #      END IF 
        #   END FOREACH 
        #   IF l_cnt > 0 THEN 
        #      LET g_success ='N'                                                                                                  
        #     #RETURN   #CHI-B60058 mark
        #   END IF
        #   LET p_acc1 = l_npp07
        #   LET g_existno1 = l_nppglno
        #END IF
        #FUN-D40105--mark--end--
#No.FUN-680029--end
         BEGIN WORK
         CALL p409()
         CALL s_showmsg()   #CHI-B60058 add
         IF g_success = "Y" THEN
            COMMIT WORK
         ELSE
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE
#->No.FUN-570112 ---end---
 
     #No.FUN-CB0096 ---start--- add
      LET l_time = TIME
      #FUN-D40105--add--str--
      IF  l_time = l_time_t   THEN
         LET l_time = l_time + 1
      END IF
      LET l_time_t = l_time
      #FUN-D40105--add--end--
      LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
      CALL s_log_data('U','100',g_id,'1',l_time,'','')
     #No.FUN-CB0096 ---end  --- add
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION p409()
# 得出總帳 database name 
# g_apz.apz02p -> g_plant_new -> s_getdbs() -> g_dbs_new --> g_dbs_gl
 
 
   SELECT * INTO g_nmz.* FROM nmz_file WHERE nmz00 = '0'   #MOD-630092
 
  #FUN-A50102--mark--str--
  #LET g_plant_new=p_plant
  #CALL s_getdbs()
  #LET g_dbs_gl=g_dbs_new
  #FUN-A50102--mark--end

   #no.4868 (還原方式為刪除/作廢)
  #LET g_sql = "SELECT aaz84 FROM ",g_dbs_gl CLIPPED,"aaz_file",   #FUN-A50102 
   LET g_sql = "SELECT aaz84 FROM ",cl_get_target_table(p_plant,'aaz_file'),   #FUN-A50102
               " WHERE aaz00 = '0' "
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
   CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql   #FUN-A50102
   PREPARE aaz84_pre FROM g_sql
   DECLARE aaz84_cs CURSOR FOR aaz84_pre
   OPEN aaz84_cs 
   FETCH aaz84_cs INTO g_aaz84
   IF STATUS THEN 
     #CALL cl_err('sel aaz84',STATUS,1)       #FUN-D40105 mark
      CALL s_errmsg('sel aaz84','','',STATUS,1)    #FUN-D40105 add 
      CLOSE WINDOW p409
     #No.FUN-CB0096 ---start--- add
      LET l_time = TIME
      LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
      CALL s_log_data('U','100',g_id,'1',l_time,'','')
     #No.FUN-CB0096 ---end  --- add
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time    #FUN-B30211
      EXIT PROGRAM
   END IF
   #no.4868(end)
#NO.FUN-570112 MARK--------- 
#      LET g_success = 'Y'
#      BEGIN WORK
#NO.FUN-570112 MARK--------
   CALL p409_t()
   #No.FUN-680029 --start--
   IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
      CALL p409_t_1()
   END IF
   #No.FUN-680029 --end--
#NO.FUN-570112 MARK----
#      IF g_success = 'Y' THEN
#         COMMIT WORK
#         CALL cl_end2(1) RETURNING l_flag
#      ELSE
#         ROLLBACK WORK
#         CALL cl_end2(2) RETURNING l_flag
#      END IF
#      IF l_flag THEN CONTINUE WHILE ELSE EXIT WHILE END IF
#      ERROR ""
#   END IF
#END WHILE
#NO.FUN-570112 MARK
END FUNCTION
 
FUNCTION p409_ask()
   DEFINE   l_chk_bookno       LIKE type_file.num5    #No.FUN-690028 SMALLINT   #No.FUN-660141
   DEFINE   l_chk_bookno1      LIKE type_file.num5    #NO.FUN-690028 SMALLINT   #No.FUN-680029
   DEFINE   l_abapost,l_flag   LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
   DEFINE   l_aba19            LIKE aba_file.aba19 
   DEFINE   l_abaacti          LIKE aba_file.abaacti
   DEFINE   l_aba00            LIKE aba_file.aba00 
   DEFINE   l_aaa07            LIKE aaa_file.aaa07 
   DEFINE   l_npp00            LIKE npp_file.npp00 
   DEFINE   l_npp01            LIKE npp_file.npp01
   DEFINE   l_npp07            LIKE npp_file.npp07     #No.FUN-680029
   DEFINE   l_nppglno          LIKE npp_file.nppglno   #No.FUN-680029
   DEFINE   l_cnt              LIKE type_file.num5    #No.FUN-690028 SMALLINT
   DEFINE   lc_cmd             LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(500)     #No.FUN-570112
   DEFINE   l_sql              STRING        #FUN-660141
   DEFINE   l_cnt1             LIKE type_file.num5       #MOD-990182 add
   DEFINE   l_aba20            LIKE aba_file.aba20      #CHI-A20014 add
 
#->No.FUN-570112 --start--
   OPEN WINDOW p409 WITH FORM "aap/42f/aapp409"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()

   CALL cl_opmsg('z')
   LET g_bgjob = "N"
   
   #No.FUN-680029 --start--
   IF g_aza.aza63 = 'N' THEN
      CALL cl_set_comp_visible("p_acc1,g_existno1",FALSE)
   END IF
   #No.FUN-680029 --end--
   
#->No.FUN-570112 ---end---
 
   LET p_plant = g_apz.apz02p
   LET p_acc   = g_apz.apz02b
   LET g_existno = NULL
   DISPLAY NULL TO FORMONLY.g_existno1  #FUN-D40105 add
WHILE TRUE                                                 #->No.FUN-570112
   LET g_action_choice = ""                                #->No.FUN-570112
  #INPUT BY NAME p_plant,p_acc,g_existno WITHOUT DEFAULTS  #->No.FUN-570112
   DIALOG ATTRIBUTES(UNBUFFERED)  #FUN-D40105  add
  #INPUT BY NAME p_plant,p_acc,g_existno,p_acc1,g_existno1,g_bgjob WITHOUT DEFAULTS  #No.FUN-680029 add p_acc1,g_existno1   #FUN-D40105 mark
   INPUT BY NAME p_plant,p_acc,p_acc1 ATTRIBUTE(WITHOUT DEFAULTS=TRUE)     #FUN-D40105 add
 
      AFTER FIELD p_plant
         #FUN-990031--add--str--營運中心要控制在同意法人下
         #SELECT azp01 FROM azp_file WHERE azp01 = p_plant
         SELECT * FROM azw_file WHERE azw01 = p_plant
            AND azw02 = g_legal
         #FUN-990031--end
         IF STATUS <> 0 THEN 
            CALL cl_err('sel_azw','agl-171',0)   #FUN-990031
            NEXT FIELD p_plant
         END IF
         #---/00/05/16 modify
        #FUN-A50102--mark--str--
        #LET g_plant_new=p_plant
        #CALL s_getdbs()
        #LET g_dbs_gl=g_dbs_new
        #FUN-A50102--mark--end
 
      AFTER FIELD p_acc
         IF p_acc IS NULL THEN
            NEXT FIELD p_acc
         END IF
         LET g_apz.apz02b = p_acc
         #No.FUN-660141--begin
         CALL s_check_bookno(p_acc,g_user,p_plant) RETURNING l_chk_bookno
         IF (NOT l_chk_bookno) THEN
            NEXT FIELD p_acc
         END IF 
        
        #LET g_plant_new= p_plant  # 工廠編號   #FUN-A50102
        #CALL s_getdbs()   #FUN-A50102
         LET l_sql = "SELECT COUNT(*) ",
                    #"  FROM ",g_dbs_new CLIPPED,"aaa_file ",   #FUN-A50102
                     "  FROM ",cl_get_target_table(p_plant,'aaa_file'),   #FUN-A50102
                     " WHERE aaa01 = '",p_acc,"' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql   #FUN-A50102
         PREPARE a409_pre2 FROM l_sql
         DECLARE a409_cur2 CURSOR FOR a409_pre2
         OPEN a409_cur2
         FETCH a409_cur2 INTO g_cnt                            
         #No.FUN-660141--end  
## No:2549 modify 1998/10/19 ---------------------
#        SELECT COUNT(*) INTO g_cnt FROM aaa_file WHERE aaa01=p_acc
         IF g_cnt=0 THEN
           #CALL cl_err('sel aaa',100,0)           #FUN-D40105 mark
            CALL s_errmsg('sel aaa','','',100,1)   #FUN-D40105 add
            NEXT FIELD p_acc
         END IF
## -----------------------------------------------

     #FUN-D40105--mark--str--
     #AFTER FIELD g_existno
     #   IF cl_null(g_existno) THEN 
     #      NEXT FIELD g_existno 
     #   END IF
     #   LET g_sql="SELECT aba00,aba02,aba03,aba04,abapost,aba19,abaacti,aba20 FROM ",    #CHI-A20014 add aba20
     #             #g_dbs_gl,"aba_file",    #FUN-A50102
     #              cl_get_target_table(p_plant,'aba_file'),    #FUN-A50102	
     #             " WHERE aba01 = ? AND aba00 = ? AND aba06='AP'" CLIPPED
     #   CALL cl_replace_sqldb(g_sql) RETURNING g_sql    #FUN-A50102
     #   CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql    #FUN-A50102
     #   PREPARE p409_t_p1 FROM g_sql
     #   DECLARE p409_t_c1 CURSOR FOR p409_t_p1
     #   IF STATUS THEN
     #      CALL cl_err('decl aba_cursor:',STATUS,0)
     #      NEXT FIELD g_existno
     #   END IF
     #   OPEN p409_t_c1 USING g_existno,g_apz.apz02b
     #   FETCH p409_t_c1 INTO l_aba00,gl_date,gl_yy,gl_mm,l_abapost,l_aba19,
     #                        l_abaacti,l_aba20  #no.7378     #CHI-A20014 add l_aba20
     #   IF STATUS THEN
     #      CALL cl_err('sel aba:',STATUS,0) 
     #      NEXT FIELD g_existno
     #   END IF
     #   #no.7378
     #   IF l_abaacti = 'N' THEN
     #      CALL cl_err('','mfg8001',1)
     #      NEXT FIELD g_existno
     #   END IF
     #  #CHI-A20014---add---start---
     #   IF l_aba20 MATCHES '[Ss1]' THEN
     #      CALL cl_err('','mfg3557',0)
     #      NEXT FIELD g_existno
     #   END IF
     #  #CHI-A20014---add---end---
     #   #no.7378(end)
     #  #---增加判斷會計帳別之關帳日期
     #  #LET g_sql="SELECT aaa07 FROM ",g_dbs_gl,"aaa_file", " WHERE aaa01='",l_aba00,"'"   #FUN-A50102
     #   LET g_sql="SELECT aaa07 FROM ",cl_get_target_table(p_plant,'aaa_file'),   #FUN-A50102
     #             " WHERE aaa01='",l_aba00,"'"   #FUN-A50102 
     #   CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     #   CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql   #FUN-A50102
     #   PREPARE p409_x_gl_p1 FROM g_sql
     #   DECLARE p409_c_gl_p1 CURSOR FOR p409_x_gl_p1
     #   OPEN p409_c_gl_p1
     #   FETCH p409_c_gl_p1 INTO l_aaa07
     #   IF gl_date <= l_aaa07 THEN
     #      CALL cl_err(gl_date,'agl-200',0) 
     #      NEXT FIELD g_existno 
     #   END IF
     #  #------ end -------------------
     #FUN-B50090 add begin-------------------------
     #重新抓取關帳日期
     #  LET g_sql ="SELECT apz57 FROM apz_file ",
     #             " WHERE apz00 = '0'"
     #  PREPARE t600_apz57_p2 FROM g_sql
     #  EXECUTE t600_apz57_p2 INTO g_apz.apz57
     #FUN-B50090 add -end--------------------------
     #  #傳票日期小於系統之關帳日,不可還原
     #  #IF gl_date < g_sma.sma53 THEN
     #   IF gl_date < g_apz.apz57 THEN   #MOD-570223
     #      CALL cl_err('','aap-027',0) 
     #      NEXT FIELD g_existno 
     #   END IF 
     #   IF l_abapost = 'Y' THEN
     #      CALL cl_err(g_existno,'aap-130',0) 
     #      NEXT FIELD g_existno
     #   END IF
     #   #Modi:已確認傳票不能做還原
     #   IF l_aba19 ='Y' THEN 
     #      CALL cl_err(g_existno,'aap-026',0)
     #      NEXT FIELD g_existno
     #   END IF   
     #  #-MOD-A80246-add-  
     #   LET l_cnt = 0
     #   SELECT COUNT(*) INTO l_cnt 
     #     FROM amd_file
     #    WHERE amd28 = g_existno
     #   IF l_cnt > 0 THEN
     #      CALL cl_err(g_existno,'amd-030',0) 
     #      NEXT FIELD g_existno
     #   END IF 
     #  #-MOD-A80246-end-  
     #   #若為付款單之傳票，付款類別為支票時，
     #   #已開票則不可還原 no.5039 02/06/04
     #   LET l_cnt = 0 
     #   DECLARE npp00_cs CURSOR FOR          #改成多筆處理 
     #      SELECT npp00,npp01 FROM npp_file 
     #         WHERE nppsys='AP' AND npp011 = 1 AND nppglno = g_existno AND npptype ='0'  #No.MOD-B20015
     #   FOREACH npp00_cs INTO l_npp00,l_npp01 
     #      IF STATUS THEN 
     #         CALL cl_err('foreach:npp00_cs',STATUS,1)    
     #         EXIT FOREACH 
     #      ELSE 
     #         #NO.MOD-5B0192 START--
     #         #IF l_npp00 = '3' THEN #付款單 
     #         IF l_npp00 = '3' AND g_nmz.nmz05 = 'Y' THEN
     #         #NO.MOD-5B0192 END--
     #            SELECT COUNT(*) INTO g_cnt FROM aph_file 
     #               WHERE aph01 = l_npp01 
     #               AND aph03 = '1' #支票 
     #               AND aph09 = 'Y' #已開票 
     #            IF g_cnt > 0 THEN 
     #               CALL cl_err('','aap-998',1)    
     #               LET l_cnt = l_cnt + 1
     #               EXIT FOREACH
     #            END IF 
     #         END IF 
     #        #MOD-990182---add---start---
     #        #單據若已做付款沖帳，則不可還原
     #         LET l_cnt = 0   LET l_cnt1 = 0
     #         SELECT COUNT(*) INTO l_cnt FROM apg_file,apf_file
     #          WHERE apg04 = l_npp01 AND apf01 = apg01 
     #            AND apf41 != 'X' 
     #            AND apf00  = '33'  #MOD-9B0179 add
     #            AND apf44 != g_existno                           #MOD-A90070
     #         SELECT COUNT(*) INTO l_cnt1 FROM aph_file,apf_file
     #          WHERE aph04 = l_npp01 AND apf01 = aph01 
     #            AND apf41 != 'X' 
     #            AND apf00  = '33'  #MOD-9B0179 add
     #            AND apf44 != g_existno                           #MOD-A90070
     #         IF l_cnt + l_cnt1 > 0 THEN
     #            CALL cl_err('','agl-910',1)
     #            EXIT FOREACH
     #         END IF
     #        #MOD-990182---add---end---
     #      END IF 
     #   END FOREACH 
     #   IF l_cnt > 0 THEN 
     #      NEXT FIELD g_existno
     #   END IF
     #   #no.5039(end)
     #   #No.FUN-680029 --start--
     #   IF g_aza.aza63 = 'Y' THEN
     #      SELECT UNIQUE npp07,nppglno INTO l_npp07,l_nppglno
     #         FROM npp_file
     #         WHERE npp01 IN (SELECT npp01 FROM npp_file WHERE npp07 = p_acc AND nppglno = g_existno AND npptype = '0')
     #         AND npptype = '1'
     #      IF cl_null(l_npp07) OR cl_null(l_nppglno) THEN
     #         CALL cl_err('','aap-986',1)
     #         NEXT FIELD g_existno
     #      END IF
     #      OPEN p409_t_c1 USING l_nppglno,g_apz.apz02c
     #      FETCH p409_t_c1 INTO l_aba00,gl_date,gl_yy,gl_mm,l_abapost,l_aba19,
     #                           l_abaacti,l_aba20      #CHI-A20014 add l_aba20
     #      IF STATUS THEN
     #         CALL cl_err('sel aba:',STATUS,0) 
     #         NEXT FIELD g_existno
     #      END IF
     #      IF l_abaacti = 'N' THEN
     #         CALL cl_err('','mfg8003',1)
     #         NEXT FIELD g_existno
     #      END IF
     #     #CHI-A20014---add---start---
     #      IF l_aba20 MATCHES '[Ss1]' THEN
     #         CALL cl_err('','mfg3557',0)
     #         NEXT FIELD g_existno
     #      END IF
     #     #CHI-A20014---add---end---
     #     #FUN-A50102--mod--str--
     #     #LET g_sql="SELECT aaa07 FROM ",g_dbs_gl,"aaa_file", " WHERE aaa01='",l_aba00,"'"
     #      LET g_sql="SELECT aaa07 FROM ",cl_get_target_table(p_plant,'aaa_file'),
     #                " WHERE aaa01='",l_aba00,"'"
     #     #FUN-A50102--mod--end
     #   CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     #      CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql    #FUN-A50102
     #      PREPARE p409_x_gl_p2 FROM g_sql
     #      DECLARE p409_c_gl_p2 CURSOR FOR p409_x_gl_p2
     #      OPEN p409_c_gl_p2
     #      FETCH p409_c_gl_p2 INTO l_aaa07
     #      IF gl_date <= l_aaa07 THEN
     #         CALL cl_err(gl_date,'agl-200',0) 
     #         NEXT FIELD g_existno 
     #      END IF
     #      IF gl_date < g_apz.apz57 THEN
     #         CALL cl_err('','aap-027',0) 
     #         NEXT FIELD g_existno 
     #      END IF 
     #      IF l_abapost = 'Y' THEN
     #         CALL cl_err(l_nppglno,'aap-132',0)
     #         NEXT FIELD g_existno
     #      END IF
     #      IF l_aba19 ='Y' THEN 
     #      #  CALL cl_err(l_nppglno,'anm-116',0) 
     #         CALL cl_err(l_nppglno,'anm-116',1)        #No.FUN-840204
     #         NEXT FIELD g_existno
     #      END IF   
     #      LET l_cnt = 0 
     #      DECLARE npp00_cs1 CURSOR FOR
     #         SELECT npp00,npp01 FROM npp_file 
     #            WHERE nppsys='AP' AND npp011 = 1 AND nppglno = l_nppglno AND npptype ='1' #No.MOD-B20015
     #      FOREACH npp00_cs1 INTO l_npp00,l_npp01 
     #         IF STATUS THEN 
     #            CALL cl_err('foreach:npp00_cs',STATUS,1)    
     #            EXIT FOREACH 
     #         ELSE 
     #            IF l_npp00 = '3' AND g_nmz.nmz05 = 'Y' THEN
     #               SELECT COUNT(*) INTO g_cnt FROM aph_file 
     #                  WHERE aph01 = l_npp01 
     #                  AND aph03 = '1'
     #                  AND aph09 = 'Y'
     #               IF g_cnt > 0 THEN 
     #                  CALL cl_err('','aap-998',1)    
     #                  LET l_cnt = l_cnt + 1
     #                  EXIT FOREACH
     #               END IF 
     #            END IF 
     #           #MOD-990182---add---start---
     #           #單據若已做付款沖帳，則不可還原
     #            LET l_cnt = 0   LET l_cnt1 = 0
     #            SELECT COUNT(*) INTO l_cnt FROM apg_file,apf_file
     #             WHERE apg04 = l_npp01 AND apf01 = apg01 
     #               AND apf41 != 'X' 
     #               AND apf00  = '33'  #MOD-9B0179 add
     #               AND apf44 != g_existno                           #MOD-A90070
     #            SELECT COUNT(*) INTO l_cnt1 FROM aph_file,apf_file
     #             WHERE aph04 = l_npp01 AND apf01 = aph01 
     #               AND apf41 != 'X'
     #               AND apf00  = '33'  #MOD-9B0179 add
     #               AND apf44 != g_existno                           #MOD-A90070
     #            IF l_cnt + l_cnt1 > 0 THEN
     #               CALL cl_err('','agl-910',1)
     #               EXIT FOREACH
     #               LET g_success = 'N'
     #               RETURN
     #            END IF
     #           #MOD-990182---add---end---
     #         END IF 
     #      END FOREACH 
     #      IF l_cnt > 0 THEN 
     #         NEXT FIELD g_existno
     #      END IF
     #      LET p_acc1 = l_npp07
     #      LET g_existno1 = l_nppglno
     #      DISPLAY l_npp07 TO FORMONLY.p_acc1
     #      DISPLAY l_nppglno TO FORMONLY.g_existno1
     #   END IF
     #FUN-D40105--mark--end--
         #No.FUN-680029 --end--
         
       #No.B003 010413 by plum
      AFTER INPUT
         IF INT_FLAG THEN 
           #EXIT INPUT      #FUN-D40105 mark
            EXIT DIALOG     #FUN-D40105 add 
         END IF
         LET l_flag='N'
         IF cl_null(p_plant)   THEN
            LET l_flag='Y' 
         END IF
         IF cl_null(p_acc)     THEN
            LET l_flag='Y' 
         END IF
         #FUN-D40105--mark--str--
         #IF cl_null(g_existno) THEN 
         #   LET l_flag='Y'
         #END IF
         #FUN-D40105--mark--end--
         IF l_flag='Y' THEN
            CALL cl_err('','9033',0)
            NEXT FIELD p_plant
         END IF
       #FUN-A50102--mark--str--
       # # 得出總帳 database name
       # # g_apz.apz02p -> g_plant_new -> s_getdbs() -> g_dbs_new --> g_dbs_gl
       # LET g_plant_new= p_plant  # 工廠編號
       # CALL s_getdbs()
       # LET g_dbs_gl=g_dbs_new    # 得資料庫名稱
       # #No.B003...end
       #FUN-A50102--mark--end
 
     #FUN-D40105--mark--str--
     #ON ACTION CONTROLR
     #   CALL cl_show_req_fields()
     #ON ACTION CONTROLG
     #   CALL cl_cmdask()
     #ON ACTION locale
     #  #->No.FUN-570112 --start--
     #  #LET g_action_choice='locale'
     #  #CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
     #   LET g_change_lang = TRUE
     #  #->No.FUN-570112 ---end---
     #   EXIT INPUT
     #ON ACTION exit
     #   LET INT_FLAG = 1
     #   EXIT INPUT
     #ON IDLE g_idle_seconds
     #   CALL cl_on_idle()
     #   CONTINUE INPUT
 
     #ON ACTION about         #MOD-4C0121
     #   CALL cl_about()      #MOD-4C0121
 
     #ON ACTION help          #MOD-4C0121
     #   CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION CONTROLP           #FUN-D40105  add
   
     #   #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_init()
     #   #No.FUN-580031 ---end---
 
     #   #No.FUN-580031 --start--
     #   ON ACTION qbe_select
     #      CALL cl_qbe_select()
     #   #No.FUN-580031 ---end---
 
     #   #No.FUN-580031 --start--
     #   ON ACTION qbe_save
     #      CALL cl_qbe_save()
         #No.FUN-580031 ---end---
     #FUN-D40105---mark---end---
 
   END INPUT

   #FUN-D40105--add--str--
   CONSTRUCT BY NAME  tm.wc1 ON g_existno
      BEFORE CONSTRUCT
        CALL cl_qbe_init()

   AFTER FIELD g_existno
      IF tm.wc1 = " 1=1" THEN
         CALL cl_err('','9033',0)
         NEXT FIELD g_existno
      END IF
     #MOD-G30031---add---str--
      IF GET_FLDBUF(g_existno) = "*" THEN
         CALL cl_err('','9089',1)
         NEXT FIELD g_existno
      END IF
     #MOD-G30031---add---end-- 
      CALL  p409_existno_chk()
      IF g_success = 'N' THEN
         CALL s_showmsg()
         NEXT FIELD g_existno
      END IF

      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(g_existno)
              LET g_existno_str = ''
              CALL q_aba01_1( TRUE, TRUE, p_plant,p_acc,' ','AP')
              RETURNING g_existno_str
              DISPLAY g_existno_str TO g_existno
              NEXT FIELD g_existno
         END CASE

   END CONSTRUCT

   INPUT BY NAME g_bgjob ATTRIBUTE(WITHOUT DEFAULTS=TRUE)

   END INPUT

   ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG
         CALL cl_cmdask()
      ON ACTION locale
         LET g_change_lang = TRUE
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT DIALOG
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG

      ON ACTION about
         CALL cl_about()

      ON ACTION help
         CALL cl_show_help()

      ON ACTION ACCEPT
        #MOD-G30031---add---str--
         IF GET_FLDBUF(g_existno) = "*" THEN
            CALL cl_err('','9089',1)
            NEXT FIELD g_existno
         END IF
        #MOD-G30031---add---end--
         EXIT DIALOG

      ON ACTION CANCEL
         LET INT_FLAG=1
         EXIT DIALOG

      ON ACTION qbe_select
         CALL cl_qbe_select()

      ON ACTION qbe_save
         CALL cl_qbe_save()
   END DIALOG
   #FUN-D40105--add--end--

#NO.FUN-570112 START----
#   IF g_action_choice = 'locale' THEN
#      RETURN
#   END IF
   IF g_change_lang THEN
      LET g_change_lang = FALSE
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p409_w
     #No.FUN-CB0096 ---start--- add
      LET l_time = TIME
      #FUN-D40105--add--str--
      IF  l_time = l_time_t   THEN
         LET l_time = l_time + 1
      END IF
      LET l_time_t = l_time
      #FUN-D40105--add--end--
      LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
      CALL s_log_data('U','100',g_id,'1',l_time,'','')
     #No.FUN-CB0096 ---end  --- add
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time     #FUN-B30211
      EXIT PROGRAM
   END IF
   IF g_bgjob = "Y" THEN
      SELECT zz08 INTO lc_cmd FROM zz_file
         WHERE zz01 = "aapp409"
      IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
         CALL cl_err('aapp409','9031',1)   
      ELSE
         LET lc_cmd = lc_cmd CLIPPED,
                      " '",p_plant CLIPPED,"'",
                      " '",p_acc CLIPPED,"'",
                      " '",g_existno CLIPPED,"'",
                      " '",g_bgjob CLIPPED,"'"
         CALL cl_cmdat('aapp409',g_time,lc_cmd CLIPPED)
      END IF
      CLOSE WINDOW p409_w
     #No.FUN-CB0096 ---start--- add
      LET l_time = TIME
      #FUN-D40105--add--str--
      IF  l_time = l_time_t   THEN
         LET l_time = l_time + 1
      END IF
      LET l_time_t = l_time
      #FUN-D40105--add--end--
      LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
      CALL s_log_data('U','100',g_id,'1',l_time,'','')
     #No.FUN-CB0096 ---end  --- add
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time     #FUN-B30211
      EXIT PROGRAM
   END IF
   EXIT WHILE
END WHILE
#->No.FUN-570112 ---end---
 
END FUNCTION
 
FUNCTION p409_t()
   DEFINE n1,n2,n3,n4   LIKE type_file.num10   #No.FUN-690028 INTEGER
   DEFINE l_npp      RECORD LIKE npp_file.*   
   DEFINE l_apf01    LIKE apf_file.apf01    #MOD-640404
   DEFINE l_cnt      LIKE type_file.num5    #MOD-640404  #No.FUN-690028 SMALLINT
   DEFINE l_nmf01    LIKE nmf_file.nmf01    #MOD-930242 add
   DEFINE l_aqa00    LIKE aqa_file.aqa00    #FUN-C70093 
   IF g_aaz84 = '2' THEN   #還原方式為作廢 #no.4868
     #LET g_sql="UPDATE ",g_dbs_gl," aba_file  SET abaacti = 'N' ",   #FUN-A50102


      #FUN-D40105--add--str--
      IF g_aza.aza63 = 'Y' THEN
         LET tm.wc1 = cl_replace_str(tm.wc1,"nppglno","aba01")
      END IF
      #FUN-D40105--add--end--

      LET g_sql="UPDATE ",cl_get_target_table(p_plant,'aba_file'),    #FUN-A50102
                "   SET abaacti = 'N' ",   #FUN-A50102 
               #" WHERE aba01 = ? AND aba00 = ? "      #FUN-D40105  mark
                " WHERE  aba00 = ? ",                  #FUN-D40105 add
                "   AND ",tm.wc1                       #FUN-D40105 add
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
      CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql   #FUN-A50102
      PREPARE p409_updaba_p FROM g_sql
     #EXECUTE p409_updaba_p USING g_existno,g_apz.apz02b    #FUN-D40105 mark
      EXECUTE p409_updaba_p USING g_apz.apz02b              #FUN-D40105 add
      IF SQLCA.sqlcode THEN
        #str CHI-B60058 mod
        #CALL cl_err('(upd abaacti)',SQLCA.sqlcode,1)
        #IF g_bgjob = 'Y' THEN  #FUN-D40105  mark
            CALL s_errmsg('','','(upd abaacti)',SQLCA.sqlcode,1)
        #ELSE   #FUN-D40105  mark
        #   CALL cl_err3("upd","aba_file",g_existno,"",SQLCA.sqlcode,"","upd abaacti",1)  #FUN-D40105  mark
        #END IF  #FUN-D40105  mark
        #end CHI-B60058 mod
         LET g_success = 'N'
        #RETURN   #CHI-B60058 mark
      END IF
   ELSE
      IF g_bgjob = 'N' THEN   #FUN-570112
         DISPLAY "Delete GL's Voucher body!" AT 1,1 #-------------------------
      END IF
     #LET g_sql="DELETE FROM ",g_dbs_gl,"abb_file WHERE abb01=? AND abb00=?"   #FUN-A50102

      #FUN-D40105--add--str--
      IF g_aza.aza63 = 'Y' THEN
         LET tm.wc1 = cl_replace_str(tm.wc1,"nppglno","abb01")
      ELSE
         LET tm.wc1 = cl_replace_str(tm.wc1,"aba01","abb01")
      END IF
      #FUN-D40105--add--end--

      LET g_sql="DELETE FROM ",cl_get_target_table(p_plant,'abb_file'),    #FUN-A50102
               #" WHERE abb01=? AND abb00=?"    #FUN-A50102      #FUN-D40105  mark
                " WHERE  abb00 = ? ",            #FUN-D40105 add
                "   AND ",tm.wc1                 #FUN-D40105 add
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
      CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql   #FUN-A50102
      PREPARE p409_2_p3 FROM g_sql
     #EXECUTE p409_2_p3 USING g_existno,g_apz.apz02b     #FUN-D40105  mark
      EXECUTE p409_2_p3 USING g_apz.apz02b               #FUN-D40105 add
      IF SQLCA.sqlcode THEN
        #str CHI-B60058 mod
        #CALL cl_err('(del abb)',SQLCA.sqlcode,1)
        #IF g_bgjob = 'Y' THEN   #FUN-D40105  mark
            CALL s_errmsg('','','(del abb)',SQLCA.sqlcode,1)
        #ELSE  #FUN-D40105  mark
        #   CALL cl_err3("del","abb_file",g_existno,"",SQLCA.sqlcode,"","del abb_file",1)  #FUN-D40105  mark
        #END IF  #FUN-D40105  mark
        #end CHI-B60058 mod
         LET g_success = 'N'
        #RETURN   #CHI-B60058 mark
      END IF
      IF g_bgjob = 'N' THEN   #FUN-570112
         DISPLAY "Delete GL's Voucher head!" AT 1,1 #-------------------------
      END IF
     #LET g_sql="DELETE FROM ",g_dbs_gl,"aba_file WHERE aba01=? AND aba00=?"   #FUN-A50102
      LET tm.wc1 = cl_replace_str(tm.wc1,"abb01","aba01")     #FUN-D40105 add
      LET g_sql="DELETE FROM ",cl_get_target_table(p_plant,'aba_file'),    #FUN-A50102
               #" WHERE aba01=? AND aba00=?"     #FUN-D40105 mark
                " WHERE  aba00 = ? ",            #FUN-D40105 add
                "   AND ",tm.wc1                 #FUN-D40105 add 
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
      CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql   #FUN-A50102
      PREPARE p409_2_p4 FROM g_sql
     #EXECUTE p409_2_p4 USING g_existno,g_apz.apz02b     #FUN-D40105 mark
      EXECUTE p409_2_p4 USING g_apz.apz02b               #FUN-D40105 add
      IF SQLCA.sqlcode THEN
        #str CHI-B60058 mod
        #CALL cl_err('(del aba)',SQLCA.sqlcode,1)
        #IF g_bgjob = 'Y' THEN     #FUN-D40105 mark
            CALL s_errmsg('','','(del aba)',SQLCA.sqlcode,1)
        #FUN-D40105--mark--end--
        #ELSE
        #   CALL cl_err3("del","aba_file",g_existno,"",SQLCA.sqlcode,"","del aba_file",1)
        #END IF
        #FUN-D40105--mark--end--
        #end CHI-B60058 mod
         LET g_success = 'N'
        #RETURN   #CHI-B60058 mark
      END IF
      IF SQLCA.sqlerrd[3] = 0 THEN
        #str CHI-B60058 mod
        #CALL cl_err('(del aba)','aap-161',1)
        #IF g_bgjob = 'Y' THEN   #FUN-D40105 mark
            CALL s_errmsg('','','(del aba)','aap-161',1)
        #FUN-D40105--mark--str--
        #ELSE
        #   CALL cl_err3("del","aba_file",g_existno,"",'aap-161',"","del aba_file",1)
        #END IF
        #FUN-D40105--mark--end--
        #end CHI-B60058 mod
         LET g_success = 'N'
        #RETURN   #CHI-B60058 mark
      END IF
      IF g_bgjob = 'N' THEN   #FUN-570112
         DISPLAY "Delete GL's Voucher desp!" AT 1,1 #-------------------------
      END IF
     #LET g_sql="DELETE FROM ",g_dbs_gl,"abc_file WHERE abc01=? AND abc00=?"   #FUN-A50102

      LET tm.wc1 = cl_replace_str(tm.wc1,"aba01","abc01")     #FUN-D40105 add

      LET g_sql="DELETE FROM ",cl_get_target_table(p_plant,'abc_file'),    #FUN-A50102
               #" WHERE abc01=? AND abc00=?"    #FUN-A50102   #FUN-D40105 mark
                " WHERE  abc00=?",               #FUN-D40105 add
                "   AND ",tm.wc1                 #FUN-D40105 add
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
      CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql   #FUN-A50102
      PREPARE p409_2_p5 FROM g_sql
     #EXECUTE p409_2_p5 USING g_existno,g_apz.apz02b   #FUN-D40105 mark
      EXECUTE p409_2_p5 USING g_apz.apz02b              #FUN-D40105 add
      IF SQLCA.sqlcode THEN
        #str CHI-B60058 mod
        #CALL cl_err('(del abc)',SQLCA.sqlcode,1)
        #IF g_bgjob = 'Y' THEN  #FUN-D40105 mark
            CALL s_errmsg('','','(del abc)',SQLCA.sqlcode,1)
        #FUN-D40105--mark--str--
        #ELSE
        #   CALL cl_err3("del","abc_file",g_existno,"",SQLCA.sqlcode,"","del abc_file",1)
        #END IF
        #FUN-D40105--mark--end--
        #end CHI-B60058 mod
         LET g_success = 'N'
        #RETURN   #CHI-B60058 mark
      END IF
     #--------------------------------MOD-C20146------------------------------------------start
      LET l_cnt = 0
      LET tm.wc1 = cl_replace_str(tm.wc1,"abc01","tic04")     #FUN-D40105 add
      LET g_sql="SELECT COUNT(*) FROM ",cl_get_target_table(p_plant,'tic_file'),
               #" WHERE tic04 =? AND tic00 =?"   #FUN-D40105 mark
                " WHERE  tic00 =?",              #FUN-D40105 add
                "   AND ",tm.wc1                 #FUN-D40105 add
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql
      PREPARE p409_2_p10 FROM g_sql
     #EXECUTE p409_2_p10 USING g_existno,g_apz.apz02b INTO l_cnt   #FUN-D40105 mark
      EXECUTE p409_2_p10 USING g_apz.apz02b INTO l_cnt    #FUN-D40105 add
      IF l_cnt > 0 THEN
     #--------------------------------MOD-C20146--------------------------------------------end
        #FUN-B40056 -begin
         LET g_sql="DELETE FROM ",cl_get_target_table(p_plant,'tic_file'),  
                  #" WHERE tic04 =? AND tic00 =?"    #FUN-D40105 mark
                   " WHERE  tic00 =?",               #FUN-D40105 add
                   "   AND ",tm.wc1                  #FUN-D40105 add 
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql       
         CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql
         PREPARE p409_2_p11 FROM g_sql
        #EXECUTE p409_2_p11 USING g_existno,g_apz.apz02b    #FUN-D40105 mark
         EXECUTE p409_2_p11 USING g_apz.apz02b              #FUN-D40105 add
         IF SQLCA.sqlcode THEN
           #str CHI-B60058 mod
           #CALL cl_err('(del tic)',SQLCA.sqlcode,1)
           #IF g_bgjob = 'Y' THEN    #FUN-D40105  mark
               CALL s_errmsg('','','(del tic)',SQLCA.sqlcode,1)
           #FUN-D40105--mark--end--
           #ELSE
           #   CALL cl_err3("del","tic_file",g_existno,"",SQLCA.sqlcode,"","del tic_file",1)
           #END IF
           #FUN-D40105--mark--end--
           #end CHI-B60058 mod
            LET g_success = 'N'
           #RETURN   #CHI-B60058 mark
         END IF
        #FUN-B40056 -end
      END IF                                    #MOD-C20146
   END IF
#  CALL s_abhmod(g_dbs_gl,g_apz.apz02b,g_existno)   #MOD-590081   #CHI-780008 #FUN-980020 mark
   CALL s_abhmod(p_plant,g_apz.apz02b,g_existno)    #FUN-980020
   IF g_success = 'N' THEN RETURN END IF
      LET g_msg = TIME
      #INSERT INTO azo_file (azo01,azo02,azo03,azo04,azo05,azo06) #FUN-980001 mark
      #       VALUES('aapp409',g_user,g_today,g_msg,g_existno,'delete') #FUN-980001 mark
      INSERT INTO azo_file (azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal) #FUN-980001 add
             VALUES('aapp409',g_user,g_today,g_msg,g_existno,'delete',g_plant,g_legal) #FUN-980001 add
   #-----MOD-640404---------
   #FUN-D40105--add--str--
   IF g_aaz84 = '2' THEN
      LET tm.wc1 = cl_replace_str(tm.wc1,"aba01","apf44")
   ELSE
      LET tm.wc1 = cl_replace_str(tm.wc1,"tic04","apf44")
   END IF
   #FUN-D40105--add--end--
  #SELECT apf01 INTO l_apf01 FROM apf_file WHERE apf44=g_existno  #FUN-D40105 mark
  #SELECT COUNT(*) INTO l_cnt FROM nmf_file WHERE nmf12 = l_apf01 #FUN-D40105 mark
   #FUN-D40105--add--str--
   LET g_sql = "SELECT COUNT(*)  FROM nmf_file WHERE nmf12",
               " IN (SELECT apf01  FROM apf_file WHERE ",tm.wc1,")"
   PREPARE p409_pre_1 FROM g_sql
   EXECUTE p409_pre_1 INTO l_cnt
   #FUN-D40105--add--end--
   IF l_cnt > 0 THEN
     #UPDATE nmf_file SET nmf11='',nmf13='' WHERE nmf12 = l_apf01 #FUN-D40105 mark
      #FUN-D40105--add--str--
      LET g_sql = "UPDATE nmf_file SET nmf11='',nmf13='' WHERE nmf12 ",
                  " IN (SELECT apf01  FROM apf_file WHERE ",tm.wc1,")"
      PREPARE p409_pre_2 FROM g_sql
      EXECUTE p409_pre_2
      #FUN-D40105--add--end--
      IF STATUS THEN
#        CALL cl_err('upd nmf_file',STATUS,1)   #No.FUN-660122
        #str CHI-B60058 mod
        #CALL cl_err3("upd","nmf_file",l_apf01,"",STATUS,"","upd nmf_file",1)  #No.FUN-660122
        #IF g_bgjob = 'Y' THEN #FUN-D40105  mark
            CALL s_errmsg('','','(upd nmf_file)',STATUS,1)
        #FUN-D40105--mark--str--
        #ELSE
        #   CALL cl_err3("upd","nmf_file",l_apf01,"",STATUS,"","upd nmf_file",1)
        #END IF
        #FUN-D40105--mark--end--
        #end CHI-B60058 mod
         LET g_success='N'
      END IF
     #str MOD-930242 add
      LET l_nmf01 = ''
     #SELECT nmf01 INTO l_nmf01 FROM nmf_file WHERE nmf12=l_apf01 AND nmf05='0'  #FUN-D40105 mark
      LET l_cnt = 0
     #SELECT COUNT(*) INTO l_cnt FROM nmd_file WHERE nmd01=l_nmf01    #FUN-D40105 mark
      #FUN-D40105--add--str--
      LET g_sql = "SELECT COUNT(*)  FROM nmd_file WHERE nmd01",
                  "  IN (SELECT nmf01  FROM nmf_file WHERE nmf05='0' AND nmf12",
                  "  IN (SELECT apf01  FROM apf_file WHERE ",tm.wc1,"))"
      PREPARE p409_pre_3 FROM g_sql
      EXECUTE p409_pre_3 INTO l_cnt
      #FUN-D40105--add--end--
      IF l_cnt > 0 THEN
        #UPDATE nmd_file SET nmd27='',nmd28='' WHERE nmd01=l_nmf01   #FUN-D40105 mark
         #FUN-D40105--add--str--
         LET g_sql = "UPDATE nmd_file SET nmd27='',nmd28='' WHERE nmd01",
                     " IN (SELECT nmf01  FROM nmf_file WHERE nmf05='0' AND nmf12",
                     " IN (SELECT apf01  FROM apf_file WHERE ",tm.wc1,"))"
         PREPARE p409_pre_4 FROM g_sql
         EXECUTE p409_pre_4
         #FUN-D40105--add--end--
         IF STATUS THEN
           #str CHI-B60058 mod
           #CALL cl_err3("upd","nmd_file",l_nmf01,"",STATUS,"","upd nmd_file",1)
           #IF g_bgjob = 'Y' THEN #FUN-D40105  mark
               CALL s_errmsg('','','(upd nmd_file)',STATUS,1)
           #FUN-D40105--mark--str--
           #ELSE
           #   CALL cl_err3("upd","nmd_file",l_nmf01,"",STATUS,"","upd nmd_file",1)
           #END IF
           #FUN-D40105--mark--end--
           #end CHI-B60058 mod
            LET g_success='N'
         END IF
      END IF 
     #end MOD-930242 add
   END IF 
   #-----END MOD-640404-----
 
   #----------------------------------------------------------------------
   LET tm.wc1 = cl_replace_str(tm.wc1,"apf44","apa44")        #FUN-D40105 add
  #UPDATE apa_file SET apa43 = NULL,apa44=NULL WHERE apa44=g_existno  #FUN-D40105 mark
   #FUN-D40105--add--str--
   LET g_sql ="UPDATE apa_file SET apa43 = NULL,apa44=NULL WHERE ",tm.wc1
   PREPARE p409_pre_5 FROM g_sql
   EXECUTE p409_pre_5
   #FUN-D40105--add--end--
   IF STATUS THEN
#     CALL cl_err('(upd apa44)',STATUS,1)   #No.FUN-660122
     #str CHI-B60058 mod
     #CALL cl_err3("upd","apa_file",g_existno,"",STATUS,"","upd apa44",1)  #No.FUN-660122
     #IF g_bgjob = 'Y' THEN  #FUN-D40105  mark
         CALL s_errmsg('','','(upd apa44)',STATUS,1)
     #FUN-D40105--mark--str--
     #ELSE
     #   CALL cl_err3("upd","apa_file",g_existno,"",STATUS,"","upd apa44",1)
     #END IF
     #FUN-D40105--mark--end--
     #end CHI-B60058 mod
      LET g_success='N'
   END IF
   LET n1=SQLCA.SQLERRD[3]
   LET tm.wc1 = cl_replace_str(tm.wc1,"apa44","apf44")          #FUN-D40105 add
  #UPDATE apf_file SET apf43 = NULL,apf44=NULL WHERE apf44=g_existno  #FUN-D40105  mark
   #FUN-D40105--add--str--
   LET g_sql ="UPDATE apf_file SET apf43 = NULL,apf44=NULL WHERE ",tm.wc1
   PREPARE p409_pre_6 FROM g_sql
   EXECUTE p409_pre_6
   #FUN-D40105--add--end--
   IF STATUS THEN
#     CALL cl_err('(upd apf44)',STATUS,1)    #No.FUN-660122
     #str CHI-B60058 mod
     #CALL cl_err3("upd","apf_file",g_existno,"",STATUS,"","upd apf44",1)  #No.FUN-660122
     #IF g_bgjob = 'Y' THEN  #FUN-D40105  mark
         CALL s_errmsg('','','(upd apf44)',STATUS,1)
     #FUN-D40105--mark--str--
     #ELSE
     #   CALL cl_err3("upd","apf_file",g_existno,"",STATUS,"","upd apf44",1)
     #END IF
     #FUN-D40105--mark--end--
     #end CHI-B60058 mod
      LET g_success='N'
   END IF
   LET n2=SQLCA.SQLERRD[3]
   #no.7277
   LET tm.wc1 = cl_replace_str(tm.wc1,"apf44","aqa05")          #FUN-D40105 add
  #UPDATE aqa_file SET aqa05=NULL WHERE aqa05=g_existno  #FUN-D40105  mark
   #FUN-D40105--add--str--
   LET g_sql ="UPDATE aqa_file SET aqa05=NULL WHERE ",tm.wc1
   PREPARE p409_pre_7 FROM g_sql
   EXECUTE p409_pre_7
   #FUN-D40105--add--end--
   IF STATUS THEN
#     CALL cl_err('(upd aqa05)',STATUS,1)    #No.FUN-660122
     #str CHI-B60058 mod
     #CALL cl_err3("upd","aqa_file",g_existno,"",STATUS,"","upd aqa05",1)  #No.FUN-660122
     #IF g_bgjob = 'Y' THEN  #FUN-D40105  mark
         CALL s_errmsg('','','(upd aqa05)',STATUS,1)
     #FUN-D40105--mark--str--
     #ELSE
     #   CALL cl_err3("upd","aqa_file",g_existno,"",STATUS,"","upd aqa05",1)
     #END IF
     #FUN-D40105--mark--end--
     #end CHI-B60058 mod
      LET g_success='N'
   END IF
   LET n3=SQLCA.SQLERRD[3]

   #FUN-C70093--ADD--STR
   #成本分摊抛转还原且aqa00='2'时，抛转还原后回写ccbglno=NULL
   LET tm.wc1 = cl_replace_str(tm.wc1,"aqa05","nppglno")          #FUN-D40105 add
  #FUN-D40105--mark--str--
  #SELECT npp00,npp01 INTO l_npp.npp00,l_npp.npp01 FROM npp_file
  # WHERE nppglno = g_existno   
  #SELECT aqa00 INTO l_aqa00 FROM aqa_file WHERE aqa01=l_npp.npp01
  #IF l_npp.npp00=4 AND l_aqa00='2' THEN 
  #   UPDATE ccb_file SET ccbglno=NULL WHERE ccb04=l_npp.npp01
  #FUN-D40105--mark--str--
      #FUN-D40105--add--str--
      LET g_sql ="UPDATE ccb_file SET ccbglno=NULL WHERE ccb04",
                 " IN (SELECT npp01 FROM npp_file,aqa_file WHERE npp00 = '4'",
                 " AND aqa00 = '2'AND npp01 = aqa01 AND ",tm.wc1,
                 " )"
      PREPARE p409_pre_8 FROM g_sql
      EXECUTE p409_pre_8
      #FUN-D40105--add--end--
       IF STATUS THEN
         #IF g_bgjob = 'Y' THEN  #FUN-D40105 mark
             CALL s_errmsg('','','(upd aqa05)',STATUS,1)
         #FUN-D40105--mark--str--
         #ELSE
         #   CALL cl_err3("upd","aqa_file",g_existno,"",STATUS,"","upd aqa05",1)
         #END IF
         #FUN-D40105--mark--end--
          LET g_success='N'
       END IF
   #END IF  #FUN-D40105 mark
    LET n4=SQLCA.SQLERRD[3]
  #FUN-C70093--ADD--END

   #no.7277(end)
   IF n1+n2+n3+n4 = 0 THEN     #FUN-C70093 add--n4
     #str CHI-B60058 mod
     #CALL cl_err('upd apa44/apf44:','aap-161',1)
     #IF g_bgjob = 'Y' THEN #FUN-D40105 mark
         CALL s_errmsg('','','(upd apa44/apf44)','aap-161',1)
     #FUN-D40105--mark--str--
     #ELSE
     #   CALL cl_err('upd apa44/apf44:','aap-161',1)
     #END IF
     #FUN-D40105--mark--end--
     #end CHI-B60058 mod
      LET g_success='N'
     #RETURN   #CHI-B60058 mark
   END IF
   #----------------------------------------------------------------------
  #FUN-D40105--mark--str--
  #UPDATE npp_file SET npp03   = NULL,
  #                    nppglno = NULL,
  #                    npp06   = NULL,
  #                    npp07   = NULL
  #   WHERE nppglno=g_existno
  #   AND npptype = '0'          #No.FUN-680029
  #   AND npp07 = g_apz.apz02b   #No.FUN-680029
  #FUN-D40105--mark--end--
   #FUN-D40105--add--str--
   LET g_sql = "UPDATE npp_file SET npp03= NULL,nppglno = NULL,npp06 = NULL,npp07 = NULL",
               " WHERE ",tm.wc1,
               " AND npptype = '0'",
               " AND npp07 ='", g_apz.apz02b,"'"
   PREPARE p409_pre_9 FROM g_sql
   EXECUTE p409_pre_9
   #FUN-D40105--add--end--
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
#     CALL cl_err('(upd npp03)',STATUS,1)    #No.FUN-660122
     #str CHI-B60058 mod
     #CALL cl_err3("upd","npp_file",g_existno,"",STATUS,"","upd npp03",1)  #No.FUN-660122
     #IF g_bgjob = 'Y' THEN  #FUN-D40105 mark
         CALL s_errmsg('','','(upd npp03)',STATUS,1)
     #FUN-D40105--mark--str--
     #ELSE
     #   CALL cl_err3("upd","npp_file",g_existno,"",STATUS,"","upd npp03",1)
     #END IF
     #FUN-D40105--mark--str--
     #end CHI-B60058 mod
      LET g_success='N'
     #RETURN   #CHI-B60058 mark
   END IF
  #No.FUN-CB0096 ---start--- Add
   LET l_time = TIME
   #FUN-D40105--add--str--
   IF l_time = l_time_t   THEN
      LET l_time = l_time + 1
   END IF
   LET l_time_t = l_time
   #FUN-D40105--add--end--
   LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
   CALL s_log_data('I','114',g_id,'2',l_time,g_existno,'')
  #No.FUN-CB0096 ---end  --- Add
END FUNCTION
 
#No.FUN-680029 --start--
FUNCTION p409_t_1()
   DEFINE n1,n2,n3    LIKE type_file.num10   #No.FUN-690028 INTEGER 
   DEFINE l_npp         RECORD LIKE npp_file.*   
   DEFINE l_apf01       LIKE apf_file.apf01,
          l_cnt         LIKE type_file.num5    #No.FUN-690028 SMALLINT

   LET tm.wc1 = "aba01 IN (",g_existno1_str,")"  #FUN-D40105  add 

   IF g_aaz84 = '2' THEN   #還原方式為作廢
     #LET g_sql="UPDATE ",g_dbs_gl," aba_file  SET abaacti = 'N' ",   #FUN-A50102
      LET g_sql="UPDATE ",cl_get_target_table(p_plant,'aba_file'),    #FUN-A50102
                 "   SET abaacti = 'N'",                   #FUN-D40105 add
                 #" WHERE aba01 = ? AND aba00 = ? "        #FUN-D40105 mark
                 " WHERE  aba00 = ? ",                     #FUN-D40105 add
                 "   AND ",tm.wc1                          #FUN-D40105 add
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
      CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql   #FUN-A50102
      PREPARE p409_updaba_p1 FROM g_sql
      #EXECUTE p409_2_p6 USING g_existno1,g_apz.apz02c   #FUN-D40105 mark
      EXECUTE p409_updaba_p1 USING g_apz.apz02c   #FUN-D40105  add
      IF SQLCA.sqlcode THEN
        #str CHI-B60058 mod
        #CALL cl_err('(upd abaacti)',SQLCA.sqlcode,1)
        #IF g_bgjob = 'Y' THEN  #FUN-D40105 mark
            CALL s_errmsg('','','(upd abaacti)',SQLCA.sqlcode,1)
        #FUN-D40105--mark--str--
        #ELSE
        #   CALL cl_err3("upd","aba_file",g_existno1,"",SQLCA.sqlcode,"","upd abaacti",1)
        #END IF
        #FUN-D40105--mark--str--
        #end CHI-B60058 mod
         LET g_success='N'
        #RETURN   #CHI-B60058 mark
      END IF
   ELSE
      IF g_bgjob = 'N' THEN 
         DISPLAY "Delete GL's Voucher body!" AT 1,1 #-------------------------
      END IF   
      LET tm.wc1 = cl_replace_str(tm.wc1,"aba01","abb01")          #FUN-D40105 add
     #LET g_sql="DELETE FROM ",g_dbs_gl,"abb_file WHERE abb01=? AND abb00=?"   #FUN-A50102
      LET g_sql="DELETE FROM ",cl_get_target_table(p_plant,'abb_file'),        #FUN-A50102
               #" WHERE abb01=? AND abb00=?"     #FUN-A50102  #FUN-D40105 mark
                 " WHERE  abb00=?",                #FUN-D40105 add
                 "   AND ",tm.wc1                  #FUN-D40105 add
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
      CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql   #FUN-A50102
      PREPARE p409_2_p6 FROM g_sql
      #EXECUTE p409_2_p6 USING g_existno1,g_apz.apz02c   #FUN-D40105 mark
      EXECUTE p409_2_p6 USING g_apz.apz02c     #FUN-D40105 add
      IF SQLCA.sqlcode THEN
        #str CHI-B60058 mod
        #CALL cl_err('(del abb)',SQLCA.sqlcode,1)
        #IF g_bgjob = 'Y' THEN  #FUN-D40105 mark
            CALL s_errmsg('','','(del abb)',SQLCA.sqlcode,1)
        #FUN-D40105--mark--str--
        #ELSE
        #   CALL cl_err3("del","abb_file",g_existno1,"",SQLCA.sqlcode,"","del abb_file",1)
        #END IF
        #FUN-D40105--mark--end--
        #end CHI-B60058 mod
         LET g_success='N'
        #RETURN   #CHI-B60058 mark
      END IF
      IF g_bgjob = 'N' THEN
         DISPLAY "Delete GL's Voucher head!" AT 1,1
      END IF
     #LET g_sql="DELETE FROM ",g_dbs_gl,"aba_file WHERE aba01=? AND aba00=?"   #FUN-A50102
      LET tm.wc1 = cl_replace_str(tm.wc1,"abb01","aba01")          #FUN-D40105 add
      LET g_sql="DELETE FROM ",cl_get_target_table(p_plant,'aba_file'),   #FUN-A50102
               #" WHERE aba01=? AND aba00=?"    #FUN-A50102  #FUN-D40105 mark
                " WHERE  aba00=?",               #FUN-D40105 add
                "   AND ",tm.wc1                 #FUN-D40105 add
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
      CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql   #FUN-A50102
      PREPARE p409_2_p7 FROM g_sql
     #EXECUTE p409_2_p7 USING g_existno1,g_apz.apz02c  #FUN-D40105 mark
      EXECUTE p409_2_p7 USING g_apz.apz02c     #FUN-D40105 add
      IF SQLCA.sqlcode THEN
        #str CHI-B60058 mod
        #CALL cl_err('(del aba)',SQLCA.sqlcode,1)
        #IF g_bgjob = 'Y' THEN  #FUN-D40105 mark
            CALL s_errmsg('','','(del aba)',SQLCA.sqlcode,1)
        #FUN-D40105--mark--str--
        #ELSE
        #   CALL cl_err3("del","aba_file",g_existno1,"",SQLCA.sqlcode,"","del aba_file",1)
        #END IF
        #FUN-D40105--mark--end--
        #end CHI-B60058 mod
         LET g_success='N'
        #RETURN   #CHI-B60058 mark
      END IF
      IF SQLCA.sqlerrd[3] = 0 THEN
        #str CHI-B60058 mod
        #CALL cl_err('(del aba)','aap-161',1)
        #IF g_bgjob = 'Y' THEN  #FUN-D40105 mark
            CALL s_errmsg('','','(del aba)','aap-161',1)
        #FUN-D40105--mark--str--
        #ELSE
        #   CALL cl_err3("del","aba_file",g_existno1,"",'aap-161',"","del aba_file",1)
        #END IF
        #FUN-D40105--mark--end--
        #end CHI-B60058 mod
         LET g_success='N'
        #RETURN   #CHI-B60058 mark
      END IF
      IF g_bgjob = 'N' THEN
         DISPLAY "Delete GL's Voucher desp!" AT 1,1
      END IF
     #LET g_sql="DELETE FROM ",g_dbs_gl,"abc_file WHERE abc01=? AND abc00=?"   #FUN-A50102
      LET tm.wc1 = cl_replace_str(tm.wc1,"aba01","abc01")          #FUN-D40105 add
      LET g_sql="DELETE FROM ",cl_get_target_table(p_plant,'abc_file'),   #FUN-A50102
               #" WHERE abc01=? AND abc00=?"   #FUN-A50102  #FUN-D40105 mark 
                " WHERE  abc00=?",              #FUN-D40105 add
                "   AND ",tm.wc1                #FUN-D40105 add
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
      CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql   #FUN-A50102
      PREPARE p409_2_p8 FROM g_sql
     #EXECUTE p409_2_p8 USING g_existno1,g_apz.apz02c #FUN-D40105 mark
      EXECUTE p409_2_p8 USING g_apz.apz02c             #FUN-D40105 add
      IF SQLCA.sqlcode THEN
        #str CHI-B60058 mod
        #CALL cl_err('(del abc)',SQLCA.sqlcode,1)
        #IF g_bgjob = 'Y' THEN     #FUN-D40105 mark
            CALL s_errmsg('','','(del abc)',SQLCA.sqlcode,1)
        #FUN-D40105--mark--str--
        #ELSE
        #   CALL cl_err3("del","abc_file",g_existno1,"",SQLCA.sqlcode,"","del abc_file",1)
        #END IF
        #FUN-D40105--mark--end--
        #end CHI-B60058 mod
         LET g_success='N'
        #RETURN   #CHI-B60058 mark
      END IF
     #--------------------------------MOD-C20146------------------------------------------start
      LET l_cnt = 0
      LET tm.wc1 = cl_replace_str(tm.wc1,"abc01","tic04")          #FUN-D40105 add
      LET g_sql="SELECT COUNT(*) FROM ",cl_get_target_table(p_plant,'tic_file'),
               #" WHERE tic04 =? AND tic00 =?"  #FUN-D40105 mark 
                " WHERE  tic00 =?",             #FUN-D40105 add 
                "   AND ",tm.wc1                #FUN-D40105 add
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql
      PREPARE p409_2_p12 FROM g_sql
     #EXECUTE p409_2_p12 USING g_existno1,g_apz.apz02c INTO l_cnt    #FUN-D40105 mark
      EXECUTE p409_2_p12 USING g_apz.apz02c INTO l_cnt    #FUN-D40105 add
      IF l_cnt > 0 THEN
     #--------------------------------MOD-C20146--------------------------------------------end
        #FUN-B40056 -begin
         LET g_sql="DELETE FROM ",cl_get_target_table(p_plant,'tic_file'),  
                   #" WHERE tic04 =? AND tic00 =?" #FUN-D40105 mark
                   " WHERE  tic00 =?",             #FUN-D40105 add
                   "   AND ",tm.wc1                #FUN-D40105 add
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql       
         CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql
         PREPARE p409_2_p9 FROM g_sql
        #EXECUTE p409_2_p9 USING g_existno1,g_apz.apz02c   #FUN-D40105 mark
         EXECUTE p409_2_p9 USING g_apz.apz02c    #FUN-D40105 add
         IF SQLCA.sqlcode THEN
           #str CHI-B60058 mod
           #CALL cl_err('(del tic)',SQLCA.sqlcode,1)
           #IF g_bgjob = 'Y' THEN  #FUN-D40105 mark
               CALL s_errmsg('','','(del tic)',SQLCA.sqlcode,1)
           #FUN-D40105--mark--str--
           #ELSE
           #   CALL cl_err3("del","tic_file",g_existno,"",SQLCA.sqlcode,"","del tic_file",1)
           #END IF
           #FUN-D40105--mark--end--
           #end CHI-B60058 mod
            LET g_success = 'N'
           #RETURN   #CHI-B60058 mark
         END IF
        #FUN-B40056 -end 
      END IF                            #MOD-C20146     
   END IF
 
   IF g_success = 'N' THEN RETURN END IF
   LET g_msg = TIME
   #INSERT INTO azo_file (azo01,azo02,azo03,azo04,azo05,azo06) #FUN-980001 mark
   #   VALUES('aapp409',g_user,g_today,g_msg,g_existno1,'delete') #FUN-980001 mark
   INSERT INTO azo_file (azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal)  #FUN-980001 add
      VALUES('aapp409',g_user,g_today,g_msg,g_existno1,'delete',g_plant,g_legal) #FUN-980001 add
 
  #FUN-D40105--mark--str--
  #UPDATE npp_file SET npp03   = NULL,
  #                    nppglno = NULL,
  #                    npp06   = NULL,
  #                    npp07   = NULL
  #   WHERE nppglno=g_existno1
  #   AND npptype = '1'         
  #   AND npp07 = g_apz.apz02c  
  #FUN-D40105--mark--end--
   #FUN-D40105--add--str--
   IF g_aaz84 = '2' THEN
      LET tm.wc1 = cl_replace_str(tm.wc1,"aba01","nppglno")
   ELSE
      LET tm.wc1 = cl_replace_str(tm.wc1,"tic04","nppglno")
   END IF
   LET g_sql = "UPDATE npp_file SET npp03= NULL,nppglno = NULL,npp06 = NULL,npp07 = NULL",
               " WHERE ",tm.wc1,
               "   AND npptype = '1' ",
               "   AND npp07 ='",g_apz.apz02c,"'"
   PREPARE p409_pre_10 FROM g_sql
   EXECUTE p409_pre_10
   #FUN-D40105--add--end--
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
     #str CHI-B60058 mod
     #CALL cl_err3("upd","npp_file",g_existno1,"",STATUS,"","upd npp03",1)  #No.FUN-660122
     #IF g_bgjob = 'Y' THEN     #FUN-D40105 mark
         CALL s_errmsg('','','(upd npp03)',STATUS,1)
     #FUN-D40105--mark--str--
     #ELSE
     #   CALL cl_err3("upd","npp_file",g_existno1,"",STATUS,"","upd npp03",1)
     #END IF
     #FUN-D40105--mark--end--
     #end CHI-B60058 mod
      LET g_success='N'
     #RETURN   #CHI-B60058 mark
   END IF
  #No.FUN-CB0096 ---start--- Add
   LET l_time = TIME
   #FUN-D40105--add--str--
   IF l_time = l_time_t   THEN
      LET l_time = l_time + 1
   END IF
   LET l_time_t = l_time
   #FUN-D40105--add--end--
   LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
   CALL s_log_data('I','114',g_id,'2',l_time,g_existno,'')
  #No.FUN-CB0096 ---end  --- Add
END FUNCTION
#No.FUN-680029 --end--


#FUN-D40105--add--str--
FUNCTION p409_existno_chk()
   DEFINE   l_chk_bookno       LIKE type_file.num5
   DEFINE   l_chk_bookno1      LIKE type_file.num5
   DEFINE   l_abapost,l_flag   LIKE type_file.chr1
   DEFINE   l_aba19            LIKE aba_file.aba19
   DEFINE   l_abaacti          LIKE aba_file.abaacti
   DEFINE   l_aba01            LIKE aba_file.aba01
   DEFINE   l_aba00            LIKE aba_file.aba00
   DEFINE   l_aaa07            LIKE aaa_file.aaa07
   DEFINE   l_npp00            LIKE npp_file.npp00
   DEFINE   l_npp01            LIKE npp_file.npp01
   DEFINE   l_npp07            LIKE npp_file.npp07
   DEFINE   l_nppglno          LIKE npp_file.nppglno
   DEFINE   l_cnt              LIKE type_file.num5
   DEFINE   lc_cmd             LIKE type_file.chr1000
   DEFINE   l_sql              STRING
   DEFINE   l_cnt1             LIKE type_file.num5
   DEFINE   l_aba20            LIKE aba_file.aba20

   CALL s_showmsg_init()
   LET g_existno1 = NULL
   LET g_success = 'Y'
   LET tm.wc1 = cl_replace_str(tm.wc1,"g_existno","aba01")
   LET g_sql="SELECT aba01,aba00,aba02,aba03,aba04,abapost,aba19,abaacti,aba20 FROM ",
             cl_get_target_table(p_plant,'aba_file'),
             " WHERE aba00 = ? AND aba06='AP'" CLIPPED,
             "   AND ",tm.wc1
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql
   PREPARE p409_t_p1_1 FROM g_sql
   DECLARE p409_t_c1_1 CURSOR FOR p409_t_p1_1
     IF STATUS THEN
        CALL s_errmsg('decl aba_cursor:',l_aba01,'',STATUS,1)
        LET g_success = 'N'
     END IF
     FOREACH  p409_t_c1_1 USING g_apz.apz02b INTO l_aba01,l_aba00,gl_date,gl_yy,gl_mm,l_abapost,l_aba19,
                                                l_abaacti,l_aba20
         IF STATUS THEN
            CALL s_errmsg('sel aba:',l_aba01,'',STATUS,1)
            LET g_success = 'N'
         END IF
         IF l_abaacti = 'N' THEN
            CALL s_errmsg('',l_aba01,'','mfg8001',1)
            LET g_success = 'N'
         END IF
         IF l_aba20 MATCHES '[Ss1]' THEN
            CALL s_errmsg('',l_aba01,'','mfg3557',1)
            LET g_success = 'N'
         END IF
         LET g_sql="SELECT aaa07 FROM ",cl_get_target_table(p_plant,'aaa_file'),
                   " WHERE aaa01='",l_aba00,"'"
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql
         CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql
         PREPARE p409_x_gl_p1_1 FROM g_sql
         DECLARE p409_c_gl_p1_1 CURSOR FOR p409_x_gl_p1_1
         OPEN p409_c_gl_p1_1
         FETCH p409_c_gl_p1_1 INTO l_aaa07
         IF gl_date <= l_aaa07 THEN
            CALL s_errmsg(gl_date,l_aba01,'','agl-200',1)
            LET g_success = 'N'
         END IF
         #重新抓取關帳日期
            LET g_sql ="SELECT apz57 FROM apz_file ",
                       " WHERE apz00 = '0'"
            PREPARE t600_apz57_p2_1 FROM g_sql
            EXECUTE t600_apz57_p2_1 INTO g_apz.apz57
            #傳票日期小於系統之關帳日,不可還原
            IF gl_date < g_apz.apz57 THEN
               CALL s_errmsg('',l_aba01,'','aap-027',1)
               LET g_success = 'N'
            END IF
            IF l_abapost = 'Y' THEN
               CALL s_errmsg('',l_aba01,'','aap-130',1)
               LET g_success = 'N'
            END IF
            #Modi:已確認傳票不能做還原
            IF l_aba19 ='Y' THEN
               CALL s_errmsg('',l_aba01,'','aap-026',1)
               LET g_success = 'N'
            END IF
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt
              FROM amd_file
             WHERE amd28 = l_aba01
            IF l_cnt > 0 THEN
               CALL s_errmsg('',l_aba01,'','amd-030',1)
               LET g_success = 'N'
            END IF
            #-MOD-A80246-end-
            #若為付款單之傳票，付款類別為支票時，
            #已開票則不可還原
            LET l_cnt = 0
            DECLARE npp00_cs_1 CURSOR FOR          #改成多筆處理
             SELECT npp00,npp01 FROM npp_file
              WHERE nppsys='AP' AND npp011 = 1 AND nppglno = l_aba01 AND npptype ='0'
            FOREACH npp00_cs_1 INTO l_npp00,l_npp01
               IF STATUS THEN
                  CALL s_errmsg('foreach:npp00_cs',g_existno,'',STATUS,1)
               ELSE
                  #IF l_npp00 = '3' THEN #付款單
                  IF l_npp00 = '3' AND g_nmz.nmz05 = 'Y' THEN
                     SELECT COUNT(*) INTO g_cnt FROM aph_file
                      WHERE aph01 = l_npp01
                        AND aph03 = '1' #支票
                        AND aph09 = 'Y' #已開票
                     IF g_cnt > 0 THEN
                        CALL s_errmsg('',l_aba01,'','aap-998',1)
                        LET l_cnt = l_cnt + 1
                     END IF
                  END IF
                  #單據若已做付款沖帳，則不可還原
                  LET l_cnt = 0   LET l_cnt1 = 0
                  SELECT COUNT(*) INTO l_cnt FROM apg_file,apf_file
                   WHERE apg04 = l_npp01 AND apf01 = apg01
                     AND apf41 != 'X'
                     AND apf00  = '33'
                     AND apf44 != g_existno
                  SELECT COUNT(*) INTO l_cnt1 FROM aph_file,apf_file
                   WHERE aph04 = l_npp01 AND apf01 = aph01
                     AND apf41 != 'X'
                     AND apf00  = '33'
                     AND apf44 != l_aba01
                  IF l_cnt + l_cnt1 > 0 THEN
                     CALL s_errmsg('',l_aba01,'','agl-910',1)
                  END IF
               END IF
            END FOREACH
            IF l_cnt > 0 THEN
               LET g_success = 'N'
            END IF
      END FOREACH
      IF g_aza.aza63 = 'Y' THEN
         LET tm.wc1 = cl_replace_str(tm.wc1,"aba01","nppglno")
         LET g_sql = "SELECT UNIQUE npp07,nppglno  ",
                     "  FROM npp_file",
                     "  WHERE npp01 IN (SELECT npp01 FROM npp_file ",
                     "  WHERE npp07 = '",p_acc,"'",
                     "    AND npptype = '0' ",
                     "    AND ",tm.wc1,
                     " )",
                     "    AND npptype = '1'"
         PREPARE p409_pre_chk1 FROM g_sql
         DECLARE p409_c_chk1 CURSOR FOR p409_pre_chk1
         FOREACH p409_c_chk1 INTO l_npp07,l_nppglno
            IF cl_null(l_npp07) OR cl_null(l_nppglno) THEN
               #CALL s_errmsg('',l_aba01,'','aap-986',1)    #TQC-D60072 mark
               CALL s_errmsg('',l_nppglno,'','aap-986',1)   #TQC-D60072 add
               LET g_success = 'N'
            END IF
            LET g_sql="SELECT aba01,aba00,aba02,aba03,aba04,abapost,aba19,abaacti,aba20 FROM ",
                       cl_get_target_table(p_plant,'aba_file'),
                       " WHERE aba01 = ? AND aba00 = ? AND aba06='AP'" CLIPPED
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql
            CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql
            PREPARE p409_t_p1_2 FROM g_sql
            DECLARE p409_t_c1_2 CURSOR FOR p409_t_p1_2
            FOREACH p409_t_c1_2 USING l_nppglno,l_npp07
                                 INTO l_aba01,l_aba00,gl_date,gl_yy,gl_mm,l_abapost,l_aba19,
                                      l_abaacti,l_aba20
               IF STATUS THEN
                  CALL s_errmsg('sel aba:',l_nppglno,'',STATUS,1)
                  LET g_success = 'N'
               END IF
               IF l_abaacti = 'N' THEN
                  CALL s_errmsg('',l_nppglno,'','mfg8003',1)
                  LET g_success = 'N'
               END IF

               IF l_aba20 MATCHES '[Ss1]' THEN
                  CALL s_errmsg('',l_nppglno,'','mfg3557',1)
                  LET g_success = 'N'
               END IF

               LET g_sql="SELECT aaa07 FROM ",cl_get_target_table(p_plant,'aaa_file'),
                         " WHERE aaa01='",l_aba00,"'"
               CALL cl_replace_sqldb(g_sql) RETURNING g_sql
               CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql
               PREPARE p409_x_gl_p2_1 FROM g_sql
               DECLARE p409_c_gl_p2_1 CURSOR FOR p409_x_gl_p2_1
               OPEN p409_c_gl_p2_1
               FETCH p409_c_gl_p2_1 INTO l_aaa07
               IF gl_date <= l_aaa07 THEN
                  CALL s_errmsg(gl_date,l_nppglno,'','agl-200',1)
                  LET g_success = 'N'
               END IF
               IF gl_date < g_apz.apz57 THEN
                  CALL s_errmsg('',l_nppglno,'','aap-027',1)
                  LET g_success = 'N'
               END IF
               IF l_abapost = 'Y' THEN
                  CALL s_errmsg('',l_nppglno,'','aap-132',1)
                  LET g_success = 'N'
               END IF
               IF l_aba19 ='Y' THEN
                  CALL s_errmsg(l_nppglno,l_aba01,'','anm-116',1)
                  LET g_success = 'N'
               END IF
               LET l_cnt = 0
               DECLARE npp00_cs1_1 CURSOR FOR
                SELECT npp00,npp01 FROM npp_file
                 WHERE nppsys='AP' AND npp011 = 1 AND nppglno = l_nppglno AND npptype ='1' #No.MOD-B20015
               FOREACH npp00_cs1_1 INTO l_npp00,l_npp01
                  IF STATUS THEN
                     CALL s_errmsg('foreach:npp00_cs',g_existno,'',STATUS,1)
                  ELSE
                     IF l_npp00 = '3' AND g_nmz.nmz05 = 'Y' THEN
                        SELECT COUNT(*) INTO g_cnt FROM aph_file
                         WHERE aph01 = l_npp01
                           AND aph03 = '1'
                           AND aph09 = 'Y'
                        IF g_cnt > 0 THEN
                           CALL s_errmsg('',l_nppglno,'','aap-998',1)
                           LET l_cnt = l_cnt + 1
                           EXIT FOREACH
                        END IF
                     END IF
                     #MOD-990182---add---start---
                     #單據若已做付款沖帳，則不可還原
                     LET l_cnt = 0   LET l_cnt1 = 0
                     SELECT COUNT(*) INTO l_cnt FROM apg_file,apf_file
                      WHERE apg04 = l_npp01 AND apf01 = apg01
                        AND apf41 != 'X'
                        AND apf00  = '33'
                        AND apf44 != l_nppglno
                     SELECT COUNT(*) INTO l_cnt1 FROM aph_file,apf_file
                      WHERE aph04 = l_npp01 AND apf01 = aph01
                        AND apf41 != 'X'
                        AND apf00  = '33'
                        AND apf44 != l_nppglno
                     IF l_cnt + l_cnt1 > 0 THEN
                        CALL s_errmsg('',l_nppglno,'','agl-910',1)
                        LET g_success = 'N'
                        RETURN
                     END IF
                  END IF
               END FOREACH
               IF l_cnt > 0 THEN
                  LET g_success = 'N'
               END IF
            END FOREACH
            IF cl_null(g_existno1) THEN
               LET g_existno1 = "'",l_nppglno,"'"
               LET g_existno1_str = g_existno1
            ELSE
               LET g_existno1_str = g_existno1_str,",","'",l_nppglno,"'"

            END IF
         END FOREACH
     END IF
     LET p_acc1 = l_npp07
     DISPLAY l_npp07 TO FORMONLY.p_acc1
     DISPLAY g_existno1_str TO FORMONLY.g_existno1
END FUNCTION
#FUN-D40105--add--end--
