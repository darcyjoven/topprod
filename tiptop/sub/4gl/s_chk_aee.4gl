# Prog. Version..: '5.30.06-13.03.15(00008)'     #
#
# Program name...: s_chk_aee.4gl
# Descriptions...: 檢核異動碼值是否正確
# Date & Author..: 
# Modify.........: No.MOD-640131 06/04/10 By Sarah 若異動碼是設定QRY查詢方式,這邊會永遠檢查不到,所以先把判斷l_aeeacti='N'與SQLCA.sqlcode = 100拿掉
# Modify.........: No.FUN-680147 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.MOD-6A0041 06/10/14 By Smapmin 異動碼來源為預設值時,必須檢查異動碼是否存在agli109
# Modify.........: No.FUN-730020 07/03/15 By Carrier 會計科目加帳套
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.MOD-970001 09/07/01 By mike 當p_cmd=3或4,ahe03='2'時,應增加判斷IF l_aeeacti = 'N' LET g_errno = '9027'        
# Modify.........: No.MOD-970104 09/07/13 By mike 請在p_key后加CLIPPED
# Modify.........: No.FUN-950053 10/08/18 By vealxu 廠商基本資料的關係人設定搭配異動碼彈性設定
# Modify.........: No.FUN-C90061 12/09/20 By wuxj 科目做客商管理則核算項1不檢查
DATABASE ds
 
GLOBALS "../../config/top.global"    #FUN-7C0053
 
FUNCTION s_chk_aee(p_aag01,p_seq,p_key,p_bookno)  #No.FUN-730020
DEFINE p_aag01    LIKE aag_file.aag01      # 科目
DEFINE p_cmd      LIKE aag_file.aag151,    # 異動碼控制方式
       p_seq      LIKE aba_file.aba18,      #No.FUN-680147 VARCHAR(2)                # 異動碼順序 
       p_key      LIKE aee_file.aee03,      #No.FUN-680147 VARCHAR(30)               # 異動碼
       p_bookno   LIKE aag_file.aag00,      #No.FUN-730020
       l_aeeacti  LIKE aee_file.aeeacti,
       l_aee04    LIKE aee_file.aee04
