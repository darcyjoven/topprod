# Prog. Version..: '5.30.06-13.03.28(00010)'     #
#
# Program name...: s_def_npq.4gl
# Descriptions...: 依彈性設定預設異動碼值
# Date & Author..: 
# Modify.........: No.FUN-640117 06/04/27 By Sarah 
#                  摘要抓取順序:
#                  1.若此單據已有輸入摘要,則以此摘要為主.
#                  2.若單據沒帶出摘要,則抓取分錄底稿預設摘要
#                  3.若前2項都沒有,則帶出參數設定(目前只有AAP才有參數設定)
# Modify.........: No.FUN-680147 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.FUN-690105 06/09/29 By Sarah s_def_npq2()段,當第一次用所有key去抓不到資料時,只用p_key1當key再抓一次
# Modify.........: No.MOD-720015 07/02/05 By Smapmin 若摘要為日期欄位,將顯示格式改為YY/MM/DD
# Modify.........: No.FUN-730020 07/03/15 By Carrier 會計科目加帳套
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.MOD-7C0209 07/12/27 By Smapmin 多加CLIPPED清空尾端空白
# Modify.........: No.MOD-820132 08/02/25 By Smapmin 預設摘要若有中文字,會導致判斷'@'是否存在可能會出錯
# Modify.........: No.FUN-840105 08/05/05 By hellen  抓出單身分錄底稿摘要
# Modify.........: No.CHI-850014 08/05/19 By Sarah 1.npq11~14,31~37預設值清空段mark掉
#                                                  2.判斷當npq11~14,31~37值是NULL時才需CALL s_def_npq2
# Modify.........: No.MOD-860011 08/06/09 By Sarah 增加FUNCTION s_def_npq5(),是給aapt120多借方產生分錄所用的,裡面內容就是CHI-850014所改的東西
# Modify.........: No.FUN-880027 08/08/11 By Sarah 將l_file,l_key1,l_key2,l_key3,p_key1,p_key2,p_key3放大成CHAR(1000)
# Modify.........: No.MOD-930160 09/03/13 By lilingyu 組l_sql時,相關欄位后面加上CLIPPED
# Modify.........: No.MOD-940327 09/04/24 By Sarah 當p_ahh02為anmt150,anmt250,anmt302,afat110時,CALL cl_get_column_info()須將table拆開再一一傳入取欄位型態
# Modify.........: No.CHI-960085 09/07/30 By hongmei select ahh_file 時加入ahh00
# Modify.........: No.MOD-970274 09/07/30 By mike anmt250應多抓取npn_file   
# Modify.........: NO.MOD-980188 09/10/30 BY yiting  在程式傳入帳別參數抓取ahh_file資料時沒有接到g_bookno的值
# Modify.........: NO.CHI-9C0033 09/12/18 BY sabrina 無設定使用異動碼，但異動碼自動帶入，仍可執行確認，無出現錯誤訊息 
# Modify.........: No.FUN-A50016 10/05/06 by rainy cl_get_column_info傳入參數修改
# Modify.........: NO.MOD-A90073 10/09/09 BY Dido 若為多檔案時,需增加檔案設定 
# Modify.........: No:CHI-AA0005 10/10/13 By Summer 多擷取aapt900(aqb)單身資料
# Modify.........: No:MOD-B40035 11/04/07 By wujie  未传入单身值时无需在where中加入单身条件
# Modify.........: No:FUN-B50105 11/05/23 By zhangweib aaz88範圍修改為0~4 添加azz125 營運部門資訊揭露使用異動碼數(5-8)
# Modify.........: No:CHI-B50048 11/06/16 By Dido 若為預設值則請直接由 ahf04 帶入 
# Modify.........: No:MOD-B80262 11/08/27 By Dido 多檔案預設值增加 aapt1 系列程式 
# Modify.........: No:MOD-C20137 12/02/17 By Polly 呼叫s_def_npq5後，將p_bookno的值給予p_ahf00
# Modify.........: No:MOD-C40058 12/04/13 By Polly 若aag371= '4'時,且相關系統關係人為'N'時，非關人需空白
# Modify.........: No:MOD-CC0141 12/12/08 By Polly 增加aapt332、aapt335彈性抓取摘要
# Modify.........: No:FUN-C90061 12/09/13 By wuxj  當為大陸版時，該科目做核算項一管理且做客商管理時，則核算項一為npq21
# Modify.........: No:TQC-D30017 13/03/19 By zhangweib l_date 變數 LET l_date = lc_str 需改為 LET l_date = lc_str[1,10]
# Modify.........: No:MOD-D30232 13/03/28 By Alberti anmt150 增加 npl_file


DATABASE ds
 
GLOBALS "../../config/top.global"    #FUN-7C0053
 
FUNCTION s_def_npq(p_ahf01,p_ahf02,p_npq,p_key1,p_key2,p_key3,p_bookno)  #No.FUN-730020
DEFINE p_ahf01    LIKE ahf_file.ahf01      # 科目  
DEFINE p_ahf02    LIKE ahf_file.ahf02      # 程式代號  傳 g_prog
DEFINE p_npq      RECORD LIKE npq_file.*   # 
DEFINE p_key1     LIKE type_file.chr1000   #LIKE ahf_file.ahf01      #No.FUN-680147 VARCHAR(30)  # 單號 exe g_apa.apa01  #FUN-880027 mod
DEFINE p_key2     LIKE type_file.chr1000   #LIKE ahf_file.ahf01      #No.FUN-680147 VARCHAR(30)  # 預留                  #FUN-880027 mod
DEFINE p_key3     LIKE type_file.chr1000   #LIKE ahf_file.ahf01      #No.FUN-680147 VARCHAR(30)  # 預留                  #FUN-880027 mod
DEFINE p_bookno   LIKE aag_file.aag00      #No.FUN-730020
DEFINE l_aag      RECORD LIKE aag_file.*   # 
DEFINE l_ahf      RECORD LIKE ahf_file.*   # 
DEFINE l_sql      STRING                   #No.FUN-680147 CHAR(2000) #CHI-B50048 mod STRING
DEFINE l_cnt      LIKE type_file.num5      #No.FUN-680147 SMALLINT
DEFINE l_seq      LIKE type_file.num5      #No.FUN-680147 SMALLINT
DEFINE p_ahf00    LIKE ahf_file.ahf00      #帳別 #CHI-960085 add
DEFINE l_ahe03    LIKE ahe_file.ahe03      #CHI-B50048 
DEFINE l_occ37    LIKE occ_file.occ37      #MOD-C40058 add
DEFINE l_i        LIKE type_file.num5      #No.FUN-C90061 add
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF cl_null(p_npq.npq04) THEN   #FUN-640117 add
      LET p_ahf00 = p_bookno   #MOD-980188
      #抓取分錄底稿預設摘要
      CALL s_def_npq3(p_ahf00,p_ahf01,p_ahf02,p_key1,p_key2,p_key3)  #摘要 #CHI-960085 add p_ahf00
      RETURNING p_npq.npq04
   END IF                         #FUN-640117 add
 
   #將上一科目的預設值清空
   LET p_npq.npq11=''
   LET p_npq.npq12=''
   LET p_npq.npq13=''
   LET p_npq.npq14=''
   LET p_npq.npq31=''
   LET p_npq.npq32=''
   LET p_npq.npq33=''
   LET p_npq.npq34=''
   LET p_npq.npq35=''
   LET p_npq.npq36=''
   LET p_npq.npq37=''
 
