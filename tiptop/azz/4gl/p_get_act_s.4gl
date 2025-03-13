# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: p_get_act_s.4gl
# Descriptions...: 1.會抓取所有寫在 p_link 作業中的程式資料 (p_get_act提供檔名)
#                  2.程式行起始若為 #井號 --雙短線 {左大括號  則該行視為註解
#                  3.若行首為 {} or  該整行一樣視為註解, 理由同上
#                  4.抓取 LET g_action_choice= 資料以供判斷權限用
#                  5.如果一行已發現 on action, 此行決不可出現 let g_action...
# Date & Author..: 04/04/06 alex
# Modify.........: No.MOD-490479 04/09/30 By alex 修 gap06="Y" 後有 g_action_choice
# Modify.........: No.MOD-570108 05/07/05 By alex 修 g_action_choice 後加註解
# Modify.........: No.FUN-570088 05/07/10 By alex 原為s_get_act現移至azz並修為p_get_act_s.4gl
# Modify.........: No.FUN-580025 05/08/22 By alex add actions never been checked
# Modify.........: No.FUN-620012 06/02/09 By alex 開放同一行可以寫on act及let g_act..
# Modify.........: No.FUN-680135 06/08/31 By Hellen 欄位類型修改
# Modify.........: No.FUN-6A0096 06/10/26 By johnray l_time轉g_time
# Modify.........: No.MOD-6B0118 06/12/13 By pengu 在ON ACTION之前誤用了<tab>，將會造成get_action判讀錯誤
# Modify.........: No.FUN-880019 08/09/18 By alex 補上若檔案不存在則不要再查 (安全機制處理)
 
IMPORT os   #FUN-880019
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
FUNCTION p_get_act_s(ls_prog)
 
    DEFINE ls_prog       STRING
    DEFINE lp_prog       base.Channel
    DEFINE lc_analy      LIKE type_file.chr1000  #FUN-680135 VARCHAR(200)
    DEFINE ls_analy      STRING
    DEFINE li_i,li_j     LIKE type_file.num5     #FUN-680135 SMALLINT 
    DEFINE li_length     LIKE type_file.num5     #FUN-680135 SMALLINT 
    DEFINE la_get        DYNAMIC ARRAY OF RECORD
             gap02         LIKE gap_file.gap02,
             gap06         LIKE gap_file.gap06
                         END RECORD
    DEFINE li_array      LIKE type_file.num5     #FUN-680135 SMALLINT 
    DEFINE ls_compose    STRING
    DEFINE ls_controled  STRING
    DEFINE ls_analy_tmp  STRING     #FUN-620012
 
    LET ls_compose = ""
 
    #安全機制的action id需要以合法的方式補到別支作業  #FUN-880019
    IF NOT os.Path.exists(ls_prog) THEN
       RETURN "",""
    END IF
 
    LET lp_prog = base.Channel.create()
    CALL lp_prog.openFile(ls_prog,"r")
 
    WHILE lp_prog.read([lc_analy])
       LET ls_analy = DOWNSHIFT(lc_analy)
       LET ls_analy = ls_analy.trim()
 
       # 2004/04/24 先判斷本行行頭是否以 # 或 -- 為開頭, 如果是就放棄這個找下個
       # 2004/06/29 補上 { 符號   請勿在行首放大括號
       IF ls_analy.subString(1,1) = "#" OR ls_analy.subString(1,2) = "--" OR
          ls_analy.subString(1,1) = "{" THEN
          CONTINUE WHILE
       END IF
 
       LET ls_analy_tmp = ls_analy.trim()    #FUN-620012
 
       # 2004/04/24 抓 ON ACTION
       CALL ls_analy.getIndexOf("on action",1) RETURNING li_i
       IF li_i > 0 THEN
         #---------------MOD-6B0118 modify
         #LET ls_analy = ls_analy.subString(10,ls_analy.getLength())
          LET ls_analy = ls_analy.subString(li_i+9,ls_analy.getLength())
         #---------------MOD-6B0118 end
          LET ls_analy = ls_analy.trim()
          LET li_length = ls_analy.getLength()
          FOR li_j=1 TO li_length
             IF ls_analy.getCharAt(li_j) = " " THEN
                LET ls_analy = ls_analy.subString(1,li_j-1)
                EXIT FOR
             END IF
             IF li_j = li_length THEN
                LET ls_analy = ls_analy.subString(1,li_j)
                EXIT FOR
             END IF
          END FOR
 
          # 比對是否已經有加進來的  所以把它寫到 array 最後再組出來
          LET li_array = la_get.getLength()
          FOR li_j=1 TO li_array
              IF ls_analy.trim() = la_get[li_j].gap02 CLIPPED THEN
                 CONTINUE WHILE
              END IF
          END FOR
          LET la_get[li_array+1].gap02 = ls_analy CLIPPED
       END IF
 
       LET ls_analy = ls_analy_tmp.trim()    #FUN-620012
 
       # 2004/09/30 抓 LET g_action_choice
       CALL ls_analy.getIndexOf("let g_action_choice",1) RETURNING li_i
       IF li_i > 0 THEN
          CALL ls_analy.getIndexOf("=",1) RETURNING li_j
          LET ls_analy = ls_analy.subString(li_j+1,ls_analy.getLength())
          LET ls_analy = ls_analy.trim()
          IF ls_analy IS NULL THEN
             CONTINUE WHILE
          END IF
           # 2005/07/05 MOD-570108
          CALL ls_analy.getIndexOf(" ",1) RETURNING li_j
          IF li_j THEN
             LET ls_analy = ls_analy.subString(1,li_j-1)
          END IF
          LET li_length = ls_analy.getLength()
          LET ls_analy = ls_analy.subString(2,li_length-1)
          IF ls_analy IS NULL OR ls_analy = "exit" OR ls_analy = "about" THEN
             CONTINUE WHILE
          END IF
          ##
 
          # 比對是否已經有加進來的  所以把它寫到 array 最後再組出來
          LET li_array = la_get.getLength()
          FOR li_j=1 TO li_array
              IF ls_analy.trim() = la_get[li_j].gap02 CLIPPED THEN
                 LET la_get[li_j].gap06 = "Y"
              END IF
          END FOR
       END IF
 
    END WHILE
 
    CALL lp_prog.close()
    LET ls_compose=""
    LET ls_controled=""
 
    # 抓 array 組合
    LET li_array = la_get.getLength()
    FOR li_j=1 TO li_array
       LET ls_compose = ls_compose, la_get[li_j].gap02 CLIPPED, ", "
       IF la_get[li_j].gap06 = "Y" AND     #FUN-580025
          la_get[li_j].gap02 <> "exit"     AND la_get[li_j].gap02 <> "help"  AND
          la_get[li_j].gap02 <> "controlp" AND la_get[li_j].gap02 <> "first" AND
          la_get[li_j].gap02 <> "locale"   AND la_get[li_j].gap02 <> "jump"  AND
          la_get[li_j].gap02 <> "previous" AND la_get[li_j].gap02 <> "next"  AND
          la_get[li_j].gap02 <> "last"     THEN
          LET ls_controled = ls_controled, la_get[li_j].gap02 CLIPPED, ", "
       END IF
    END FOR
 
    LET ls_compose = ls_compose.subString(1,ls_compose.getLength()-2)
    LET ls_controled = ls_controled.subString(1,ls_controled.getLength()-2)
 
    RETURN ls_compose,ls_controled
 
END FUNCTION
