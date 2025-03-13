# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: axcp702.4gl
# Descriptions...: 報工單工時轉成會每日工時作業
# Date & Author..: 06/01/24 By Sarah
# Modify.........: No.FUN-610080 06/01/24 By Sarah
# Modify.........: No.FUN-640165 06/04/13 By Sarah 備註srl08改成給"報工單號:srf01,' ',srg02 using '###'"
# Modify.........: No.FUN-680122 06/08/30 By zdyllq 類型轉換  
# Modify.........: No.FUN-690125 06/10/16 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0146 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.CHI-970021 09/08/21 By jan insert into srl_file時，增加srl09的賦值
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-9A0021 09/10/15 By Lilan 將YEAR/MONTH的語法改成用BETWEEN語法 
# Modify.........: No.FUN-950008 10/02/23 By vealxu 新增自動確認checkbox欄位
# Modify.........: No.FUN-C80092 12/12/05 By lixh1 增加寫入日誌功能
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm RECORD
          yy LIKE type_file.num5,           #No.FUN-680122 smallint,
          mm LIKE type_file.num5            #No.FUN-680122 smallint
         ,check LIKE type_file.chr1         #No.FUN-950008 VARCHAR(1)
          END RECORD
DEFINE g_row,g_col   LIKE type_file.num5    #No.FUN-680122 smallint
DEFINE g_flag  LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
DEFINE g_srkfirm LIKE type_file.chr1        #No.FUN-950008 VARCHAR(1)
DEFINE g_cka00   LIKE cka_file.cka00        #FUN-C80092
DEFINE l_msg     STRING                     #FUN-C80092
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690125 BY dxfwo 
 
   LET g_row = 4 LET g_col = 38
 
   OPEN WINDOW p702_w AT g_row,g_col WITH FORM "axc/42f/axcp702"  
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
   CALL p702_tm(0,0)
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
END MAIN
 
FUNCTION p702_tm(p_row,p_col)
   DEFINE   p_row,p_col   LIKE type_file.num5          #No.FUN-680122 SMALLINT
 
   CALL cl_opmsg('z')
 
   WHILE TRUE
      MESSAGE ""
      IF s_shut(0) THEN
         RETURN
      END IF
      CLEAR FORM 
      INITIALIZE tm.* TO NULL			# Default condition
      LET tm.yy = YEAR (TODAY)
      LET tm.mm = MONTH(TODAY)
      LET tm.check = 'N'           #FUN-950008 add
      LET g_srkfirm = 'N'          #FUN-950008 add
 
      INPUT BY NAME tm.yy,tm.mm,tm.check WITHOUT DEFAULTS   #FUN-950008 add check
 
         AFTER FIELD yy
            IF tm.yy IS NULL OR tm.yy < 0 THEN
               NEXT FIELD yy
            END IF
 
         AFTER FIELD mm
            IF tm.mm IS NULL THEN
               NEXT FIELD mm 
            END IF
            IF tm.mm < 1 OR tm.mm > 12 THEN
               NEXT FIELD mm
            END IF
 
         #No.FUN-950008 ---start---
         AFTER FIELD check
            IF tm.check = 'Y' THEN
              LET g_srkfirm = 'Y'
            END IF 
         #No.FUN-950008 ---end---

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
 
         ON ACTION locale                    #genero
            LET g_action_choice = "locale"
            CALL cl_show_fld_cont()          #No.FUN-550037 hmf
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
      IF INT_FLAG THEN
         LET INT_FLAG = 0 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
         EXIT PROGRAM
            
      END IF
      IF g_action_choice = "locale" THEN  #genero
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
 
      IF cl_sure(21,21) THEN   #genero
   #FUN-C80092 -------------Begin---------------
         LET l_msg = "tm.yy = '",tm.yy,"'",";","tm.mm = '",tm.mm,"'",";",
                     "tm.check = '",tm.check,"'"
         CALL s_log_ins(g_prog,tm.yy,tm.mm,'',l_msg)
              RETURNING g_cka00
   #FUN-C80092 -------------End-----------------
         BEGIN WORK
         LET g_success='Y'
         CALL axcp702()
         #genero
         IF g_success = 'Y' THEN
            COMMIT WORK
            CALL s_log_upd(g_cka00,'Y')             #更新日誌  #FUN-C80092
            CALL cl_end2(1) RETURNING g_flag        #批次作業正確結束
         ELSE
            ROLLBACK WORK
            CALL s_log_upd(g_cka00,'N')             #更新日誌  #FUN-C80092
            CALL cl_end2(2) RETURNING g_flag        #批次作業失敗
         END IF
         IF g_flag THEN
             CALL p702_tm(0,0)
         ELSE
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
             EXIT PROGRAM
         END IF
         #genero
 
      END IF
      #CALL cl_end(0,0)
   END WHILE
 
   ERROR ""
   CLOSE WINDOW p702_w