#No.FUN-C90061  ---begin---
   IF g_aza.aza26 = '2' THEN
      SELECT COUNT(*) INTO l_i FROM aag_file WHERE aag00 = p_bookno AND aag01 = p_ahf01
                                               AND aag43 = 'Y' AND aag151 IS NOT NULL
   END IF
#No.FUN-C90061  ---end---

#wujie 130615 --begin
#按科目设置的余额类型产生分录
   CALL s_aag42_direction(p_bookno,p_npq.npq03,p_npq.npq06,      
                        p_npq.npq07,p_npq.npq07f)              
   RETURNING p_npq.npq06,p_npq.npq07,p_npq.npq07f 
#wujie 130615 --end

   SELECT COUNT(*) INTO l_cnt   FROM ahf_file
    WHERE ahf01=p_ahf01 
      AND ahf02=p_ahf02
      AND ahf00=p_bookno  #No.FUN-730020
   IF l_cnt = 0 THEN 
#No.FUN-C90061  ---begin---
      IF g_aza.aza26 = '2' AND l_i > 0  THEN
         LET p_npq.npq11 = p_npq.npq21
      END IF
#No.FUN-C90061  ---end---
      RETURN p_npq.*
   END IF
 
   FOR l_seq = 1 TO g_aaz.aaz88
     INITIALIZE l_aag.* TO NULL
     INITIALIZE l_ahf.* TO NULL
     SELECT * INTO l_aag.* FROM aag_file WHERE aag01=p_npq.npq03
                                           AND aag00=p_bookno  #No.FUN-730020
     CASE l_seq
        WHEN 1
             IF NOT cl_null(l_aag.aag151) THEN        #CHI-9C0033 add
                CALL s_def_ahe03(p_bookno,p_npq.npq03,l_seq) RETURNING l_ahe03 #CHI-B50048
                CASE l_ahe03    #CHI-B50048 
                   WHEN '1'     #CHI-B50048
                      SELECT * INTO l_ahf.* FROM ahf_file
                       WHERE ahf01=p_ahf01 AND ahf02=p_ahf02 AND ahf03='1'
                         AND ahf00=p_bookno  #No.FUN-730020
                      CALL s_def_npq2(p_ahf02,l_ahf.ahf04,p_key1,p_key2,p_key3)
                      RETURNING p_npq.npq11
               #-CHI-B50048-add-
                   WHEN '2'  
                      SELECT ahf04 INTO p_npq.npq11 
                        FROM ahf_file
                       WHERE ahf01=p_ahf01 AND ahf02=p_ahf02 AND ahf03='1'
                         AND ahf00=p_bookno 
                END CASE
               #-CHI-B50048-end-
             END IF                                   #CHI-9C0033 add
        WHEN 2
             IF NOT cl_null(l_aag.aag161) THEN        #CHI-9C0033 add
                CALL s_def_ahe03(p_bookno,p_npq.npq03,l_seq) RETURNING l_ahe03 #CHI-B50048
                CASE l_ahe03    #CHI-B50048 
                   WHEN '1'     #CHI-B50048
                      SELECT * INTO l_ahf.* FROM ahf_file
                       WHERE ahf01=p_ahf01 AND ahf02=p_ahf02 AND ahf03='2'
                         AND ahf00=p_bookno  #No.FUN-730020
                      CALL s_def_npq2(p_ahf02,l_ahf.ahf04,p_key1,p_key2,p_key3)
                      RETURNING p_npq.npq12
               #-CHI-B50048-add-
                   WHEN '2'  
                      SELECT ahf04 INTO p_npq.npq12
                        FROM ahf_file
                       WHERE ahf01=p_ahf01 AND ahf02=p_ahf02 AND ahf03='2'
                         AND ahf00=p_bookno 
                END CASE
               #-CHI-B50048-end-
             END IF                                   #CHI-9C0033 add
 
        WHEN 3
             IF NOT cl_null(l_aag.aag171) THEN        #CHI-9C0033 add
                CALL s_def_ahe03(p_bookno,p_npq.npq03,l_seq) RETURNING l_ahe03 #CHI-B50048
                CASE l_ahe03    #CHI-B50048 
                   WHEN '1'     #CHI-B50048
                      SELECT * INTO l_ahf.* FROM ahf_file
                       WHERE ahf01=p_ahf01 AND ahf02=p_ahf02 AND ahf03='3'
                         AND ahf00=p_bookno  #No.FUN-730020
                      CALL s_def_npq2(p_ahf02,l_ahf.ahf04,p_key1,p_key2,p_key3)
                      RETURNING p_npq.npq13
               #-CHI-B50048-add-
                   WHEN '2'  
                      SELECT ahf04 INTO p_npq.npq13
                        FROM ahf_file
                       WHERE ahf01=p_ahf01 AND ahf02=p_ahf02 AND ahf03='3'
                         AND ahf00=p_bookno 
                END CASE
               #-CHI-B50048-end-
             END IF                                   #CHI-9C0033 add

        WHEN 4
             IF NOT cl_null(l_aag.aag181) THEN        #CHI-9C0033 add
                CALL s_def_ahe03(p_bookno,p_npq.npq03,l_seq) RETURNING l_ahe03 #CHI-B50048
                CASE l_ahe03    #CHI-B50048 
                   WHEN '1'     #CHI-B50048
                      SELECT * INTO l_ahf.* FROM ahf_file
                       WHERE ahf01=p_ahf01 AND ahf02=p_ahf02 AND ahf03='4'
                         AND ahf00=p_bookno  #No.FUN-730020
                      CALL s_def_npq2(p_ahf02,l_ahf.ahf04,p_key1,p_key2,p_key3)
                      RETURNING p_npq.npq14
               #-CHI-B50048-add-
                   WHEN '2'  
                      SELECT ahf04 INTO p_npq.npq14
                        FROM ahf_file
                       WHERE ahf01=p_ahf01 AND ahf02=p_ahf02 AND ahf03='4'
                         AND ahf00=p_bookno 
                END CASE
               #-CHI-B50048-end-
             END IF                                   #CHI-9C0033 add
 
