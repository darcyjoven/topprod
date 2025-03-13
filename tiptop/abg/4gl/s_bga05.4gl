# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
#□ s_bga05
#SYNTAX.......: LET l_rate = s_bga05(p_ver, p_yy, p_mm, p_curr)
#DESCRIPTION..: 以輸入之版本，年度，月份，幣別取預估匯率檔[bga_file]中
#               之匯率(bga05), 若不存在, 則帶出最近月份的匯率, 否則預設為 1
#PARAMETERS...:	p_ver 	版本
#		p_yy    年度
#               p_mm    月份
#               p_curr  幣別
#RETURNING....: l_rate	匯率
#Date & Author: 02/09/04 By Julius
# modi by yuening 031021:要考慮bgz01(預估匯率是否做版本控管)
# Modify.........: No.FUN-660105 06/06/15 By hellen      cl_err --> cl_err3
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
DEFINE
    g_bga   RECORD  LIKE bga_file.*
 
FUNCTION s_bga05(p_ver, p_yy, p_mm, p_curr)
DEFINE
    p_ver    LIKE bga_file.bga01,
    p_yy     LIKE bga_file.bga02,
    p_mm     LIKE bga_file.bga03,
    p_curr   LIKE bga_file.bga04,
    l_rate   LIKE bga_file.bga05
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF p_curr=g_aza.aza17 THEN RETURN 1.0 END IF  #No.8536
    LET l_rate = 1                               #將匯率預設為 1
    #031021
    SELECT * INTO g_bgz.* FROM bgz_file WHERE bgz00='0'
    IF g_bgz.bgz01='N' THEN LET p_ver=' ' END IF
    #------
    SELECT bga05 INTO l_rate FROM bga_file #抓取資料庫中的匯率
           WHERE bga01 = p_ver AND bga02 = p_yy
             AND bga03 = p_mm AND bga04 = p_curr
    IF sqlca.sqlcode THEN  #當資料庫中沒有當月匯率時,取出當年最近月份的匯率
       SELECT bga05 INTO l_rate FROM bga_file
	      WHERE bga01 = p_ver AND bga02 = p_yy AND bga04 = p_curr
	        AND bga03 = (SELECT MAX(bga03) FROM bga_file
			     WHERE bga01 = p_ver AND bga02 = p_yy
			     AND bga04 = p_curr AND bga03 <= p_mm)
       IF sqlca.sqlcode THEN
#         CALL cl_err('', 'aom-011', 0)                                       #顯示訊息告知使用者     #FUN-660105
          CALL cl_err3("sel","bga_file",p_ver,p_yy,"aom-011","","", 0)        #顯示訊息告知使用者     #FUN-660105
 
          LET l_rate=1
       END IF
    END IF
    RETURN l_rate
END FUNCTION
#Patch....NO.TQC-610035 <001> #
