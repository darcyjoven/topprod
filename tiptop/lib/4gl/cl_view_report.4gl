# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Program name...: cl_view_report.4gl
# Descriptions...: p_zaa_b  zaa_file資料
# Date & Author..: 05/11/02 By Echo
# Usage..........: CALL cl_view_report(p_zaa_b)
# Modify.........: No.FUN-690005 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.FUN-6C0017 06/12/14 By jamie 程式開頭增加'database ds'
# Modify.........: No.FUN-6A0159 07/01/03 By ching-yuan 將欄位屬性為:A.B.C.D.E.F.Q.置中對齊顯示
# Modify.........: No.TQC-6B0183 07/01/08 By Echo 增加語言別的判斷
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.FUN-830021 08/03/06 By alex 移除gay02使用
# Modify.........: No.FUN-B50038 11/05/09 By jrg542 修改 char(1) 定義語言別代碼時發生錯誤  
 
DATABASE ds        #FUN-6C0017   #FUN-7C0053
 
GLOBALS "../../config/top.global"
 
FUNCTION cl_view_report(p_zaa_b)
DEFINE p_zaa_b       DYNAMIC ARRAY of RECORD
            zaa09               LIKE zaa_file.zaa09,
            zaa02               LIKE zaa_file.zaa02,
            zaa03               LIKE zaa_file.zaa03,
            zaa14               LIKE zaa_file.zaa14,
            zaa05               LIKE zaa_file.zaa05,
            zaa06               LIKE zaa_file.zaa06,
            zaa15               LIKE zaa_file.zaa15,
            zaa07               LIKE zaa_file.zaa07,
            zaa18               LIKE zaa_file.zaa18,    #FUN-580020
            zaa08               LIKE zaa_file.zaa08,
            memo                LIKE zab_file.zab05     #MOD-530271
            END RECORD
DEFINE a,b,c          LIKE type_file.num10        #No.FUN-690005 INTEGER
DEFINE l_str          STRING,
       l_k            LIKE type_file.num10,        #No.FUN-690005 INTEGER,
       str_cnt        LIKE type_file.num10,        #No.FUN-690005 INTEGER,
       column_cnt     LIKE type_file.num10,        #No.FUN-690005 INTEGER,
       l_total_len    LIKE type_file.num10,        #No.FUN-690005 INTEGER,
       l_zaa_width    LIKE type_file.num10,        #No.FUN-690005 INTEGER,
       l_len          LIKE type_file.num10,        #No.FUN-690005 INTEGER,
       l_dash1_num    LIKE type_file.num10,        #No.FUN-690005 INTEGER,
       l_replace_msg  STRING,
       l_ze03         LIKE ze_file.ze03,
       l_gay03        LIKE gay_file.gay03,
       l_gay01        LIKE gay_file.gay01,
       l_value_num    STRING,
       l_num          LIKE type_file.num10,        #No.FUN-690005 INTEGER,
       l_mod          LIKE type_file.num10,        #No.FUN-690005 INTEGER,
       l_lang         LIKE type_file.chr1          #No.FUN-690005 VARCHAR(1)
DEFINE l_zaa_sort     DYNAMIC ARRAY WITH DIMENSION 3 OF RECORD
                        zaa02  LIKE zaa_file.zaa02,   #序號
                        zaa05  LIKE zaa_file.zaa05,   #寬度
                        zaa06  LIKE zaa_file.zaa06,   #隱藏否
                        zaa08  LIKE zaa_file.zaa08,   #欄位內容
                        zaa14  LIKE zaa_file.zaa14    #欄位屬性
                      END RECORD
 