#FUN-B50105   ---start   Add
     END CASE
   END FOR
   FOR l_seq = 1 TO g_aaz.aaz125
     INITIALIZE l_aag.* TO NULL
     INITIALIZE l_ahf.* TO NULL
     SELECT * INTO l_aag.* FROM aag_file WHERE aag01=p_npq.npq03
                                           AND aag00=p_bookno
     CASE l_seq
#FUN-B50105   ---end     Add

        WHEN 5
             IF NOT cl_null(l_aag.aag311) THEN        #CHI-9C0033 add
                CALL s_def_ahe03(p_bookno,p_npq.npq03,l_seq) RETURNING l_ahe03 #CHI-B50048
                CASE l_ahe03    #CHI-B50048 
                   WHEN '1'     #CHI-B50048
                      SELECT * INTO l_ahf.* FROM ahf_file
                       WHERE ahf01=p_ahf01 AND ahf02=p_ahf02 AND ahf03='5'
                         AND ahf00=p_bookno  #No.FUN-730020
                      CALL s_def_npq2(p_ahf02,l_ahf.ahf04,p_key1,p_key2,p_key3)
                      RETURNING p_npq.npq31
               #-CHI-B50048-add-
                   WHEN '2'  
                      SELECT ahf04 INTO p_npq.npq31
                        FROM ahf_file
                       WHERE ahf01=p_ahf01 AND ahf02=p_ahf02 AND ahf03='5'
                         AND ahf00=p_bookno 
                END CASE
               #-CHI-B50048-end-
             END IF                                   #CHI-9C0033 add
 
        WHEN 6
             IF NOT cl_null(l_aag.aag321) THEN        #CHI-9C0033 add
                CALL s_def_ahe03(p_bookno,p_npq.npq03,l_seq) RETURNING l_ahe03 #CHI-B50048
                CASE l_ahe03    #CHI-B50048 
                   WHEN '1'     #CHI-B50048
                      SELECT * INTO l_ahf.* FROM ahf_file
                       WHERE ahf01=p_ahf01 AND ahf02=p_ahf02 AND ahf03='6'
                         AND ahf00=p_bookno  #No.FUN-730020
                      CALL s_def_npq2(p_ahf02,l_ahf.ahf04,p_key1,p_key2,p_key3)
                      RETURNING p_npq.npq32
               #-CHI-B50048-add-
                   WHEN '2'  
                      SELECT ahf04 INTO p_npq.npq32
                        FROM ahf_file
                       WHERE ahf01=p_ahf01 AND ahf02=p_ahf02 AND ahf03='6'
                         AND ahf00=p_bookno 
                END CASE
               #-CHI-B50048-end-
             END IF                                   #CHI-9C0033 add
 
        WHEN 7
             IF NOT cl_null(l_aag.aag331) THEN        #CHI-9C0033 add
                CALL s_def_ahe03(p_bookno,p_npq.npq03,l_seq) RETURNING l_ahe03 #CHI-B50048
                CASE l_ahe03    #CHI-B50048 
                   WHEN '1'     #CHI-B50048
                      SELECT * INTO l_ahf.* FROM ahf_file
                       WHERE ahf01=p_ahf01 AND ahf02=p_ahf02 AND ahf03='7'
                         AND ahf00=p_bookno  #No.FUN-730020
                      CALL s_def_npq2(p_ahf02,l_ahf.ahf04,p_key1,p_key2,p_key3)
                      RETURNING p_npq.npq33
               #-CHI-B50048-add-
                   WHEN '2'  
                      SELECT ahf04 INTO p_npq.npq33
                        FROM ahf_file
                       WHERE ahf01=p_ahf01 AND ahf02=p_ahf02 AND ahf03='7'
                         AND ahf00=p_bookno 
                END CASE
               #-CHI-B50048-end-
             END IF                                   #CHI-9C0033 add
 
        WHEN 8
             IF NOT cl_null(l_aag.aag341) THEN        #CHI-9C0033 add
                CALL s_def_ahe03(p_bookno,p_npq.npq03,l_seq) RETURNING l_ahe03 #CHI-B50048
                CASE l_ahe03    #CHI-B50048 
                   WHEN '1'     #CHI-B50048
                      SELECT * INTO l_ahf.* FROM ahf_file
                       WHERE ahf01=p_ahf01 AND ahf02=p_ahf02 AND ahf03='8'
                         AND ahf00=p_bookno  #No.FUN-730020
                      CALL s_def_npq2(p_ahf02,l_ahf.ahf04,p_key1,p_key2,p_key3)
                      RETURNING p_npq.npq34
               #-CHI-B50048-add-
                   WHEN '2'  
                      SELECT ahf04 INTO p_npq.npq34
                        FROM ahf_file
                       WHERE ahf01=p_ahf01 AND ahf02=p_ahf02 AND ahf03='8'
                         AND ahf00=p_bookno 
                END CASE
               #-CHI-B50048-end-
             END IF                                   #CHI-9C0033 add
 
        WHEN 9
             IF NOT cl_null(l_aag.aag351) THEN        #CHI-9C0033 add
                CALL s_def_ahe03(p_bookno,p_npq.npq03,l_seq) RETURNING l_ahe03 #CHI-B50048
                CASE l_ahe03    #CHI-B50048 
                   WHEN '1'     #CHI-B50048
                      SELECT * INTO l_ahf.* FROM ahf_file
                       WHERE ahf01=p_ahf01 AND ahf02=p_ahf02 AND ahf03='9'
                         AND ahf00=p_bookno  #No.FUN-730020
                      CALL s_def_npq2(p_ahf02,l_ahf.ahf04,p_key1,p_key2,p_key3)
                      RETURNING p_npq.npq35
               #-CHI-B50048-add-
                   WHEN '2'  
                      SELECT ahf04 INTO p_npq.npq35
                        FROM ahf_file
                       WHERE ahf01=p_ahf01 AND ahf02=p_ahf02 AND ahf03='9'
                         AND ahf00=p_bookno 
                END CASE
               #-CHI-B50048-end-
             END IF                                   #CHI-9C0033 add
 
        WHEN 10
             IF NOT cl_null(l_aag.aag361) THEN        #CHI-9C0033 add
                CALL s_def_ahe03(p_bookno,p_npq.npq03,l_seq) RETURNING l_ahe03 #CHI-B50048
                CASE l_ahe03    #CHI-B50048 
                   WHEN '1'     #CHI-B50048
                      SELECT * INTO l_ahf.* FROM ahf_file
                       WHERE ahf01=p_ahf01 AND ahf02=p_ahf02 AND ahf03='10'
                         AND ahf00=p_bookno  #No.FUN-730020
                      CALL s_def_npq2(p_ahf02,l_ahf.ahf04,p_key1,p_key2,p_key3)
                      RETURNING p_npq.npq36
               #-CHI-B50048-add-
                   WHEN '2'  
                      SELECT ahf04 INTO p_npq.npq36
                        FROM ahf_file
                       WHERE ahf01=p_ahf01 AND ahf02=p_ahf02 AND ahf03='10'
                         AND ahf00=p_bookno 
                END CASE
               #-CHI-B50048-end-
             END IF                                   #CHI-9C0033 add
     END CASE
   END FOR
   #for 關係人
   INITIALIZE l_ahf.* TO NULL
   IF NOT cl_null(l_aag.aag371) THEN        #CHI-9C0033 add
      CALL s_def_ahe03(p_bookno,p_npq.npq03,'99') RETURNING l_ahe03 #CHI-B50048
      CASE l_ahe03    #CHI-B50048 
         WHEN '1'     #CHI-B50048
            SELECT * INTO l_ahf.* FROM ahf_file
             WHERE ahf01=p_ahf01 AND ahf02=p_ahf02 AND ahf03='99'
               AND ahf00=p_bookno  #No.FUN-730020
            CALL s_def_npq2(p_ahf02,l_ahf.ahf04,p_key1,p_key2,p_key3)
            RETURNING p_npq.npq37
     #-CHI-B50048-add-
         WHEN '2'  
            SELECT ahf04 INTO p_npq.npq37
              FROM ahf_file
             WHERE ahf01=p_ahf01 AND ahf02=p_ahf02 AND ahf03='99'
               AND ahf00=p_bookno 
      END CASE
     #-CHI-B50048-end-
   END IF                                   #CHI-9C0033 add
  #--------------------MOD-C40058---------------------------(S)
   IF l_aag.aag371 = '4' THEN
      IF p_npq.npqsys = 'AP' THEN
         SELECT pmc903 INTO l_occ37
           FROM pmc_file,apa_file
          WHERE pmc01 = apa05
            AND apa01 = p_npq.npq01
      END IF
      IF p_npq.npqsys = 'AR' THEN
         SELECT occ37 INTO l_occ37
           FROM occ_file,oma_file
          WHERE occ01 = oma03
            AND oma01 = p_npq.npq01
      END IF
      IF p_npq.npqsys = 'FA' THEN
         SELECT occ37 INTO l_occ37
           FROM occ_file,fbe_file
          WHERE occ01 = fbe03
            AND fbe01 = p_npq.npq01
      END IF
      IF p_npq.npqsys = 'NM' THEN
         SELECT occ37 INTO l_occ37
           FROM occ_file,nmg_file
          WHERE occ01 = nmg18
            AND nmg00 = p_npq.npq01
      END IF
      IF l_occ37 = 'N' OR cl_null(l_occ37)  THEN
         LET p_npq.npq37 = ''
      END IF
   END IF
  #--------------------MOD-C40058---------------------------(E)
