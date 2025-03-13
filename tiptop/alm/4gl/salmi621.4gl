# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: "salmi621.4gl"
# Descriptions...: 卡密碼維護作業
# Date & Author..: NO.FUN-CA0103 12/10/25 By xumeimei
# Modify.........: No:FUN-D30007 13/03/04 By pauline 異動lpj_file時同步異動lpjpos欄位


IMPORT JAVA java.security.MessageDigest
IMPORT JAVA java.lang.String
IMPORT JAVA java.lang.Byte
IMPORT JAVA java.lang.Integer
DATABASE ds
 
GLOBALS "../../config/top.global"

FUNCTION si621_set(p_prog,p_type,p_bcard,p_ecard,p_setb,p_inTransaction)
   DEFINE p_prog           LIKE type_file.chr1    #'1'->設置密碼'2'->重置密碼
   DEFINE p_type           LIKE type_file.chr1    #'1'->批量設置'2'->單筆設置
   DEFINE p_inTransaction  LIKE type_file.num5    #TRUE->在事務中FALSE->不在事務中
   DEFINE p_bcard          LIKE lpt_file.lpt02    #p_setb ='1' NULL 批量設置：開始卡號 單筆設置：卡號
   DEFINE p_ecard          LIKE lpt_file.lpt021   #p_setb ='1' NULL 批量設置：結束卡號 單筆設置：NULL
   DEFINE p_setb           LIKE type_file.chr1    #'1'->錄入卡號'2'->自動帶出卡號
   DEFINE becard           LIKE lpt_file.lpt02    #開始卡號
   DEFINE encard           LIKE lpt_file.lpt021   #結束卡號
   DEFINE passwd1          LIKE lpj_file.lpj26    #原密碼
   DEFINE passwd2          LIKE lpj_file.lpj26    #設置新密碼
   DEFINE passwd3          LIKE lpj_file.lpj26    #確認新密碼
   DEFINE l_lpj            RECORD LIKE lpj_file.*
   DEFINE l_n              LIKE type_file.num10
   DEFINE l_lpj26          LIKE lpj_file.lpj26
   DEFINE g_return         LIKE lpj_file.lpj26
   DEFINE g_cnt            LIKE type_file.num10   #更新笔数
   DEFINE l_lpj09          LIKE lpj_file.lpj09
   DEFINE l_lph46          LIKE lph_file.lph46
   DEFINE l_sql            STRING

   OPEN WINDOW si621_w WITH FORM "alm/42f/almi621"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()
   IF p_prog = '1' THEN
      CALL cl_set_comp_visible("passwd1",TRUE) 
   END IF
   IF p_prog = '2' THEN
      CALL cl_set_comp_visible("passwd1",FALSE) 
   END IF
   IF p_type = '1' THEN
      CALL cl_set_act_visible("batch_set",FALSE)
      CALL cl_set_act_visible("single_set",TRUE)
      CALL cl_set_comp_visible("encard",TRUE)   
   END IF
   IF p_type = '2' THEN
      CALL cl_set_act_visible("batch_set",TRUE)
      CALL cl_set_act_visible("single_set",FALSE)
      CALL cl_set_comp_visible("encard",FALSE)   
   END IF
   IF p_setb = '1' THEN
      CALL cl_set_comp_entry("becard",TRUE)
      CALL cl_set_comp_entry("encard",TRUE)
   END IF
   IF p_setb = '2' THEN
      CALL cl_set_comp_entry("becard",FALSE)
      CALL cl_set_comp_entry("encard",FALSE)
      LET becard = p_bcard
      LET encard = p_ecard
      DISPLAY BY NAME becard
      DISPLAY BY NAME encard
   END IF
   DISPLAY ' ' TO FORMONLY.cnt
   IF p_setb = '2' THEN 
      LET l_lpj26 = NULL
      SELECT lpj26 INTO l_lpj26
        FROM lpj_file
       WHERE lpj03 = becard
      IF cl_null(l_lpj26) THEN
          CALL cl_set_comp_entry("passwd1",FALSE)
      END IF
      DIALOG ATTRIBUTES(UNBUFFERED) 
         INPUT BY NAME passwd1,passwd2,passwd3
            AFTER FIELD passwd1
               IF p_prog = '1' AND NOT cl_null(passwd1) THEN
                  LET l_n = 0
                  IF cl_null(encard) THEN
                     SELECT COUNT(*) INTO l_n
                       FROM lpj_file
                      WHERE lpj03 = becard
                        AND lpj26 IS NOT NULL
                  ELSE
                     SELECT COUNT(*) INTO l_n
                       FROM lpj_file
                      WHERE lpj03 BETWEEN becard AND encard
                        AND lpj26 IS NOT NULL
                  END IF
                  IF l_n > 0 THEN
                     CALL si621_chk_passwd(becard,encard,passwd1)
                     IF NOT cl_null(g_errno) THEN
                        CALL cl_err('',g_errno,0)
                        NEXT FIELD passwd1
                     END IF
                  END IF
               END IF
            AFTER FIELD passwd2
               IF NOT cl_null(passwd2) THEN
                  IF LENGTH(passwd2) > 10 THEN
                     CALL cl_err('','apc1024',0)
                     NEXT FIELD passwd2
                  END IF
                  IF NOT cl_null(passwd3) THEN
                     IF passwd2 <> passwd3 THEN
                        CALL cl_err('','apc1027',0)
                        LET passwd2 = ''
                        NEXT FIELD passwd2
                     END IF
                  END IF
               END IF
            BEFORE FIELD passwd3
               IF cl_null(passwd2) THEN
                  CALL cl_err('','apc1025',0)
                  NEXT FIELD passwd2
               END IF
            AFTER FIELD passwd3
               IF NOT cl_null(passwd3) THEN
                  IF LENGTH(passwd3) > 10 THEN
                     CALL cl_err('','apc1024',0)
                     NEXT FIELD passwd3
                  END IF
                  IF NOT cl_null(passwd2) THEN
                     IF passwd2 <> passwd3 THEN
                        CALL cl_err('','apc1027',0)
                        LET passwd3 = ''
                        NEXT FIELD passwd3
                     END IF
                  END IF
               END IF
           AFTER INPUT
               IF NOT cl_null(becard) AND NOT cl_null(passwd3) THEN
                  CALL si621_upd(p_inTransaction,becard,encard,passwd3)
                  IF NOT cl_null(encard) THEN
                     SELECT COUNT(*) INTO g_cnt
                       FROM lpj_file
                      WHERE lpj03 BETWEEN becard AND encard
                  ELSE
                     SELECT COUNT(*) INTO g_cnt
                       FROM lpj_file
                      WHERE lpj03 = becard 
                  END IF
                  DISPLAY g_cnt TO FORMONLY.cnt
                  LET INT_FLAG=1
               END IF
         END INPUT
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DIALOG
         ON ACTION HELP
            CALL cl_show_help()
         ON ACTION EXIT
            LET INT_FLAG=1
            EXIT DIALOG
         ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()
         ON ACTION about
            CALL cl_about()
         ON ACTION CLOSE
            LET INT_FLAG=1
            EXIT DIALOG
         ON ACTION ACCEPT
            IF NOT cl_null(passwd2) AND NOT cl_null(passwd3) THEN
               IF passwd2 <> passwd3 THEN
                  CALL cl_err('','apc1027',0)
                  LET passwd3 = ''
                  NEXT FIELD passwd3
               END IF
            END IF
            IF NOT cl_null(becard) AND NOT cl_null(passwd3) THEN
               CALL si621_upd(p_inTransaction,becard,encard,passwd3)
               IF NOT cl_null(encard) THEN
                  SELECT COUNT(*) INTO g_cnt
                    FROM lpj_file
                   WHERE lpj03 BETWEEN becard AND encard
               ELSE
                  SELECT COUNT(*) INTO g_cnt
                    FROM lpj_file
                   WHERE lpj03 = becard
               END IF
               DISPLAY g_cnt TO FORMONLY.cnt
            END IF
            LET INT_FLAG=1
            EXIT DIALOG
         ON ACTION CANCEL
            LET INT_FLAG=1
            EXIT DIALOG
         ON ACTION CONTROLG
            CALL cl_cmdask()
      END DIALOG
   END IF
   IF p_setb ='1' THEN
      DIALOG ATTRIBUTES(UNBUFFERED) 
         INPUT BY NAME becard,encard,passwd1,passwd2,passwd3
            AFTER FIELD becard
               IF NOT cl_null(becard) THEN
                  LET l_n = 0
                  SELECT COUNT(*) INTO l_n 
                    FROM lpj_file
                   WHERE lpj03 = becard
                  IF l_n = 0 THEN
                     CALL cl_err('','alm-202',0)
                     NEXT FIELD becard 
                  END IF
                  CALL si621_chk(becard,encard)
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err('',g_errno,0)
                     NEXT FIELD becard
                  END IF
                  LET l_n = 0
                  IF NOT cl_null(encard) THEN
                     SELECT COUNT(*) INTO l_n
                       FROM lpj_file
                      WHERE lpj03 BETWEEN becard AND encard
                        AND lpj26 IS NOT NULL
                  ELSE
                     SELECT COUNT(*) INTO l_n
                       FROM lpj_file
                      WHERE lpj03 = becard
                        AND lpj26 IS NOT NULL
                  END IF
                  IF l_n = 0 THEN
                     LET passwd1 = NULL
                     CALL cl_set_comp_entry("passwd1",FALSE)
                  ELSE
                     CALL cl_set_comp_entry("passwd1",TRUE)
                  END IF
                  IF cl_null(encard) AND p_type = '1' THEN
                     LET encard = becard
                  END IF
               END IF
            AFTER FIELD encard
               IF NOT cl_null(encard) THEN
                  LET l_n = 0
                  SELECT COUNT(*) INTO l_n 
                    FROM lpj_file
                   WHERE lpj03 = encard
                  IF l_n = 0 THEN
                     CALL cl_err('','alm-202',0)
                     NEXT FIELD encard
                  END IF
                  CALL si621_chk(becard,encard)
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err('',g_errno,0)
                     NEXT FIELD encard
                  END IF
                  LET l_n = 0
                  IF NOT cl_null(becard) THEN
                     SELECT COUNT(*) INTO l_n
                       FROM lpj_file
                      WHERE lpj03 BETWEEN becard AND encard
                        AND lpj26 IS NOT NULL
                  ELSE
                     SELECT COUNT(*) INTO l_n
                       FROM lpj_file
                      WHERE lpj03 = encard
                        AND lpj26 IS NOT NULL
                  END IF
                  IF l_n = 0 THEN
                     LET passwd1 = NULL
                     CALL cl_set_comp_entry("passwd1",FALSE)
                  ELSE
                     CALL cl_set_comp_entry("passwd1",TRUE)
                  END IF
               END IF
            AFTER FIELD passwd1
               IF NOT cl_null(passwd1) THEN
                  LET l_n = 0
                  IF NOT cl_null(encard) THEN
                     SELECT COUNT(*) INTO l_n
                       FROM lpj_file
                      WHERE lpj03 BETWEEN becard AND encard
                        AND lpj26 IS NOT NULL
                  ELSE
                     SELECT COUNT(*) INTO l_n
                       FROM lpj_file
                      WHERE lpj03 = becard
                        AND lpj26 IS NOT NULL
                  END IF
                  IF l_n > 0 THEN
                     CALL si621_chk_passwd(becard,encard,passwd1)
                     IF NOT cl_null(g_errno) THEN
                        CALL cl_err('',g_errno,0)
                        NEXT FIELD passwd1 
                     END IF
                  END IF
               END IF
            AFTER FIELD passwd2
               IF NOT cl_null(passwd2) THEN 
                  IF LENGTH(passwd2) > 10 THEN 
                     CALL cl_err('','apc1024',0)
                     NEXT FIELD passwd2
                  END IF 
                  IF NOT cl_null(passwd3) THEN
                     IF passwd2 <> passwd3 THEN
                        CALL cl_err('','apc1027',0)
                        LET passwd2 = ''
                        NEXT FIELD passwd2
                     END IF
                  END IF
               END IF 
            BEFORE FIELD passwd3
               IF cl_null(passwd2) THEN 
                  CALL cl_err('','apc1025',0)
                  NEXT FIELD passwd2
               END IF 
            AFTER FIELD passwd3
               IF NOT cl_null(passwd3) THEN    
                  IF LENGTH(passwd3) > 10 THEN 
                     CALL cl_err('','apc1024',0)
                     NEXT FIELD passwd3
                  END IF 
                  IF NOT cl_null(passwd2) THEN
                     IF passwd2 <> passwd3 THEN
                        CALL cl_err('','apc1027',0)
                        LET passwd3 = ''
                        NEXT FIELD passwd3
                     END IF
                  END IF
               END IF 
            ON ACTION controlp
               CASE
                  WHEN INFIELD(becard)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_lpj03q"
                     CALL cl_create_qry() RETURNING becard
                     DISPLAY BY NAME becard
                     NEXT FIELD becard

                  WHEN INFIELD(encard)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_lpj03q"
                     CALL cl_create_qry() RETURNING encard
                     DISPLAY BY NAME encard
                     NEXT FIELD encard
               END CASE
            AFTER INPUT
               IF NOT cl_null(becard) AND NOT cl_null(passwd3) THEN
                  CALL si621_upd(p_inTransaction,becard,encard,passwd3)
                  IF NOT cl_null(encard) THEN
                     SELECT COUNT(*) INTO g_cnt
                       FROM lpj_file
                      WHERE lpj03 BETWEEN becard AND encard
                  ELSE
                     SELECT COUNT(*) INTO g_cnt
                       FROM lpj_file
                      WHERE lpj03 = becard
                  END IF
                  DISPLAY g_cnt TO FORMONLY.cnt
                  LET becard = NULL
                  LET encard = NULL
                  LET passwd1 = NULL
                  LET passwd2 = NULL
                  LET passwd3 = NULL
               END IF
               NEXT FIELD becard
         END INPUT
         ON ACTION batch_set
            LET g_action_choice="batch_set"
            LET p_type = '1'
            CALL cl_set_act_visible("batch_set",FALSE)
            CALL cl_set_act_visible("single_set",TRUE)
            CALL cl_set_comp_visible("encard",TRUE)
            LET becard = NULL
            LET encard = NULL
            LET passwd1 = NULL
            LET passwd2 = NULL
            LET passwd3 = NULL
            NEXT FIELD becard
            IF cl_null(becard) THEN  
               CALL cl_set_comp_entry("passwd1",TRUE)
            END IF
            CONTINUE DIALOG
         ON ACTION single_set
            LET g_action_choice="single_set"
            LET p_type = '2'
            CALL cl_set_act_visible("batch_set",TRUE)
            CALL cl_set_act_visible("single_set",FALSE)
            CALL cl_set_comp_visible("encard",FALSE)
            LET becard = NULL
            LET encard = NULL
            LET passwd1 = NULL
            LET passwd2 = NULL
            LET passwd3 = NULL
            NEXT FIELD becard
            IF cl_null(becard) THEN
               CALL cl_set_comp_entry("passwd1",TRUE)
            END IF
            CONTINUE DIALOG
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DIALOG 
         ON ACTION HELP
            CALL cl_show_help()
         ON ACTION EXIT
            LET INT_FLAG=1
            EXIT DIALOG 
         ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()
         ON ACTION about
            CALL cl_about()
         ON ACTION CLOSE
            LET INT_FLAG=1
            EXIT DIALOG 
         ON ACTION ACCEPT
            IF NOT cl_null(passwd2) AND NOT cl_null(passwd3) THEN
               IF passwd2 <> passwd3 THEN
                  CALL cl_err('','apc1027',0)
                  LET passwd3 = ''
                  NEXT FIELD passwd3
               END IF
            END IF
            IF NOT cl_null(becard) AND NOT cl_null(passwd3) THEN
               CALL si621_upd(p_inTransaction,becard,encard,passwd3)
               IF NOT cl_null(encard) THEN
                  SELECT COUNT(*) INTO g_cnt
                    FROM lpj_file
                   WHERE lpj03 BETWEEN becard AND encard
               ELSE
                  SELECT COUNT(*) INTO g_cnt
                    FROM lpj_file
                   WHERE lpj03 = becard
               END IF
               DISPLAY g_cnt TO FORMONLY.cnt
               LET becard = NULL
               LET encard = NULL
               LET passwd1 = NULL
               LET passwd2 = NULL
               LET passwd3 = NULL
               NEXT FIELD becard
            END IF
            CONTINUE DIALOG
         ON ACTION CANCEL
            LET INT_FLAG=1
            EXIT DIALOG
         ON ACTION CONTROLG
            CALL cl_cmdask()
      END DIALOG
   END IF
   IF INT_FLAG THEN
      LET INT_FLAG=0
      CLOSE WINDOW si621_w
      RETURN    
   END IF