DEFINE l_pre_spaces LIKE type_file.num10 #No.FUN-6A0159
 
    FOR l_k = 1 to p_zaa_b.getLength()
        IF p_zaa_b[l_k].zaa15 IS NOT NULL THEN
           IF (p_zaa_b[l_k].zaa03 IS NULL) OR (p_zaa_b[l_k].zaa15 IS NULL) OR
              (p_zaa_b[l_k].zaa07 IS NULL) OR (p_zaa_b[l_k].zaa05 IS NULL) 
           THEN
               CALL cl_err('','azz-122',1) 
               RETURN '',0
           END IF
           #LET a = p_zaa_b[l_k].zaa03 + 1            
           LET a = ORD(p_zaa_b[l_k].zaa03)   #FUN-B50038 
           LET b = p_zaa_b[l_k].zaa15
           LET c = p_zaa_b[l_k].zaa07
           LET l_zaa_sort[a,b,c].zaa02 = p_zaa_b[l_k].zaa02
           LET l_zaa_sort[a,b,c].zaa05 = p_zaa_b[l_k].zaa05
           LET l_zaa_sort[a,b,c].zaa06 = p_zaa_b[l_k].zaa06
           LET l_zaa_sort[a,b,c].zaa08 = p_zaa_b[l_k].zaa08 CLIPPED
           LET l_zaa_sort[a,b,c].zaa14 = p_zaa_b[l_k].zaa14
        END IF
    END FOR
 
    FOR a = 1 TO l_zaa_sort.getLength()
       #TQC-6B0183
       IF l_zaa_sort[a].getLength() = 0 THEN
            CONTINUE FOR
       END IF
       #END TQC-6B0183
       LET l_total_len = 0
       SELECT ze03 INTO l_ze03 FROM ze_file 
          where ze01='azz-121' AND ze02 = g_lang
 
       #LET l_gay01 = a - 1
       LET l_gay01 = ASCII(a)    #FUN-B50038
       LET l_lang = l_gay01
 
       SELECT gay03 INTO l_gay03 FROM gay_file 
          WHERE gay01 = l_gay01 AND gayacti = "Y"  #gay02=g_lang #FUN-830021
 
       LET l_replace_msg =  cl_replace_err_msg(l_ze03, l_gay03 CLIPPED)
       
       LET l_str = l_str , l_replace_msg ,"\n\n"
 
       FOR b = 1 to l_zaa_sort[a].getLength()          #單身抬頭欄位
         LET l_len = 0
         FOR c = 1 to l_zaa_sort[a,b].getLength()
            IF l_zaa_sort[a,b,c].zaa06 = 'N' THEN
               #No.FUN-6A0159 --start--
               IF l_zaa_sort[a,b,c].zaa14 MATCHES '[ABCDEFQ]' THEN
                   LET l_pre_spaces = (l_zaa_sort[a,b,c].zaa05 - FGL_WIDTH(l_zaa_sort[a,b,c].zaa08 CLIPPED)) / 2
                   IF l_pre_spaces > 0 then
                      LET l_zaa_sort[a,b,c].zaa08 = l_pre_spaces SPACES || l_zaa_sort[a,b,c].zaa08 CLIPPED
                   END IF
               END IF
               #No.FUN-6A0159 --end--
               LET str_cnt = FGL_WIDTH(l_zaa_sort[a,b,c].zaa08 CLIPPED)
               IF str_cnt > 0 THEN
                  LET l_str = l_str, l_zaa_sort[a,b,c].zaa08  CLIPPED
               END IF
               LET column_cnt = l_zaa_sort[a,b,c].zaa05 - str_cnt + 1
               FOR l_k = 1 to column_cnt
                  LET l_str = l_str," "
               END FOR
               LET l_len = l_len + l_zaa_sort[a,b,c].zaa05 + 1
            END IF
         END FOR
         LET l_len = l_len - 1
         IF (l_total_len <= l_len) THEN
            LET l_total_len = l_len
            LET l_dash1_num = b 
            IF l_lang = g_lang THEN
                  LET l_zaa_width = l_total_len
            END IF 
         END IF
         LET l_str = l_str ,"\n"
       END FOR
 
       FOR c = 1 to l_zaa_sort[a,l_dash1_num].getLength()   #列印g_dash1
          IF l_zaa_sort[a,l_dash1_num,c].zaa06 = 'N' THEN
             FOR l_k = 1 to l_zaa_sort[a,l_dash1_num,c].zaa05
                LET l_str = l_str,"-"
             END FOR
             LET l_str = l_str," "
          END IF
       END FOR
       LET l_str = l_str ,"\n"
 
       FOR b = 1 to l_zaa_sort[a].getLength()          #單身欄位
         FOR c = 1 to l_zaa_sort[a,b].getLength()
            IF l_zaa_sort[a,b,c].zaa06 = 'N' THEN
               CASE
                 WHEN l_zaa_sort[a,b,c].zaa14 MATCHES "[ABD]" 
                     LET l_value_num = ""
                     LET l_num = l_zaa_sort[a,b,c].zaa05 / 4
                     LET l_mod = l_zaa_sort[a,b,c].zaa05 MOD 4
                     FOR l_k = 1 TO l_num
                          IF l_mod = 0 AND l_k = l_num THEN
                               LET l_value_num = "9999",l_value_num
                          ELSE
                               LET l_value_num = ",999",l_value_num
                          END IF
                     END FOR
                     FOR l_k = 1 TO l_mod
                               LET l_value_num = "9",l_value_num
                     END FOR
                     LET l_str = l_str, l_value_num
 
                 WHEN l_zaa_sort[a,b,c].zaa14 MATCHES "[CEF]" 
                     FOR l_k = 1 TO l_zaa_sort[a,b,c].zaa05 
                        LET l_str = l_str, "9"
                     END FOR
 
                 WHEN l_zaa_sort[a,b,c].zaa14 MATCHES "[Q]" 
                     LET l_str = l_str,"xx/xx/xx"
                     FOR l_k = 1 TO l_zaa_sort[a,b,c].zaa05-8 
                        LET l_str = l_str, " "
                     END FOR
                 
                 
                 OTHERWISE
                     FOR l_k = 1 TO l_zaa_sort[a,b,c].zaa05 
                        LET l_str = l_str, "x"
                     END FOR
               END CASE
               LET l_str = l_str," "
            END IF
         END FOR
         LET l_str = l_str ,"\n"
       END FOR
       LET l_str = l_str,"\n"
    END FOR
    RETURN l_str,l_zaa_width
 
END FUNCTION