#No.FUN-C90061  ---begin---
   IF g_aza.aza26 = '2' AND l_i > 0  THEN
      LET p_npq.npq11 = p_npq.npq21
   END IF
#No.FUN-C90061  ---end---
   RETURN p_npq.*
END FUNCTION
 
#-CHI-B50048-add-
FUNCTION s_def_ahe03(p_bookno,p_npq03,p_ahf03)
   DEFINE p_bookno   LIKE aag_file.aag00     
   DEFINE p_npq00    LIKE npq_file.npq00
   DEFINE p_npq03    LIKE npq_file.npq03
   DEFINE p_ahf03    LIKE ahf_file.ahf03 
   DEFINE l_ahe03    LIKE ahe_file.ahe03 
   DEFINE l_aag      LIKE aag_file.aag15
   DEFINE l_sql      STRING 

   CASE p_ahf03
      WHEN '1'
         LET l_aag = 'aag15'
      WHEN '2'
         LET l_aag = 'aag16'
      WHEN '3'
         LET l_aag = 'aag17'
      WHEN '4'
         LET l_aag = 'aag18'
      WHEN '5'
         LET l_aag = 'aag31'
      WHEN '6'
         LET l_aag = 'aag32'
      WHEN '7'
         LET l_aag = 'aag33'
      WHEN '8'
         LET l_aag = 'aag34'
      WHEN '9'
         LET l_aag = 'aag35'
      WHEN '10'
         LET l_aag = 'aag36'
      WHEN '99'
         LET l_aag = 'aag37'
   END CASE

   LET l_sql = " SELECT ahe03 ",
               "   FROM aag_file,ahe_file ",
               "  WHERE aag00 = '",p_bookno,"'",
               "    AND aag01 = '",p_npq03,"'",
               "    AND ahe01 = ",l_aag
   PREPARE i120_ahe03 FROM l_sql                                                                                                   
   EXECUTE i120_ahe03 INTO l_ahe03 

   RETURN l_ahe03

END FUNCTION
#-CHI-B50048-end-