END FUNCTION

FUNCTION si621_upd(p_inTransaction,becard,encard,passwd3)
   DEFINE p_inTransaction  LIKE type_file.num5    #TRUE->在事務中FALSE->不在事務中
   DEFINE becard           LIKE lpt_file.lpt02    #開始卡號
   DEFINE encard           LIKE lpt_file.lpt021   #結束卡號
   DEFINE passwd3          LIKE lpj_file.lpj26
   DEFINE l_newpw          LIKE lpj_file.lpj26
   DEFINE l_sql            STRING
   DEFINE l_lpj03          LIKE lpj_file.lpj03
   DEFINE l_str            STRING
   DEFINE l_lpjpos    LIKE lpj_file.lpjpos  #FUN-D30007 add
   DEFINE l_lpjpos_o  LIKE lpj_file.lpjpos  #FUN-D30007 add

   IF cl_null(encard) THEN
      LET encard = becard
   END IF

  #FUN-D30007 add START
   SELECT lpjpos INTO l_lpjpos_o FROM lpj_file WHERE lpj03 = l_lpj03 
   IF l_lpjpos_o <> '1' THEN
      LET l_lpjpos = '2'
   ELSE
      LET l_lpjpos = '1'
   END IF
  #FUN-D30007 add END

   LET g_success = 'Y'
   IF NOT p_inTransaction THEN
      BEGIN WORK
      LET l_sql = " SELECT lpj03 FROM lpj_file",
                  "  WHERE lpj03 BETWEEN '",becard,"' AND '",encard,"'"
      PREPARE si621_sel_lpj_pb FROM l_sql
      DECLARE si621_sel_lpj_cs CURSOR FOR si621_sel_lpj_pb
      FOREACH si621_sel_lpj_cs INTO l_lpj03
         LET l_str = l_lpj03,passwd3
         CALL si621_changepw(l_str) RETURNING l_newpw
         UPDATE lpj_file SET lpj26 = l_newpw,
                             lpjpos = l_lpjpos   #FUN-D30007 add
          WHERE lpj03 = l_lpj03
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","lpj_file",becard,encard,SQLCA.sqlcode,"","",1)
            ROLLBACK WORK
            LET g_success = 'N'
            EXIT FOREACH
         END IF
      END FOREACH
      IF g_success = 'Y' THEN
         CALL cl_err('','alm1387',1)
         COMMIT WORK
      END IF
   ELSE
      LET l_sql = " SELECT lpj03 FROM lpj_file",
                  "  WHERE lpj03 BETWEEN '",becard,"' AND '",encard,"'"
      PREPARE si621_sel_lpj_pb1 FROM l_sql
      DECLARE si621_sel_lpj_cs1 CURSOR FOR si621_sel_lpj_pb1
      FOREACH si621_sel_lpj_cs1 INTO l_lpj03
         LET l_str = l_lpj03,passwd3
         CALL si621_changepw(l_str) RETURNING l_newpw
         UPDATE lpj_file SET lpj26 = l_newpw,
                             lpjpos = l_lpjpos   #FUN-D30007 add
          WHERE lpj03 = l_lpj03
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","lpj_file",becard,encard,SQLCA.sqlcode,"","",1)
            LET g_success = 'N'
            EXIT FOREACH
         END IF
      END FOREACH
      IF g_success = 'Y' THEN
         CALL cl_err('','alm1387',1)
      END IF
   END IF