DEFINE l_aag      RECORD LIKE aag_file.*   # 
DEFINE l_ahe      RECORD LIKE ahe_file.*   # 
DEFINE l_sql      LIKE type_file.chr1000   #No.FUN-680147 VARCHAR(2000)
DEFINE l_cnt      LIKE type_file.num5      #No.FUN-680147 SMALLINT
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   LET g_errno = ' '
 
   INITIALIZE l_aag.* TO NULL
   INITIALIZE l_ahe.* TO NULL
   SELECT * INTO l_aag.* FROM aag_file WHERE aag01=p_aag01
                                         AND aag00=p_bookno   #No.FUN-730020
   CASE p_seq
      WHEN "1"  LET p_cmd=l_aag.aag151
                SELECT * INTO l_ahe.* FROM ahe_file WHERE ahe01=l_aag.aag15
      WHEN "2"  LET p_cmd=l_aag.aag161 
                SELECT * INTO l_ahe.* FROM ahe_file WHERE ahe01=l_aag.aag16
      WHEN "3"  LET p_cmd=l_aag.aag171
                SELECT * INTO l_ahe.* FROM ahe_file WHERE ahe01=l_aag.aag17
      WHEN "4"  LET p_cmd=l_aag.aag181
                SELECT * INTO l_ahe.* FROM ahe_file WHERE ahe01=l_aag.aag18
      WHEN "5"  LET p_cmd=l_aag.aag311
                SELECT * INTO l_ahe.* FROM ahe_file WHERE ahe01=l_aag.aag31
      WHEN "6"  LET p_cmd=l_aag.aag321
                SELECT * INTO l_ahe.* FROM ahe_file WHERE ahe01=l_aag.aag32
      WHEN "7"  LET p_cmd=l_aag.aag331
                SELECT * INTO l_ahe.* FROM ahe_file WHERE ahe01=l_aag.aag33
      WHEN "8"  LET p_cmd=l_aag.aag341
                SELECT * INTO l_ahe.* FROM ahe_file WHERE ahe01=l_aag.aag34
      WHEN "9"  LET p_cmd=l_aag.aag351
                SELECT * INTO l_ahe.* FROM ahe_file WHERE ahe01=l_aag.aag35
      WHEN "10" LET p_cmd=l_aag.aag361
                SELECT * INTO l_ahe.* FROM ahe_file WHERE ahe01=l_aag.aag36
      WHEN "99" LET p_cmd=l_aag.aag371
                SELECT * INTO l_ahe.* FROM ahe_file WHERE ahe01=l_aag.aag37
   END CASE
 
   SELECT aee04,aeeacti INTO l_aee04,l_aeeacti FROM aee_file 
    WHERE aee01 = p_aag01
      AND aee02 = p_seq    
      AND aee03 = p_key
      AND aee00 = p_bookno   #No.FUN-730020
 
   CASE p_cmd
        WHEN '2'   #異動碼必須輸入不檢查
           IF p_key IS NULL OR p_key = ' ' THEN
              LET g_errno = 'agl-154'
           END IF
        WHEN '3'   #異動碼必須輸入要檢查
           CASE
              WHEN p_key IS NULL OR p_key = ' ' LET g_errno = 'agl-154'
             #WHEN l_aeeacti = 'N' LET g_errno = '9027'   #MOD-640131 mark
              WHEN l_ahe.ahe03='1'  #chk 基本資料
                    LET l_cnt=''
                    LET l_sql = 
                      " SELECT COUNT(*) FROM ",l_ahe.ahe04,
                      "  WHERE ",l_ahe.ahe05,"='",p_key CLIPPED,"'" #MOD-970104 add CLIPPED
                    PREPARE cnt_pre FROM l_sql
                    DECLARE cnt_cs CURSOR FOR cnt_pre
                    OPEN cnt_cs
                    FETCH cnt_cs INTO l_cnt
                    #FUN-C90061--add--str--
                    IF p_seq = '1' AND l_aag.aag43 = 'Y' AND g_prog != 'aglt110' THEN   #MOD-D40051
                    ELSE
                    #FUN-C90061--add--end
                    IF l_cnt=0 OR l_cnt IS NULL THEN
                       #show 無此基本資料!
                       LET g_errno='sub-150'
                    END IF
                    END IF #FUN-C90061
               #-----MOD-6A0041---------
               WHEN l_ahe.ahe03='2'  #chk 預設值
                    LET l_cnt = 0
                    SELECT COUNT(*) INTO l_cnt FROM aee_file
                      WHERE aee01 = p_aag01
                        AND aee02 = p_seq
                        AND aee03 = p_key
                        AND aee00 = p_bookno   #No.FUN-730020
                    #FUN-C90061--add--str--
                    IF p_seq = '1' AND l_aag.aag43 = 'Y' AND g_prog != 'aglt110' THEN   #MOD-D40051 
                    ELSE
                    #FUN-C90061--add--end
                    IF l_cnt = 0 THEN
                       LET g_errno='sub-150'
                    END IF
                    END IF #FUN-C90061
                   #MOD-970001   ---start                                                                                           
                    IF l_aeeacti='N' THEN                                                                                           
                       LET g_errno='9027'                                                                                           
                    END IF                                                                                                          
                   #MOD-970001   ---end     
               #-----END MOD-6A0041-----
             #WHEN SQLCA.sqlcode = 100 LET g_errno = 'agl-153'   #MOD-640131 mark
             #OTHERWISE  LET g_errno = SQLCA.sqlcode USING'-------'   #MOD-640131 mark
           END CASE
#FUN-950053--------------------------add  start-----------------------------------
        WHEN '4' 
           CASE 
              WHEN l_ahe.ahe03='1'                #chk 基本資料
                   LET l_cnt=''
                   LET l_sql = 
                              " SELECT COUNT(*) FROM ",l_ahe.ahe04, 
                              "  WHERE ",l_ahe.ahe05,"='",p_key CLIPPED,"'"
                   PREPARE cnt_pre1 FROM l_sql
                   DECLARE cnt_cs1 CURSOR FOR cnt_pre1
                   OPEN cnt_cs1 
                   FETCH cnt_cs1 INTO l_cnt
                   #FUN-C90061--add--begin
                   IF p_seq = '1' AND l_aag.aag43 = 'Y' THEN
                   ELSE
                   #FUN-C90061--add--end 
                   IF l_cnt=0 OR l_cnt IS NULL THEN  #show 無此基本資料!
                      LET g_errno='sub-150'   
                   END IF 
                   END IF #FUN-C90061
              WHEN l_ahe.ahe03='2'              #chk 預設值
                   LET l_cnt = 0 
                   SELECT COUNT(*) INTO l_cnt FROM aee_file
                    WHERE aee01 = p_aag01
                      AND aee02 = p_seq
                      AND aee03 = p_key
                      AND aee00 = p_bookno
                   #FUN-C90061--add--str--
                   IF p_seq = '1' AND l_aag.aag43 = 'Y' AND g_prog != 'aglt110' THEN  #MOD-D40051
                   ELSE
                   #FUN-C90061--add--end
                   IF l_cnt = 0 THEN 
                      LET g_errno='sub-150'
                   END IF 
                   END IF #FUN-C90061
                   IF l_aeeacti='N' THEN
                      LET g_errno='9027' 
                   END IF 
        END CASE               
#FUN-950053 ------------------------add end--------------------------------------- 
        OTHERWISE EXIT CASE
    END CASE
END FUNCTION
 
 