FUNCTION s_def_npq2(p_ahf02,p_ahf04,p_key1,p_key2,p_key3)
DEFINE p_ahf02    LIKE ahf_file.ahf02      # 程式代號
DEFINE p_ahf04    LIKE ahf_file.ahf04      # 欄位
DEFINE p_key1     LIKE type_file.chr1000   #LIKE ahf_file.ahf01      #No.FUN-680147 VARCHAR(30)     # 單號 exe g_apa.apa01   #FUN-880027 mod
DEFINE p_key2     LIKE type_file.chr1000   #LIKE ahf_file.ahf01      #No.FUN-680147 VARCHAR(30)                              #FUN-880027 mod
DEFINE p_key3     LIKE type_file.chr1000   #LIKE ahf_file.ahf01      #No.FUN-680147 VARCHAR(30)                              #FUN-880027 mod
DEFINE l_file     LIKE type_file.chr1000   #LIKE ahf_file.ahf04      #No.FUN-680147 VARCHAR(15)     # 檔案編號               #FUN-880027 mod
DEFINE l_key1     LIKE type_file.chr1000   #LIKE ahf_file.ahf01      #No.FUN-680147 VARCHAR(30)     # key值欄位1 ex:apa01    #FUN-880027 mod
DEFINE l_key2     LIKE type_file.chr1000   #LIKE ahf_file.ahf01      #No.FUN-680147 VARCHAR(30)     # key值欄位2             #FUN-880027 mod
DEFINE l_key3     LIKE type_file.chr1000   #LIKE ahf_file.ahf01      #No.FUN-680147 VARCHAR(30)     # key值欄位3             #FUN-880027 mod
DEFINE p_npq11    LIKE npq_file.npq11      
DEFINE l_sql      STRING                   #No.FUN-680147 CHAR(2000) #CHI-B50048 mod STRING
 
   IF cl_null(p_ahf02) THEN RETURN '' END IF
   IF cl_null(p_ahf04) THEN RETURN '' END IF
   LET l_file=''
   LET l_key1=''
   LET l_key2=''
   LET l_key3=''
   CALL s_prg_tab(p_ahf02)
   RETURNING l_file,l_key1,l_key2,l_key3
   LET l_sql = " SELECT ",p_ahf04," FROM ",l_file CLIPPED,
               "  WHERE ",l_key1 CLIPPED,"= '",p_key1,"'"
   IF NOT cl_null(l_key2) THEN
       LET l_sql = l_sql CLIPPED,
                   "  AND ",l_key2 CLIPPED,"= '",p_key2,"'"
   END IF
   IF NOT cl_null(l_key3) THEN
       LET l_sql = l_sql CLIPPED,
                   "  AND ",l_key3 CLIPPED,"= '",p_key3,"'"
   END IF
   PREPARE get_apa_pre FROM l_sql
   DECLARE get_apa_cs CURSOR FOR get_apa_pre
   OPEN get_apa_cs
   FETCH get_apa_cs INTO p_npq11
  #start FUN-690105 add
   #當抓不到資料時,只用p_key1當key再去抓一次
   IF cl_null(p_npq11) THEN
      LET l_sql = ''
      LET l_sql = " SELECT ",p_ahf04," FROM ",l_file CLIPPED,
                  "  WHERE ",l_key1 CLIPPED,"= '",p_key1,"'"
      PREPARE get_apa_pre1 FROM l_sql
      DECLARE get_apa_cs1 CURSOR FOR get_apa_pre1
      OPEN get_apa_cs1
      FETCH get_apa_cs1 INTO p_npq11
   END IF
  #end FUN-690105 add
   RETURN p_npq11
END FUNCTION
 
FUNCTION s_def_npq3(p_ahh00,p_ahh01,p_ahh02,p_key1,p_key2,p_key3) #摘要預設 #CHI-960085 add p_ahh00
DEFINE p_ahh00    LIKE ahh_file.ahh00      #帳別  #CHI-960085 add
DEFINE p_ahh01    LIKE ahh_file.ahh01      # 科目
DEFINE p_ahh02    LIKE ahh_file.ahh02      # 程式
DEFINE p_key1     LIKE type_file.chr1000   #LIKE ahf_file.ahf01      #No.FUN-680147 VARCHAR(30)    # 單號 exe g_apa.apa01   #FUN-880027 mod
DEFINE p_key2     LIKE type_file.chr1000   #LIKE ahf_file.ahf01      #No.FUN-680147 VARCHAR(30)    #                        #FUN-880027 mod
DEFINE p_key3     LIKE type_file.chr1000   #LIKE ahf_file.ahf01      #No.FUN-680147 VARCHAR(30)    #                        #FUN-880027 mod
DEFINE l_file     LIKE type_file.chr1000   #LIKE ahf_file.ahf04      #No.FUN-680147 VARCHAR(15)    # 檔案編號               #FUN-880027 mod
DEFINE l_key1     LIKE type_file.chr1000   #LIKE ahf_file.ahf01      #No.FUN-680147 VARCHAR(30)    # key值欄位1 ex:apa01    #FUN-880027 mod
DEFINE l_key2     LIKE type_file.chr1000   #LIKE ahf_file.ahf01      #No.FUN-680147 VARCHAR(30)    # key值欄位2             #FUN-880027 mod
DEFINE l_key3     LIKE type_file.chr1000   #LIKE ahf_file.ahf01      #No.FUN-680147 VARCHAR(30)    # key值欄位3             #FUN-880027 mod
DEFINE l_ahh      RECORD LIKE ahh_file.*
DEFINE l_sql      STRING                   #No.FUN-680147 CHAR(2000) #CHI-B50048 mod STRING
DEFINE ls_str     STRING                   
DEFINE lc_str     LIKE type_file.chr1000   #No.FUN-680147 VARCHAR(200)
DEFINE lt_str     base.StringTokenizer
DEFINE l_npq04    LIKE npq_file.npq04
DEFINE l_datatype,l_length   STRING        #MOD-720015
DEFINE l_date     LIKE type_file.dat       #MOD-720015
DEFINE l_cnt      LIKE type_file.num5      #MOD-820132
DEFINE ls_str2    STRING                   #MOD-820132
DEFINE l_nmd02    LIKE nmd_file.nmd02      #No.FUN-840105
DEFINE l_nmh31    LIKE nmh_file.nmh31      #No.FUN-840105
DEFINE l_file1    DYNAMIC ARRAY OF LIKE type_file.chr1000  #MOD-940327 add
DEFINE i,j        LIKE type_file.num5                      #MOD-940327 add
DEFINE   l_azw05    LIKE  azw_file.azw05   #FUN-A50016
 
  IF cl_null(p_ahh00) THEN RETURN '' END IF  #CHI-960085 
  IF cl_null(p_ahh01) THEN RETURN '' END IF
  IF cl_null(p_ahh02) THEN RETURN '' END IF
  INITIALIZE l_ahh.* TO NULL
  SELECT * INTO  l_ahh.* FROM ahh_file
   WHERE ahh00=p_ahh00    #CHI-960085 add
     AND ahh01=p_ahh01
     AND ahh02=p_ahh02
  IF STATUS THEN RETURN '' END IF
  IF cl_null(l_ahh.ahh03) THEN 
     RETURN '' 
  END IF
  LET l_npq04=''
  LET lt_str=base.StringTokenizer.create(l_ahh.ahh03 CLIPPED, ",")
  WHILE lt_str.hasMoreTokens()
     LET ls_str =''
     LET lc_str =''
     LET ls_str=lt_str.nextToken()
     IF cl_null(ls_str) THEN
        CONTINUE WHILE
     END IF
     LET ls_str=ls_str.trim()
     LET ls_str=ls_str.trimRight()
     IF ls_str.getIndexOf("@",1)  THEN
       LET ls_str2 = ls_str   #MOD-820132
       LET ls_str=ls_str.subString(2,ls_str.getLength())
       #-----MOD-820132---------
       LET l_cnt = 0 
       LET l_sql = "SELECT COUNT(*) FROM gaq_file WHERE gaq01 ='",ls_str CLIPPED,"'"
       PREPARE get_gaq_pre FROM l_sql
       DECLARE get_gaq_cs CURSOR FOR get_gaq_pre
       OPEN get_gaq_cs
       FETCH get_gaq_cs INTO l_cnt
       IF l_cnt = 0 THEN
          LET l_npq04=l_npq04,' ',ls_str2 CLIPPED
          CONTINUE WHILE
       END IF
       #-----END MOD-820132-----
       LET l_file=''
       LET l_key1=''
       LET l_key2=''
       LET l_key3=''
       CALL s_prg_tab(p_ahh02)
       RETURNING l_file,l_key1,l_key2,l_key3
       LET l_sql = " SELECT ",ls_str CLIPPED," FROM ",l_file CLIPPED,
                   "  WHERE ",l_key1 CLIPPED,"= '",p_key1 CLIPPED,"'"   #MOD-930160 add clipped
