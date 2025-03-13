# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: p_get_lib_s.4gl
# Descriptions...: 1.由 p_get_lib 提供檔名,本函式抓取各別 FUNCTION 說明並新增
#                    至資料庫中
#                  2.程式說明必須由 # 起始
#                  3.程式開始前的說明歸第一支函式所有
#                  4.其餘部份僅抓取 END FUNCTION 至下一個 FUNCTION 間的說明
#                  5.範例:如本函式所示
# Date & Author..: 04/04/06 alex   #FUN-760087
# Modify.........: No.FUN-770018 07/07/06 By alex 放大欄寬及加入private func
# Modify.........: No.FUN-880019 08/09/18 By alex 補上若檔案不存在則不要再查 (安全機制處理)
# Modify.........: No.TQC-B60016 11/06/08 By Kevin 排除remark 的函式

 
IMPORT os
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #No.FUN-980030

FUNCTION p_get_lib_s(ls_prog,ls_path)
 
    DEFINE ls_prog       STRING
    DEFINE ls_path       STRING
    DEFINE lp_prog       base.Channel
    DEFINE la_hjb        RECORD LIKE hjb_file.*
    DEFINE lc_analy      LIKE type_file.chr1000  #FUN-760087 VARCHAR(200)
    DEFINE ls_analy      STRING
    DEFINE li_i,li_stat  LIKE type_file.num5     #FUN-680135 SMALLINT 
    DEFINE li_j          LIKE type_file.num5     #FUN-680135 SMALLINT 
    DEFINE li_cnt        LIKE type_file.num5     #FUN-680135 SMALLINT 
    DEFINE ls_analy_tmp  STRING     #FUN-620012
 
    LET lp_prog = base.Channel.create()
 
    #因應安全機制設計,需先檢查,若不存在則跳過此作業   #FUN-880019
    IF NOT os.Path.exists(ls_path.trim()) THEN
       RETURN
    END IF
 
    CALL lp_prog.openFile(ls_path.trim(),"r")
    INITIALIZE la_hjb TO NULL
    LET la_hjb.hjb01 = ls_prog.trim()
    LET la_hjb.hjb03 = "Y"
    LET li_stat = 0
    LET li_j = 0
 
    WHILE lp_prog.read([lc_analy])
       LET lc_analy = lc_analy CLIPPED
       LET ls_analy = DOWNSHIFT(lc_analy)
 
       # 判斷本行行頭是否以 # 為開頭 (此為規則)
       IF NOT ls_analy.subString(1,1) = "#" AND
          NOT ls_analy.getIndexOf("function",1) THEN
          CONTINUE WHILE
       END IF
 
       # 程式開始 li_stat = 0, FUNTION內 = 2, 兩FUNCTION間 = 1
       CALL ls_analy.getIndexOf("function",1) RETURNING li_i
       IF li_i > 0 AND li_i < 10 THEN
          IF ls_analy.getIndexOf("end ",1) <> 0 AND ls_analy.getIndexOf("end ",1) < li_i THEN
             LET li_stat = 1
          ELSE
             IF NOT ls_analy.getIndexOf("(",1) THEN 
                CONTINUE WHILE
             END IF
             
             IF ls_analy.getIndexOf("#function",1) THEN #TQC-B60016
                LET la_hjb.hjb03 = "N"
                CONTINUE WHILE
             END IF

             LET li_stat = 2
             LET ls_analy_tmp = lc_analy[li_i+8, ls_analy.getLength()]
             LET ls_analy_tmp = ls_analy_tmp.trim()
             LET la_hjb.hjb02 = ls_analy_tmp.subString(1,ls_analy_tmp.getIndexOf("(",1)-1) 
 
             SELECT COUNT(*) INTO li_cnt FROM hjb_file
              WHERE hjb01 = la_hjb.hjb01 AND hjb02 = la_hjb.hjb02
             IF li_cnt > 0 THEN
                UPDATE hjb_file SET hjb03 = la_hjb.hjb03, hjb04 = la_hjb.hjb04,
                                    hjb05 = la_hjb.hjb05, hjb06 = la_hjb.hjb06,
                                    hjb07 = la_hjb.hjb07, hjb08 = la_hjb.hjb08 
                              WHERE hjb01 = la_hjb.hjb01 AND hjb02 = la_hjb.hjb02
             ELSE
	        LET la_hjb.hjboriu = g_user      #No.FUN-980030 10/01/04
	        LET la_hjb.hjborig = g_grup      #No.FUN-980030 10/01/04
	        INSERT INTO hjb_file VALUES(la_hjb.*)
             END IF
             INITIALIZE la_hjb TO NULL
             LET la_hjb.hjb01 = ls_prog.trim()
             LET la_hjb.hjb03 = "Y"
          END IF
       END IF
 
       IF li_stat = 0 OR li_stat = 1 THEN
          IF ls_analy.getIndexOf(".:",1) OR ls_analy.getIndexOf("r:",1) THEN
	     LET li_j = 0 
	  ELSE
             LET ls_analy_tmp = lc_analy CLIPPED
             LET ls_analy_tmp = ls_analy_tmp.subString(2,ls_analy_tmp.getLength())
	     CASE
	        WHEN li_j = 4 LET la_hjb.hjb04 = la_hjb.hjb04, "\n", ls_analy_tmp.trim()
	        WHEN li_j = 5 LET la_hjb.hjb05 = la_hjb.hjb05, "\n", ls_analy_tmp.trim()
	        WHEN li_j = 6 LET la_hjb.hjb06 = la_hjb.hjb06, "\n", ls_analy_tmp.trim()
	        WHEN li_j = 7 LET la_hjb.hjb07 = la_hjb.hjb07, "\n", ls_analy_tmp.trim()
             END CASE
             CONTINUE WHILE
	  END IF
          IF ls_analy.getIndexOf("descriptions.",1) THEN
	     LET li_j = 4
	     LET ls_analy_tmp = lc_analy[2, ls_analy.getLength()]
	     LET ls_analy_tmp = ls_analy_tmp.subString(ls_analy_tmp.getIndexOf(":",1)+1,
	                                               ls_analy_tmp.getLength())
	     LET la_hjb.hjb04 = ls_analy_tmp.trim()
             CONTINUE WHILE
	  END IF
          IF ls_analy.getIndexOf("input parameter",1) THEN
	     LET li_j = 5
	     LET ls_analy_tmp = lc_analy[2, ls_analy.getLength()]
	     LET ls_analy_tmp = ls_analy_tmp.subString(ls_analy_tmp.getIndexOf(":",1)+1,
	                                               ls_analy_tmp.getLength())
	     LET la_hjb.hjb05 = ls_analy_tmp.trim()
             CONTINUE WHILE
	  END IF
          IF ls_analy.getIndexOf("return code.",1) THEN
	     LET li_j = 6
	     LET ls_analy_tmp = lc_analy[2, ls_analy.getLength()]
	     LET ls_analy_tmp = ls_analy_tmp.subString(ls_analy_tmp.getIndexOf(":",1)+1,
	                                               ls_analy_tmp.getLength())
	     LET la_hjb.hjb06 = ls_analy_tmp.trim()
             CONTINUE WHILE
	  END IF
          IF ls_analy.getIndexOf("usage.",1) THEN
	     LET li_j = 7
	     LET ls_analy_tmp = lc_analy[2, ls_analy.getLength()]
	     LET ls_analy_tmp = ls_analy_tmp.subString(ls_analy_tmp.getIndexOf(":",1)+1,
	                                               ls_analy_tmp.getLength())
	     LET la_hjb.hjb07 = ls_analy_tmp.trim()
             CONTINUE WHILE
	  END IF
          IF ls_analy.getIndexOf("private func",1) THEN   #FUN-770018
	     LET la_hjb.hjb03 = "N"
             CONTINUE WHILE
          END IF
       END IF
 
    END WHILE
    CALL lp_prog.close()
 
END FUNCTION
 
 