END FUNCTION

FUNCTION si621_changepw(l_str)
   DEFINE l_str       java.lang.String               #要加密的明文
   DEFINE l_digest    java.security.MessageDigest    #加密演算法物件
   DEFINE l_ength     INTEGER                        #加密後長度(應該為16 Byte)
   DEFINE l_i         SMALLINT
   DEFINE l_byte      java.lang.Byte                 #加密後每一個Byte值(有可能為負數)
   DEFINE l_encrypt   STRING                         #以MD5來說加密後就是32位16進制的數值字串
   DEFINE l_tmp       STRING
   DEFINE l_int       INTEGER

   LET l_encrypt = ""

   IF l_str IS NULL THEN
      display "Encryption string is null."
      LET g_success = 'N'
      RETURN 
   END IF

   TRY
      #指定加密演算法
      LET l_digest = java.security.MessageDigest.getInstance("MD5")
      #將字串轉換成byte,並傳送要演算的字串

      CALL l_digest.update(l_str.getBytes())

      #原則上MD5加密後長度應該會是16 bytes
      LET l_ength = l_digest.getDigestLength()       #因為在java裡無法做byte與java.lang.Byte的型態轉換
      #而且在4gl code中又無法引用java裡byte這個基本型態
      #因此只能利用for迴圈逐一抓出byte的值,順便做16進制的轉換
      FOR l_i = 1 TO l_ength
         #逐一取出每一個byte加密後的值
         LET l_byte = java.lang.Byte.valueOf(l_digest.digest()[l_i])
         #DISPLAY "digest[", l_i, "]: ", l_byte, ";"

         #java的toHexString參數是int,所以這裡還需做型態轉換
         #心得:利用4gl寫java要特別注意型態,一但型態錯誤就無法做api的呼叫
         LET l_int = l_byte.intValue()

         #因為每一個byte加密後的值有可能是負數,所以需做補數轉換
         #java code本是這樣做:(l_byte & 0XFF)就可以了
         #4gl code就直接將負數加256吧(因為1個byte是8 bit,所以要加上2的8次方=256)
         IF l_byte < 0 THEN
            LET l_int = l_byte.intValue() + 256
         ELSE
            LET l_int = l_byte.intValue()
         END IF

         #進行16進位轉碼,因為需固定取出二位字串故先在前面多加個"0"字串
         #等後面再做subString取出二個長度的字串
         LET l_tmp = java.lang.Integer.toHexString(l_int)
           LET l_tmp = "0", l_tmp
         #取出二位字串
         #範例1,有可能出來的是0:  "0", "0"  = "00"  ===> subString(1, 2)
         #範例2,有可能出來的是FF: "0", "FF" = "0FF" ===> subString(2, 3)
         LET l_tmp = l_tmp.subString(l_tmp.getLength() - 1, l_tmp.getLength())          #組合加密後之16進制的32位元數值字串
         LET l_encrypt = l_encrypt, l_tmp

         #重新傳送要演算的字串
         #要這樣做的原因就在於在for圈裡會再執行l_digest.digest()
         #呼叫digest()時會重新再一次用演算法進行加密
         #這樣下一個再取出的byte值就會和第一次計算的不一樣
         #所以這裡要再重新傳送要演算的字串
         CALL l_digest.update(l_str.getBytes())
      END FOR 
         
      DISPLAY "Encrypt Finish."
   CATCH 
      LET l_encrypt = "" 
      DISPLAY "Error:", STATUS
      display "Generate MD5 key failed."
      LET g_success = 'N'
      RETURN 
   END TRY
            
   RETURN l_encrypt