#      IF NOT cl_null(l_key2) THEN
       IF NOT cl_null(l_key2) AND NOT cl_null(p_key2) THEN  #No.MOD-B40035
           LET l_sql = l_sql CLIPPED,
                       "  AND ",l_key2 CLIPPED,"= '",p_key2 CLIPPED,"'"  #MOD-930160 add clipped
       END IF
#      IF NOT cl_null(l_key3) THEN
       IF NOT cl_null(l_key3) AND NOT cl_null(p_key3) THEN  #No.MOD-B40035
           LET l_sql = l_sql CLIPPED,
                       "  AND ",l_key3 CLIPPED,"= '",p_key3 CLIPPED,"'"  #MOD-930160 add clipped
       END IF
       PREPARE get_apa_pre2 FROM l_sql
       DECLARE get_apa_cs2 CURSOR FOR get_apa_pre2
       OPEN get_apa_cs2
       FETCH get_apa_cs2 INTO lc_str
       #No.FUN-840105 add 080505 --begin    
       IF ls_str = 'npm03' THEN
          LET l_nmd02 = ''
          SELECT nmd02 INTO l_nmd02 
            FROM nmd_file
           WHERE nmd01 = lc_str
          IF l_nmd02 IS NOT NULL THEN
             LET lc_str = lc_str CLIPPED,' ',l_nmd02 CLIPPED
          END IF
       END IF
      
       IF ls_str = 'npo03' THEN
          LET l_nmh31 = ''
          SELECT nmh31 INTO l_nmh31
            FROM nmh_file
           WHERE nmh01 = lc_str
          IF l_nmh31 IS NOT NULL THEN
             LET lc_str = lc_str CLIPPED,' ',l_nmh31 CLIPPED
          END IF
       END IF
       #No.FUN-840105 add 080505 --end    
      #str MOD-940327 add
      #CASE p_ahh02                        #MOD-A90073 mark
       CASE                                #MOD-A90073
          WHEN p_ahh02 = "anmt150"         #MOD-A90073 add p_ahh02
             LET l_file1[1]='npm_file'
             LET l_file1[2]='nmd_file'
             LET l_file1[3]='npl_file'     #MOD-D30232 
            #LET j = 2                     #MOD-D30232 mark
             LET j = 3                     #MOD-D30232
          WHEN p_ahh02 = "anmt250"         #MOD-A90073 add p_ahh02
             LET l_file1[1]='npo_file'
             LET l_file1[2]='nmh_file'
             LET l_file1[3]='npn_file' #MOD-970274    
            #LET j = 2 #MOD-970274                                                                                                  
             LET j = 3 #MOD-970274    
          WHEN p_ahh02 = "anmt302"         #MOD-A90073 add p_ahh02
             LET l_file1[1]='npk_file'
             LET l_file1[2]='nmg_file'
             LET j = 2
          WHEN p_ahh02 = "afat110"         #MOD-A90073 add p_ahh02
             LET l_file1[1]='fbf_file'
             LET l_file1[2]='fbe_file'
             LET l_file1[3]='occ_file'
             LET j = 3
         #-MOD-A90073-add-
         #WHEN (p_ahh02 = "aapt330" OR p_ahh02 = "aapt331" OR p_ahh02 = "aapp310")          #MOD-CC0141 mark
          WHEN (p_ahh02 = "aapt330" OR p_ahh02 = "aapt331" OR p_ahh02 = "aapp310" OR        #MOD-CC0141 add
                p_ahh02 = "aapt332" OR p_ahh02 = "aapt335")                                 #MOD-CC0141 add
             LET l_file1[1]='apf_file'
             LET l_file1[2]='apg_file'
             LET l_file1[3]='aph_file'
             LET j = 3
         #WHEN p_ahh02 = "axrt400"     #MOD-B80262 mark 
          WHEN (p_ahh02 = 'axrt400' OR p_ahh02 = 'axrt410' OR p_ahh02 = 'axrt401' )  #MOD-B80262
             LET l_file1[1]='ooa_file'
             LET l_file1[2]='oob_file'
             LET j = 2
         #-MOD-A90073-end-
         #CHI-AA0005 add --start--
          WHEN p_ahh02 = "aapt900"
             LET l_file1[1]='aqa_file'
             LET l_file1[2]='aqb_file'
             LET j = 2
         #CHI-AA0005 add --end--
         #-MOD-B80262-add-
          WHEN (p_ahh02 = 'aapt110' OR p_ahh02 = 'aapt120' OR p_ahh02 = 'aapt150' OR
                p_ahh02 = 'aapt210' OR p_ahh02 = 'aapt220' OR p_ahh02 = 'aapt160' OR  
                p_ahh02 = 'aapt260' OR p_ahh02 = 'aapt121' OR p_ahh02 = 'aapt151' OR   
                p_ahh02 = 'aapp110' OR p_ahh02 = 'aapp111' OR p_ahh02 = 'aapp112' OR
                p_ahh02 = 'aapp115' OR p_ahh02 = 'aapp117' )                  
             LET l_file1[1]='apa_file'
             LET l_file1[2]='apb_file'
             LET j = 2
         #-MOD-B80262-end-
          OTHERWISE
             LET l_file1[1]=l_file
             LET j = 1
       END CASE
       FOR i = 1 TO j
      #end MOD-940327 add
          #-----MOD-720015---------
         #CALL cl_get_column_info(g_dbs,l_file,ls_str) RETURNING l_datatype,l_length       #MOD-940327 mark
 #FUN-A50016 begin
          CALL s_get_azw05(g_plant) RETURNING l_azw05
          #CALL cl_get_column_info(g_dbs,l_file1[i],ls_str) RETURNING l_datatype,l_length   #MOD-940327
          CALL cl_get_column_info(l_azw05,l_file1[i],ls_str) RETURNING l_datatype,l_length   #MOD-940327
 #FUN-A50016 end
          IF cl_null(l_datatype) THEN CONTINUE FOR END IF   #MOD-940327 add
          IF l_datatype = 'date' THEN
             LET l_date = ''
            #LET l_date = lc_str         #No.TQC-D30017   Mark
             LET l_date = lc_str[1,10]   ##No.TQC-D30017   Add
             LET l_date = l_date USING 'YY/MM/DD'
             LET lc_str = l_date
          END IF 
          #-----END MOD-720015----- 
       END FOR   #MOD-940327 add
       LET l_npq04=l_npq04 CLIPPED,' ',lc_str CLIPPED   #MOD-7C0209
     ELSE
       LET l_npq04=l_npq04 CLIPPED,' ',ls_str CLIPPED   #MOD-7C0209
       CONTINUE WHILE
     END IF
  END WHILE
  LET ls_str=l_npq04
  LET ls_str=ls_str.trimLeft()
  LET l_npq04=ls_str CLIPPED
  RETURN l_npq04