END FUNCTION
 
FUNCTION axcp702()
#     DEFINE   l_time LIKE type_file.chr8	    #No.FUN-6A0146
     DEFINE    l_eca03       LIKE eca_file.eca03,    # 工作站所屬部門別
               l_sql	     LIKE type_file.chr1000, #No.FUN-680122 VARCHAR(500),
               l_srl06       LIKE srl_file.srl06,
               l_msg         STRING,                 #FUN-640165 add
               srf           RECORD LIKE srf_file.*,
               srg           RECORD LIKE srg_file.*,
               srk           RECORD LIKE srk_file.*,
               srl           RECORD LIKE srl_file.* 
     DEFINE    l_bdate       LIKE type_file.dat      #CHI-9A0021 add
     DEFINE    l_edate       LIKE type_file.dat      #CHI-9A0021 add
     DEFINE    l_correct     LIKE type_file.chr1     #CHI-9A0021 add
 
    #當月起始日與截止日
     CALL s_azm(tm.yy,tm.mm) RETURNING l_correct,l_bdate,l_edate   #CHI-9A0021 add

     DELETE FROM srk_file
    #WHERE YEAR(srk01) = tm.yy AND MONTH(srk01) = tm.mm  #CHI-9A0021
     WHERE srk01 BETWEEN l_bdate AND l_edate             #CHI-9A0021
     IF SQLCA.sqlcode THEN 
        ERROR "DELETE FROM srk_file ERROR:",SQLCA.sqlcode 
        LET g_success='N'
        #ROLLBACK WORK
        #EXIT PROGRAM
     END IF 
 
     DELETE FROM srl_file 
    #WHERE YEAR(srl01) = tm.yy AND MONTH(srl01) = tm.mm  #CHI-9A0021
     WHERE srl01 BETWEEN l_bdate AND l_edate             #CHI-9A0021
     IF SQLCA.sqlcode THEN 
        ERROR "DELETE FROM srl_file ERROR:",SQLCA.sqlcode 
        LET g_success='N'
        #ROLLBACK WORK
        #EXIT PROGRAM
     END IF 
 
     INITIALIZE srf.* TO NULL
     INITIALIZE srg.* TO NULL
 
     LET l_sql = "SELECT * FROM srf_file,srg_file ",
                 " WHERE srf01=srg01 ",
                 "   AND srfconf='Y' ",
                #CHI-9A0021 --begin
                #"   AND YEAR(srf02)  = ",tm.yy,
                #"   AND MONTH(srf02) = ",tm.mm
                 "   AND srf02 BETWEEN '",l_bdate,"' AND '",l_edate,"'"
                #CHI-9A0021 --end
     PREPARE p702_prepare FROM l_sql
     DECLARE p702_cur CURSOR FOR p702_prepare
     FOREACH p702_cur INTO srf.*,srg.*
        IF SQLCA.sqlcode THEN 
           CALL cl_err('',STATUS,0) 
           LET g_success='N'
           #EXIT PROGRAM
        END IF 
 
        IF cl_null(srg.srg10) THEN LET srg.srg10 = 0 END IF    #工時(分)
        MESSAGE 'Transfer Note:',srg.srg01              #報工單號
 
        CALL ui.Interface.refresh()
        INITIALIZE srk.* TO NULL
        INITIALIZE srl.* TO NULL
 
        LET srk.srk01 = srf.srf02                       #報工日期
        SELECT eca03 INTO l_eca03 FROM eca_file,eci_file
         WHERE eca01 = eci03 AND eci01 = srf.srf03
        LET srk.srk02 = l_eca03                         #成本中心
        LET srk.srk03 = ''                              #備註
        LET srk.srk04 = ''                              #NO USE
        LET srk.srk05 = 0                               #工時合計