END FUNCTION
FUNCTION si621_chk(becard,encard)
DEFINE l_sql            STRING
DEFINE becard           LIKE lpj_file.lpj03
DEFINE encard           LIKE lpj_file.lpj03
DEFINE l_lpj09          LIKE lpj_file.lpj09
DEFINE l_lph46          LIKE lph_file.lph46

   LET g_errno = ''

   IF cl_null(encard) THEN
      LET encard = becard
   END IF
   IF becard > encard THEN
      LET g_errno = 'alm1386'
   END IF
   LET l_sql = "SELECT lpj09,lph46",
               "  FROM lpj_file,lph_file",
               " WHERE lpj02 = lph01",
               "   AND lpj03 BETWEEN '",becard,"'",
               "                 AND '",encard,"'"
   PREPARE si621_pb FROM l_sql
   DECLARE si621_cs CURSOR FOR si621_pb
   FOREACH si621_cs INTO l_lpj09,l_lph46
      IF l_lpj09 <> '2' THEN
         LET g_errno = 'alm-818'
         EXIT FOREACH
      END IF
      IF l_lph46 <> 'Y' THEN
         LET g_errno = 'alm1385'
         EXIT FOREACH
      END IF
   END FOREACH
END FUNCTION

FUNCTION si621_chk_passwd(becard,encard,passwd1)
DEFINE l_sql            STRING
DEFINE becard           LIKE lpj_file.lpj03
DEFINE encard           LIKE lpj_file.lpj03
DEFINE passwd1          LIKE lpj_file.lpj26
DEFINE l_lpj03          LIKE lpj_file.lpj03
DEFINE l_lpj26          LIKE lpj_file.lpj26
DEFINE l_str            STRING
DEFINE l_oldpw          LIKE lpj_file.lpj26
 
   LET g_errno = '' 

   IF cl_null(encard) THEN
      LET encard = becard
   END IF
   LET l_sql = "SELECT lpj03,lpj26",
               "  FROM lpj_file",
               " WHERE lpj03 BETWEEN '",becard,"'",
               "                 AND '",encard,"'"
   PREPARE si621_pb_p1 FROM l_sql
   DECLARE si621_cs_p1 CURSOR FOR si621_pb_p1
   FOREACH si621_cs_p1 INTO l_lpj03,l_lpj26
      LET l_str = l_lpj03,passwd1
      CALL si621_changepw(l_str) RETURNING l_oldpw
      IF l_oldpw <> l_lpj26 THEN
         LET g_errno = 'azz-865'
         EXIT FOREACH
      END IF
   END FOREACH
END FUNCTION
#FUN-CA0103
