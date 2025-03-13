# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Program name...: salmt559_sub.4gl
# Description....: 会员升等
# Date & Author..: No.FUN-D10059 13/01/15 By dongsz (FUN-D10059)

DATABASE ds

GLOBALS "../../config/top.global"

FUNCTION t559sub_lqt03_uplevel(l_lpk01,l_lpk10,sum_lpj15,sum_lpj14,sum_lpj07,l_flag,l_wc,l_shop)
DEFINE l_lqq01_t       LIKE lqq_file.lqq01,
       l_lpk01         LIKE lpk_file.lpk01,
       l_lpk10         LIKE lpk_file.lpk10,
       sum_lpj07       LIKE lpj_file.lpj07,
       sum_lpj14       LIKE lpj_file.lpj14,
       sum_lpj15       LIKE lpj_file.lpj15,
       l_n             LIKE type_file.num10,
       l_sql           STRING,
       l_wc            STRING
DEFINE l_arr           DYNAMIC ARRAY OF RECORD
       lqq01           LIKE lqq_file.lqq01,
       lqq02           LIKE lqq_file.lqq02,
       lqq03           LIKE lqq_file.lqq03,
       lqq04           LIKE lqq_file.lqq04,
       lqq05           LIKE lqq_file.lqq05,
       lqq06           LIKE lqq_file.lqq06
                       END RECORD
DEFINE l_flag          LIKE type_file.chr1 #记录前置条件满足否
DEFINE l_flag_ord      LIKE type_file.chr1 #记录是否为第一笔(同一等级编号)
DEFINE l_shop          LIKE azw_file.azw01


   LET l_sql = "SELECT lqq01,lqq02,lqq03,lqq04,lqq05,lqq06 ",
               "  FROM ",cl_get_target_table(l_shop,"lpc_file"), 
               " INNER JOIN ",cl_get_target_table(l_shop,"lqq_file")," ON lpc01 = lqq01 ",
               " WHERE lpc00 = '6' AND lpcacti = 'Y' AND ",l_wc CLIPPED,
               " ORDER BY lqq01,lqq06 "
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
   CALL cl_parse_qry_sql(l_sql,l_shop) RETURNING l_sql

   PREPARE p559_lqt03pre FROM　l_sql
   DECLARE p559_lqt03cl CURSOR FOR p559_lqt03pre
   LET l_n = 1
   LET l_flag = 'N'
   LET l_lqq01_t = ' '
   FOREACH p559_lqt03cl INTO l_arr[l_n].*
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('','','prepare FOREACH',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF

      IF l_arr[l_n].lqq01 <> l_lpk10 OR cl_null(l_lpk10) THEN #如果抓取的等級與當前等級相同則不比較
         IF l_lqq01_t <> l_arr[l_n].lqq01 THEN #同一个等级的每一个条件都判断后，通过l_flag判断是否能够升级
            IF l_flag = 'Y' THEN
               EXIT FOREACH
            END IF
            LET l_lqq01_t = l_arr[l_n].lqq01
            LET l_flag = 'Y'
            LET l_flag_ord = '1' #当前为该等级编号的第一笔
         ELSE
            LET l_flag_ord = '2' #当前为该等级编号的非第一笔
         END IF
         CASE
            WHEN l_arr[l_n].lqq02 = '1'  #判斷累積積分
               IF (l_flag = 'Y' AND l_arr[l_n].lqq03 = 'AND') OR (l_flag = 'N' AND l_arr[l_n].lqq03 = 'OR') OR l_flag_ord = '1' THEN 
                   IF sum_lpj14 >= l_arr[l_n].lqq04 AND sum_lpj14 <= l_arr[l_n].lqq05 THEN 
                     LET l_flag = 'Y'
                   ELSE
                     LET l_flag = 'N'
                   END IF
                END IF
            WHEN l_arr[l_n].lqq02 = '2' #判斷累計金額
               IF (l_flag = 'Y' AND l_arr[l_n].lqq03 = 'AND') OR (l_flag = 'N' AND l_arr[l_n].lqq03 = 'OR') OR l_flag_ord = '1' THEN 
                  IF sum_lpj15 >= l_arr[l_n].lqq04 AND sum_lpj15 <= l_arr[l_n].lqq05 THEN 
                     LET l_flag = 'Y'
                  ELSE
                     LET l_flag = 'N'
                  END IF
               END IF
            WHEN l_arr[l_n].lqq02 = '3' #判斷累計消費次數
               IF (l_flag = 'Y' AND l_arr[l_n].lqq03 = 'AND') OR (l_flag = 'N' AND l_arr[l_n].lqq03 = 'OR') OR l_flag_ord = '1' THEN 
                  IF sum_lpj07 >= l_arr[l_n].lqq04 AND sum_lpj07 <= l_arr[l_n].lqq05 THEN 
                     LET l_flag = 'Y'
                  ELSE
                     LET l_flag = 'N'
                  END IF
               END IF
            OTHERWISE  LET l_flag = 'N'
         END CASE
      END IF
      LET l_n = l_n + 1
   END FOREACH
   RETURN l_flag,l_n,l_lqq01_t

END FUNCTION 

#FUN-D10059