#       LET srk.srkfirm = 'Y'                           #確認碼       #FUN-950008 mark
        LET srk.srkfirm = g_srkfirm                                   #FUN-950008 add 
        LET srk.srkinpd = g_today                       #輸入日期                                
        LET srk.srkacti = 'Y'                           #資料有效碼
        LET srk.srkuser = g_user                        #資料所有者
        LET srk.srkgrup = g_grup                        #資料所有群
        LET srk.srkmodu = ''                            #資料更改者                              
        LET srk.srkdate = g_today                       #最近修改日
     
        LET srl.srl01 = srf.srf02                       #報工日期
        LET srl.srl02 = l_eca03                         #成本中心
        LET srl.srl09 = srg.srg19/60                    #投入機時 #CHI-970021
        SELECT max(srl03) INTO srl.srl03 FROM srl_file  #序號
        WHERE srl01 = srl.srl01 AND srl02 = srl.srl02 
        IF cl_null(srl.srl03) OR (srl.srl03 = 0) THEN
           LET srl.srl03 = 1
        ELSE
           LET srl.srl03 = srl.srl03 + 1
        END IF 
        LET srl.srl04 = srg.srg03                       #產品編號
        LET srl.srl05 = srg.srg10/60                    #投入工時
        LET srl.srl06 = srg.srg05+srg.srg06+srg.srg07   #生產數量
        LET srl.srl07 = 0                               #NO USE
       #start FUN-640165
       #LET srl.srl08 = ' '                             #備註
        CALL cl_get_feldname('srf01',g_lang) RETURNING l_msg 
        LET srl.srl08 = l_msg,":",srf.srf01,' ',srg.srg02 using '###'        #備註
       #end FUN-640165
        IF cl_null(srl.srl05) THEN LET srl.srl05 = 0 END IF
        IF srl.srl03 = 1 THEN
           LET srk.srkoriu = g_user      #No.FUN-980030 10/01/04
           LET srk.srkorig = g_grup      #No.FUN-980030 10/01/04
           INSERT INTO srk_file VALUES(srk.*)
           IF SQLCA.sqlcode THEN
              ERROR "INSERT INTO srk_file ERROR:",SQLCA.sqlcode 
              LET g_success='N'
              EXIT FOREACH
              #ROLLBACK WORK
              #EXIT PROGRAM
           END IF 
        END IF 
        INSERT INTO srl_file VALUES(srl.*)
        IF SQLCA.sqlcode THEN
           ERROR "INSERT INTO srl_file ERROR:",SQLCA.sqlcode 
           LET g_success='N'
           EXIT FOREACH
           #ROLLBACK WORK
           #EXIT PROGRAM
        END IF 
 
        #更新單頭工時合計(srk05)欄位
        SELECT SUM(srl05) INTO srk.srk05 FROM srl_file 
         WHERE srl01 = srl.srl01 AND srl02 = srl.srl02
        IF cl_null(srk.srk05) THEN LET srk.srk05 = 0 END IF 
        UPDATE srk_file SET srk05 = srk.srk05 
         WHERE srk01 = srk.srk01 AND srk02 = srk.srk02
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
           #ROLLBACK WORK    #genero
           ERROR "UPDATE srk_file.srk05 ERROR:",SQLCA.sqlcode 
           LET g_success='N'
           EXIT FOREACH
           #EXIT PROGRAM     #genero 
        END IF 
     END FOREACH
END FUNCTION