END FUNCTION
 
#str MOD-860011 add
FUNCTION s_def_npq5(p_ahf01,p_ahf02,p_npq,p_key1,p_key2,p_key3,p_bookno)  #No.FUN-730020
DEFINE p_ahf01    LIKE ahf_file.ahf01      # 科目  
DEFINE p_ahf02    LIKE ahf_file.ahf02      # 程式代號  傳 g_prog
DEFINE p_npq      RECORD LIKE npq_file.*   # 
DEFINE p_key1     LIKE type_file.chr1000   #LIKE ahf_file.ahf01      #No.FUN-680147 VARCHAR(30)  # 單號 exe g_apa.apa01   #FUN-880027 mod
DEFINE p_key2     LIKE type_file.chr1000   #LIKE ahf_file.ahf01      #No.FUN-680147 VARCHAR(30)  # 預留                   #FUN-880027 mod
DEFINE p_key3     LIKE type_file.chr1000   #LIKE ahf_file.ahf01      #No.FUN-680147 VARCHAR(30)  # 預留                   #FUN-880027 mod
DEFINE p_bookno   LIKE aag_file.aag00      #No.FUN-730020
DEFINE l_aag      RECORD LIKE aag_file.*   # 
DEFINE l_ahf      RECORD LIKE ahf_file.*   # 
DEFINE l_sql      STRING                   #No.FUN-680147 CHAR(2000) #CHI-B50048 mod STRING
DEFINE l_cnt      LIKE type_file.num5      #No.FUN-680147 SMALLINT
DEFINE l_seq      LIKE type_file.num5      #No.FUN-680147 SMALLINT
DEFINE p_ahf00    LIKE ahf_file.ahf00      # 帳別 #CHI-960085 add
DEFINE l_i        LIKE type_file.num5      #No.FUN-C90061 add

   WHENEVER ERROR CALL cl_err_msg_log
 
   IF cl_null(p_npq.npq04) THEN   #FUN-640117 add
      #抓取分錄底稿預設摘要
      LET p_ahf00 = p_bookno               #MOD-C20137 add
      CALL s_def_npq3(p_ahf00,p_ahf01,p_ahf02,p_key1,p_key2,p_key3)  #摘要 #CHI-960085 add p_ahf00
      RETURNING p_npq.npq04
   END IF                         #FUN-640117 add
 
  #str CHI-850014 mark
  ##將上一科目的預設值清空
  #LET p_npq.npq11=''
  #LET p_npq.npq12=''
  #LET p_npq.npq13=''
  #LET p_npq.npq14=''
  #LET p_npq.npq31=''
  #LET p_npq.npq32=''
  #LET p_npq.npq33=''
  #LET p_npq.npq34=''
  #LET p_npq.npq35=''
  #LET p_npq.npq36=''
  #LET p_npq.npq37=''
  #end CHI-850014 mark
 
#No.FUN-C90061  ---begin---
   IF g_aza.aza26 = '2' THEN
      SELECT COUNT(*) INTO l_i FROM aag_file WHERE aag00 = p_bookno AND aag01 = p_ahf01
                                               AND aag43 = 'Y' AND aag151 IS NOT NULL
   END IF
#No.FUN-C90061  ---end---

   SELECT COUNT(*) INTO l_cnt   FROM ahf_file
    WHERE ahf01=p_ahf01 
      AND ahf02=p_ahf02
      AND ahf00=p_bookno  #No.FUN-730020
   IF l_cnt = 0 THEN
#No.FUN-C90061  ---begin---
      IF g_aza.aza26 = '2' AND l_i > 0  THEN
         LET p_npq.npq11 = p_npq.npq21
      END IF
#No.FUN-C90061  ---end---
      RETURN p_npq.* 
   END IF
 
   FOR l_seq = 1 TO g_aaz.aaz88
     INITIALIZE l_aag.* TO NULL
     INITIALIZE l_ahf.* TO NULL
     SELECT * INTO l_aag.* FROM aag_file WHERE aag01=p_npq.npq03
                                           AND aag00=p_bookno  #No.FUN-730020
     CASE l_seq
        WHEN 1
           IF cl_null(p_npq.npq11) THEN   #CHI-850014 add
              SELECT * INTO l_ahf.* FROM ahf_file
               WHERE ahf01=p_ahf01 AND ahf02=p_ahf02 AND ahf03='1'
                 AND ahf00=p_bookno  #No.FUN-730020
              CALL s_def_npq2(p_ahf02,l_ahf.ahf04,p_key1,p_key2,p_key3)
              RETURNING p_npq.npq11
           END IF                         #CHI-850014 add
                
        WHEN 2
           IF cl_null(p_npq.npq12) THEN   #CHI-850014 add
              SELECT * INTO l_ahf.* FROM ahf_file
               WHERE ahf01=p_ahf01 AND ahf02=p_ahf02 AND ahf03='2'
                 AND ahf00=p_bookno  #No.FUN-730020
              CALL s_def_npq2(p_ahf02,l_ahf.ahf04,p_key1,p_key2,p_key3)
              RETURNING p_npq.npq12
           END IF                         #CHI-850014 add
 
        WHEN 3
           IF cl_null(p_npq.npq13) THEN   #CHI-850014 add
              SELECT * INTO l_ahf.* FROM ahf_file
               WHERE ahf01=p_ahf01 AND ahf02=p_ahf02 AND ahf03='3'
                 AND ahf00=p_bookno  #No.FUN-730020
              CALL s_def_npq2(p_ahf02,l_ahf.ahf04,p_key1,p_key2,p_key3)
              RETURNING p_npq.npq13
           END IF                         #CHI-850014 add

        WHEN 4
           IF cl_null(p_npq.npq14) THEN   #CHI-850014 add
              SELECT * INTO l_ahf.* FROM ahf_file
               WHERE ahf01=p_ahf01 AND ahf02=p_ahf02 AND ahf03='4'
                 AND ahf00=p_bookno  #No.FUN-730020
              CALL s_def_npq2(p_ahf02,l_ahf.ahf04,p_key1,p_key2,p_key3)
              RETURNING p_npq.npq14
           END IF                         #CHI-850014 add
 
#FUN-B50105   ---start   Add
     END CASE
   END FOR
   FOR l_seq = 1 TO g_aaz.aaz125
     INITIALIZE l_aag.* TO NULL
     INITIALIZE l_ahf.* TO NULL
     SELECT * INTO l_aag.* FROM aag_file WHERE aag01=p_npq.npq03
                                           AND aag00=p_bookno
     CASE l_seq
#FUN-B50105   ---end     Add
 
        WHEN 5
           IF cl_null(p_npq.npq31) THEN   #CHI-850014 add
              SELECT * INTO l_ahf.* FROM ahf_file
               WHERE ahf01=p_ahf01 AND ahf02=p_ahf02 AND ahf03='5'
                 AND ahf00=p_bookno  #No.FUN-730020
              CALL s_def_npq2(p_ahf02,l_ahf.ahf04,p_key1,p_key2,p_key3)
              RETURNING p_npq.npq31
           END IF                         #CHI-850014 add
 
        WHEN 6
           IF cl_null(p_npq.npq32) THEN   #CHI-850014 add
              SELECT * INTO l_ahf.* FROM ahf_file
               WHERE ahf01=p_ahf01 AND ahf02=p_ahf02 AND ahf03='6'
                 AND ahf00=p_bookno  #No.FUN-730020
              CALL s_def_npq2(p_ahf02,l_ahf.ahf04,p_key1,p_key2,p_key3)
              RETURNING p_npq.npq32
           END IF                         #CHI-850014 add
 
        WHEN 7
           IF cl_null(p_npq.npq33) THEN   #CHI-850014 add
              SELECT * INTO l_ahf.* FROM ahf_file
               WHERE ahf01=p_ahf01 AND ahf02=p_ahf02 AND ahf03='7'
                 AND ahf00=p_bookno  #No.FUN-730020
              CALL s_def_npq2(p_ahf02,l_ahf.ahf04,p_key1,p_key2,p_key3)
              RETURNING p_npq.npq33
           END IF                         #CHI-850014 add
 
        WHEN 8
           IF cl_null(p_npq.npq34) THEN   #CHI-850014 add
              SELECT * INTO l_ahf.* FROM ahf_file
               WHERE ahf01=p_ahf01 AND ahf02=p_ahf02 AND ahf03='8'
                 AND ahf00=p_bookno  #No.FUN-730020
              CALL s_def_npq2(p_ahf02,l_ahf.ahf04,p_key1,p_key2,p_key3)
              RETURNING p_npq.npq34
           END IF                         #CHI-850014 add
 
        WHEN 9
           IF cl_null(p_npq.npq35) THEN   #CHI-850014 add
              SELECT * INTO l_ahf.* FROM ahf_file
               WHERE ahf01=p_ahf01 AND ahf02=p_ahf02 AND ahf03='9'
                 AND ahf00=p_bookno  #No.FUN-730020
              CALL s_def_npq2(p_ahf02,l_ahf.ahf04,p_key1,p_key2,p_key3)
              RETURNING p_npq.npq35
           END IF                         #CHI-850014 add
 
        WHEN 10
           IF cl_null(p_npq.npq36) THEN   #CHI-850014 add
              SELECT * INTO l_ahf.* FROM ahf_file
               WHERE ahf01=p_ahf01 AND ahf02=p_ahf02 AND ahf03='10'
                 AND ahf00=p_bookno  #No.FUN-730020
              CALL s_def_npq2(p_ahf02,l_ahf.ahf04,p_key1,p_key2,p_key3)
              RETURNING p_npq.npq36
           END IF                         #CHI-850014 add
     END CASE
   END FOR
   #for 關係人
   IF cl_null(p_npq.npq37) THEN   #CHI-850014 add
      INITIALIZE l_ahf.* TO NULL
      SELECT * INTO l_ahf.* FROM ahf_file
       WHERE ahf01=p_ahf01 AND ahf02=p_ahf02 AND ahf03='99'
         AND ahf00=p_bookno  #No.FUN-730020
      CALL s_def_npq2(p_ahf02,l_ahf.ahf04,p_key1,p_key2,p_key3)
      RETURNING p_npq.npq37
   END IF                         #CHI-850014 add
#No.FUN-C90061  ---begin---
   IF g_aza.aza26 = '2' AND l_i > 0  THEN
      LET p_npq.npq11 = p_npq.npq21
   END IF
#No.FUN-C90061  ---end---
   RETURN p_npq.*
END FUNCTION
#end MOD-860011 add
