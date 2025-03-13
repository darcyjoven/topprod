# Prog. Version..: '5.30.06-13.04.22(00001)'     #
# Pattern name...: s_chk_scan_qty.4gl
# Descriptions...: 掃描單據數量檢查並自動確認/過帳副程式
# Date & Author..: No:DEV-D30046 13/04/02 By TSD.sophy
# Usage..........: CALL s_chk_scan_qty(p_no,p_prog,p_post_flag)
# Input Parameter: p_no         單據編號
#                  p_prog       程式代號 (傳入要使用確認/過帳段的程式代號)
#                  p_post_flag  是否執行確認/過帳 (Y/N)
# Return Code....: TRUE/FALSE
#                  TRUE         成功
#                  FALSE        失敗
# Modify.........: No.DEV-D30046 13/04/19 By TSD.JIE


DATABASE ds

GLOBALS "../../config/top.global"
GLOBALS "../../aba/4gl/barcode.global"

FUNCTION s_chk_scan_qty(p_no,p_prog,p_post_flag)
DEFINE p_no         LIKE type_file.chr20
DEFINE p_prog       LIKE type_file.chr20
DEFINE p_post_flag  LIKE type_file.chr1
DEFINE l_flag       LIKE type_file.num5
DEFINE l_prog_t     LIKE type_file.chr20

   LET l_prog_t = g_prog
   LET g_prog = p_prog
   
   CASE p_prog
      WHEN "apmt110"   #收貨
         CALL s_chk_scan_qty_apmt110(p_no,p_post_flag)
            RETURNING l_flag
      WHEN "asfi511"   #發料
         CALL s_chk_scan_qty_asfi511(p_no,p_post_flag)
            RETURNING l_flag
      WHEN "asfi520"   #退料
         CALL s_chk_scan_qty_asfi526(p_no,p_post_flag)
            RETURNING l_flag
      WHEN "asft620"   #完工入庫
         CALL s_chk_scan_qty_asft620(p_no,p_post_flag)
            RETURNING l_flag
      WHEN "axmt610"   #出通
         CALL s_chk_scan_qty_axmt610(p_no,p_post_flag)
            RETURNING l_flag
      WHEN "axmt620"   #出貨
         CALL s_chk_scan_qty_axmt620(p_no,p_post_flag)
            RETURNING l_flag
      WHEN "axmt700"   #銷退
         CALL s_chk_scan_qty_axmt700(p_no,p_post_flag)
            RETURNING l_flag
      WHEN "aimt302"   #雜收
         CALL s_chk_scan_qty_aimt302(p_no,p_post_flag)
            RETURNING l_flag
      WHEN "aimt301"   #雜發
         CALL s_chk_scan_qty_aimt301(p_no,p_post_flag)
            RETURNING l_flag
      WHEN "aimt324"   #倉庫直接調撥
         CALL s_chk_scan_qty_aimt324(p_no,p_post_flag)
            RETURNING l_flag
      WHEN "aimt325"   #倉庫兩階段調撥-撥出
         CALL s_chk_scan_qty_aimt325(p_no,p_post_flag)
            RETURNING l_flag
      WHEN "aimt326"   #倉庫兩階段調撥-撥入
         CALL s_chk_scan_qty_aimt326(p_no,p_post_flag)
            RETURNING l_flag
      WHEN "apmt720"   #採購入庫
         CALL s_chk_scan_qty_apmt720(p_no,p_post_flag)
            RETURNING l_flag
   END CASE 

   LET g_prog = l_prog_t
   
   IF l_flag THEN 
      RETURN TRUE 
   ELSE
      RETURN FALSE 
   END IF 
END FUNCTION 

#收貨
FUNCTION s_chk_scan_qty_apmt110(p_no,p_post_flag)
DEFINE p_no         LIKE type_file.chr20
DEFINE p_post_flag  LIKE type_file.chr1
DEFINE l_cnt        LIKE type_file.num5
DEFINE l_sql        STRING 
DEFINE l_ln         LIKE type_file.num5
DEFINE l_scan_qty   LIKE tlfb_file.tlfb05   #掃描數量
DEFINE l_no_qty     LIKE rvb_file.rvb07     #單據數量
DEFINE l_rva10      LIKE rva_file.rva10
DEFINE l_rva00      LIKE rva_file.rva00
DEFINE l_rva        RECORD LIKE rva_file.*


   #檢查傳入單據p_no的單身料號是否全數為條碼料號(ima930='Y')，
   #若有單身料號使用條碼否為'N'，
   #則跳窗顯示錯誤訊息「含非條碼料件，請由ERP進行確認」，
   #回傳FALSE。

   LET l_cnt = 0 
   SELECT COUNT(*) INTO l_cnt FROM ima_file,rvb_file 
    WHERE ima01 = rvb05 
      AND (ima930 = 'N' OR ima930 IS NULL)
      AND rvb01 = p_no
   IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF 
   IF l_cnt > 0 THEN 
      CALL cl_err('','aba-183',1)  #含非條碼料件，請由ERP進行確認
      RETURN FALSE
   END IF 

   #檢查掃描數量是否足量
   LET l_sql = "SELECT rvb02,rvb07,rva10,rva00 ",
               "  FROM rvb_file,rva_file ",
               " WHERE rva01 = rvb01 ",
               "   AND rvb01 = '",p_no,"'"
   DECLARE rvb_cs CURSOR FROM l_sql
   
   LET l_sql = "SELECT SUM(ibj05) FROM ibj_file ",
               " WHERE ibj01 = '1' ",
               "   AND ibj06 = ? AND ibj07 = ? "
   PREPARE ibj_prep FROM l_sql
    
   LET l_rva10 = NULL
   LET l_rva00 = NULL
   LET l_ln = NULL
   LET l_no_qty = 0
   
   FOREACH rvb_cs INTO l_ln,l_no_qty,l_rva10,l_rva00
      IF SQLCA.SQLCODE THEN 
         CALL cl_err('foreach rvb_cs:',SQLCA.SQLCODE,1)
         EXIT FOREACH
      END IF 
   
      IF cl_null(l_no_qty) THEN LET l_no_qty = 0 END IF 
      
      LET l_scan_qty = 0 
      EXECUTE ibj_prep USING p_no,l_ln INTO l_scan_qty
      IF cl_null(l_scan_qty) THEN LET l_scan_qty = 0 END IF 

      IF l_scan_qty <> l_no_qty THEN 
         CALL cl_err('','aba-184',1)  #條碼數量與原單據不符，請由ERP進行確認
         RETURN FALSE
      END IF 
      
   END FOREACH 

   IF p_post_flag = 'Y' THEN 
      CALL t110sub_y_chk(p_no,FALSE,'Y',' ',l_rva10,'1',l_rva00)
      IF g_success = "Y" THEN
         CALL t110sub_y_upd(p_no,FALSE,'Y',' ',l_rva10,'1',l_rva00)
      END IF
      INITIALIZE l_rva.* TO NULL
      SELECT * INTO l_rva.* FROM rva_file WHERE rva01 = p_no
      IF l_rva.rvaconf = 'Y' THEN 
         CALL cl_err('','wmb-017',1)  #單據確認成功 
         RETURN TRUE
      ELSE 
         CALL cl_err('','wmb-016',1)
         RETURN FALSE
      END IF 
   ELSE
      RETURN TRUE
   END IF
   
   RETURN FALSE
END FUNCTION 

#發料
FUNCTION s_chk_scan_qty_asfi511(p_no,p_post_flag)
DEFINE p_no         LIKE type_file.chr20
DEFINE p_post_flag  LIKE type_file.chr1
DEFINE l_cnt        LIKE type_file.num5
DEFINE l_sql        STRING 
DEFINE l_forupd_sql STRING
DEFINE l_n          LIKE type_file.num5
DEFINE l_tlfb       RECORD
          ibb06        LIKE ibb_file.ibb06,
          tlfb02       LIKE tlfb_file.tlfb02,
          tlfb03       LIKE tlfb_file.tlfb03,
          tlfb05_tot   LIKE type_file.num20_6
                    END RECORD
DEFINE l_sfs        RECORD
          sfs04        LIKE sfs_file.sfs04,
          sfs07        LIKE sfs_file.sfs07,
          sfs08        LIKE sfs_file.sfs08,
          sfs05_tot    LIKE type_file.num20_6
                    END RECORD
DEFINE l_sfs1       RECORD LIKE sfs_file.*
DEFINE l_sfs05_tot  LIKE type_file.num20_6
DEFINE l_tlfb05_tot LIKE type_file.num20_6
DEFINE l_sts1       LIKE type_file.chr1
DEFINE l_sts2       LIKE type_file.chr1
DEFINE l_sts3       LIKE type_file.chr1
DEFINE l_sfp        RECORD LIKE sfp_file.*
#DEV-D30046--add--begin
DEFINE l_ln         LIKE type_file.num5
DEFINE l_scan_qty   LIKE tlfb_file.tlfb05   #掃描數量
DEFINE l_no_qty     LIKE sfs_file.sfs05     #單據數量
#DEV-D30046--add--end


   #檢查傳入單據p_no的單身料號是否全數為條碼料號(ima930='Y')，
   #若有單身料號使用條碼否為'N'，
   #則跳窗顯示錯誤訊息「含非條碼料件，請由ERP進行確認」，
   #回傳FALSE。

   LET l_cnt = 0 
   SELECT COUNT(*) INTO l_cnt FROM ima_file,sfs_file 
    WHERE ima01 = sfs04 
      AND (ima930 = 'N' OR ima930 IS NULL)
      AND sfs01 = p_no
   IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF 
   IF l_cnt > 0 THEN 
      CALL cl_err('','aba-201',1)  #含非條碼料件，請由ERP進行過帳
      RETURN FALSE
   END IF 

   #DEV-D30046--add--begin
   #檢查掃描數量是否足量
   LET l_sql = "SELECT sfs02,sfs05 ",
               "  FROM sfs_file,sfp_file ",
               " WHERE sfp01 = sfs01 ",
               "   AND sfs01 = '",p_no,"'"
   DECLARE sfs_cs3 CURSOR FROM l_sql
   
   LET l_sql = "SELECT SUM(tlfb05) FROM tlfb_file ",
               " WHERE tlfb07 = '",p_no,"' ",
               "   AND tlfb08 = ? "
   PREPARE tlfb_prep11 FROM l_sql
    
   LET l_ln = NULL
   LET l_no_qty = 0
   
   FOREACH sfs_cs3 INTO l_ln,l_no_qty
      IF SQLCA.SQLCODE THEN 
         CALL cl_err('foreach sfs_cs3:',SQLCA.SQLCODE,1)
         EXIT FOREACH
      END IF 
   
      IF cl_null(l_no_qty) THEN LET l_no_qty = 0 END IF 
      
      LET l_scan_qty = 0 
      EXECUTE tlfb_prep11 USING l_ln INTO l_scan_qty
      IF cl_null(l_scan_qty) THEN LET l_scan_qty = 0 END IF 

      IF l_scan_qty <> l_no_qty THEN 
         CALL cl_err('','aba-184',1)  #條碼數量與原單據不符，請由ERP進行確認
         RETURN FALSE
      END IF 
      
   END FOREACH 
   #DEV-D30046--add--end

   #計算掃描數量SQL(BY發料單)
   LET l_sql = "SELECT ibb06,tlfb02,tlfb03,SUM(tlfb05) tlfb05_tot",
               "  FROM (SELECT m.tlfb07,d.ibb06,m.tlfb02,m.tlfb03, (m.tlfb06*m.tlfb05)*(-1) tlfb05",  #發料單號,料號,倉庫,儲位,總(掃描條碼量)
               "          FROM tlfb_file m",
               "         INNER JOIN (SELECT DISTINCT ibb01, ibb06",
               "                       FROM ibb_file ) d ON m.tlfb01 = d.ibb01)",
               " WHERE tlfb07 = '",p_no,"'",
               " GROUP BY ibb06,tlfb02,tlfb03",
               " ORDER BY ibb06,tlfb02,tlfb03"
   PREPARE tlfb_tot_prep FROM l_sql
   DECLARE tlfb_cs CURSOR WITH HOLD FOR tlfb_tot_prep

   #計算ERP發料數量SQL
   LET l_sql = "SELECT sfs04,sfs07,sfs08,SUM(sfs05) sfs05_tot",  #工單單號,料號,倉庫,儲位,總(發料量)
               "  FROM sfs_file",
               " WHERE sfs01 = '",p_no,"'",
               "   AND sfs04 = ? ",
               " GROUP BY sfs04,sfs07,sfs08",
               " ORDER BY sfs04,sfs07,sfs08"
   PREPARE sfs_prep FROM l_sql
   DECLARE sfs_cs CURSOR WITH HOLD FOR sfs_prep

   #料號掃描數量需回寫發料單發料量(sfs05)
   LET l_forupd_sql = "SELECT * FROM sfs_file",
                      " WHERE sfs01 = ? ",
                      "   AND sfs04 = ? ",
                      "   AND sfs07 = ? ",
                      "   AND sfs08 = ? FOR UPDATE"
   LET l_forupd_sql = cl_forupd_sql(l_forupd_sql)
   DECLARE sfs_cl CURSOR FROM l_forupd_sql

   LET g_success = 'Y'
   BEGIN WORK

   FOREACH tlfb_cs INTO l_tlfb.*
      IF SQLCA.SQLCODE THEN
         LET g_success = 'N'
         CALL cl_err('foreach tlfb_cs:',SQLCA.SQLCODE,1)
         EXIT FOREACH
      END IF
      
      LET l_sts1 = 'N'
      LET l_sts2 = 'N'
      LET l_sts3 = 'N'

      FOREACH sfs_cs USING l_tlfb.ibb06 INTO l_sfs.*
         IF SQLCA.SQLCODE THEN
            LET g_success = 'N'
            CALL cl_err('foreach sfs_cs:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
          
         #計算該發料單BY(料號+倉庫+儲位)筆數
         LET l_n = 0
         SELECT COUNT(DISTINCT(sfs03)) INTO l_n
           FROM tlfb_file
          INNER JOIN sfs_file ON tlfb_file.tlfb07 = sfs_file.sfs01
          WHERE sfs01 = p_no
            AND sfs04 = l_sfs.sfs04
            AND sfs07 = l_sfs.sfs07
            AND sfs08 = l_sfs.sfs08

         IF (l_tlfb.tlfb05_tot = l_sfs.sfs05_tot) AND l_n = 1 THEN
            LET l_sts1 = 'Y'
         END IF
         IF (l_tlfb.tlfb05_tot < l_sfs.sfs05_tot) THEN
            LET l_sts2 = 'Y'
            IF l_n = 1 THEN
               #料號掃描數量需回寫發料單發料量(sfs05)
               OPEN sfs_cl USING p_no,l_tlfb.ibb06,l_tlfb.tlfb02,l_tlfb.tlfb03
               IF STATUS THEN
                  LET g_success = 'N'
                  CALL cl_err("OPEN sfs_cl:", STATUS, 1)
                  CLOSE sfs_cl
                  ROLLBACK WORK
                  EXIT FOREACH
               END IF
               FETCH sfs_cl INTO l_sfs1.*             # 鎖住將被更改或取消的資料
               IF SQLCA.SQLCODE THEN
                  LET g_success = 'N'
                  CALL cl_err("FETCH sfs_cl:", STATUS, 1)
                  CLOSE sfs_cl
                  ROLLBACK WORK
                  EXIT FOREACH
               END IF
               UPDATE sfs_file SET sfs05 = l_tlfb.tlfb05_tot
                WHERE sfs01 = p_no
                  AND sfs04 = l_tlfb.ibb06
                  AND sfs07 = l_tlfb.tlfb02
                  AND sfs08 = l_tlfb.tlfb03
               IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
                  LET g_success = 'N'
                  CALL cl_err(l_tlfb.ibb06,'aba-160',1)  #料號掃描數量回至寫發料單發料量(sfs05)
                  EXIT FOREACH
               END IF
            ELSE
               LET l_sts3 = 'Y'
               
               #本次掃描記錄(PK: tlfb15)寫入ibj_file
               LET g_ibj.ibj01 = '2'
               LET g_ibj.ibj02 = l_tlfb.ibb06
               LET g_ibj.ibj03 = l_tlfb.tlfb02
               LET g_ibj.ibj04 = l_tlfb.tlfb03
               LET g_ibj.ibj05 = l_tlfb.tlfb05_tot
               LET g_ibj.ibj06 = p_no
               LET g_ibj.ibj10 = 'N'
               LET g_ibj.ibj11 = g_prog
               LET g_ibj.ibj12 = FGL_GETPID()
               LET g_ibj.ibj13 = g_user
               LET g_ibj.ibj14 = TODAY
               LET g_ibj.ibj15 = TIME
               LET g_ibj.ibj16 = cl_used_ap_hostname()

               CALL s_insibj('','','','','')
               IF g_success = 'N' THEN
                  CALL cl_err(l_tlfb.ibb06,'aba-141',1)  #欠料資訊寫入失敗!
                  EXIT FOREACH
               END IF
            END IF
         END IF
      END FOREACH
      IF g_success = 'N' THEN
         EXIT FOREACH
      END IF
   END FOREACH
   
   CLOSE sfs_cl
   IF g_success = 'Y' THEN
      COMMIT WORK
      IF l_sts1 = 'Y' THEN
         IF p_post_flag = 'Y' THEN 
            CALL i501sub_s('1',p_no,FALSE,'N')
            INITIALIZE l_sfp.* TO NULL
            SELECT * INTO l_sfp.* FROM sfp_file WHERE sfp01 = p_no
            IF l_sfp.sfp04 = 'Y' THEN 
               CALL cl_err('','aba-159',1)  #該發料單號過帳成功!!
               RETURN TRUE
            ELSE  
               CALL cl_err('','wmb-020',1)
               RETURN FALSE 
            END IF 
         ELSE  
            RETURN TRUE
         END IF 
      END IF
      IF l_sts2 = 'Y' THEN
         IF l_n = 1 THEN
            CALL cl_err(l_tlfb.ibb06,'aba-138',1)  #欠料，請由ERP進行過帳
            CALL cl_err(l_tlfb.ibb06,'aba-161',1)  #料號掃描數量回至寫發料單發料量(sfs05)成功!
            RETURN FALSE 
         END IF
      END IF
      IF l_sts3 = 'Y' THEN
         CALL cl_err(l_tlfb.ibb06,'aba-139',1)  #欠料，請聯繫ERP進行發料量分配作業
         CALL cl_err(l_tlfb.ibb06,'aba-140',1)  #欠料資訊寫入成功!
         RETURN FALSE 
      END IF
   ELSE
      ROLLBACK WORK
      RETURN FALSE 
   END IF
   
   RETURN FALSE
END FUNCTION 

#退料
FUNCTION s_chk_scan_qty_asfi526(p_no,p_post_flag)
DEFINE p_no         LIKE type_file.chr20
DEFINE p_post_flag  LIKE type_file.chr1
DEFINE l_cnt        LIKE type_file.num5
DEFINE l_sql        STRING 
DEFINE l_ln         LIKE type_file.num5
DEFINE l_scan_qty   LIKE tlfb_file.tlfb05   #掃描數量
DEFINE l_no_qty     LIKE sfs_file.sfs05     #單據數量
DEFINE l_sfp        RECORD LIKE sfp_file.*

   #檢查傳入單據p_no的單身料號是否全數為條碼料號(ima930='Y')，
   #若有單身料號使用條碼否為'N'，
   #則跳窗顯示錯誤訊息「含非條碼料件，請由ERP進行確認」，
   #回傳FALSE。

   LET l_cnt = 0 
   SELECT COUNT(*) INTO l_cnt FROM ima_file,sfs_file 
    WHERE ima01 = sfs04 
      AND (ima930 = 'N' OR ima930 IS NULL)
      AND sfs01 = p_no
   IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF 
   IF l_cnt > 0 THEN 
      CALL cl_err('','aba-201',1)  #含非條碼料件，請由ERP進行過帳
      RETURN FALSE
   END IF 

   
   #檢查掃描數量是否足量
   LET l_sql = "SELECT sfs02,sfs05 FROM sfs_file", 
               " WHERE sfs01 = '",p_no,"'"
   DECLARE sfs_cs2 CURSOR FROM l_sql
   
   LET l_sql = "SELECT SUM(tlfb05*tlfb06) FROM tlfb_file ",
               " WHERE tlfb07 = ? AND tlfb08 = ? "
   PREPARE tlfb_prep FROM l_sql
    
   LET l_ln = NULL
   LET l_no_qty = 0
   
   FOREACH sfs_cs2 INTO l_ln,l_no_qty
      IF SQLCA.SQLCODE THEN 
         CALL cl_err('foreach sfs_cs2:',SQLCA.SQLCODE,1)
         EXIT FOREACH
      END IF 
   
      IF cl_null(l_no_qty) THEN LET l_no_qty = 0 END IF 
      
      LET l_scan_qty = 0 
      EXECUTE tlfb_prep USING p_no,l_ln INTO l_scan_qty
      IF cl_null(l_scan_qty) THEN LET l_scan_qty = 0 END IF 

      IF l_scan_qty <> l_no_qty THEN 
         CALL cl_err('','aba-202',1)  #條碼數量與原單據不符，請由ERP進行過帳
         RETURN FALSE
      END IF 
      
   END FOREACH 

   IF p_post_flag = 'Y' THEN 
      CALL i501sub_s('1',p_no,FALSE,'N')
      INITIALIZE l_sfp.* TO NULL
      SELECT * INTO l_sfp.* FROM sfp_file WHERE sfp01 = p_no
      IF l_sfp.sfp04 = 'Y' THEN 
         CALL cl_err('','wmb-019',1)  #單據過帳成功
         RETURN TRUE
      ELSE 
         CALL cl_err('','wmb-020',1)
         RETURN FALSE
      END IF 
   ELSE
      RETURN TRUE
   END IF
   
   RETURN FALSE
END FUNCTION 

#完工入庫
FUNCTION s_chk_scan_qty_asft620(p_no,p_post_flag)
DEFINE p_no         LIKE type_file.chr20
DEFINE p_post_flag  LIKE type_file.chr1
DEFINE l_cnt        LIKE type_file.num5
DEFINE l_sql        STRING 
DEFINE l_ln         LIKE type_file.num5
DEFINE l_scan_qty   LIKE tlfb_file.tlfb05   #掃描數量
DEFINE l_no_qty     LIKE sfv_file.sfv09     #單據數量
DEFINE l_sfu        RECORD LIKE sfu_file.*

   #檢查傳入單據p_no的單身料號是否全數為條碼料號(ima930='Y')，
   #若有單身料號使用條碼否為'N'，
   #則跳窗顯示錯誤訊息「含非條碼料件，請由ERP進行確認」，
   #回傳FALSE。

   LET l_cnt = 0 
   SELECT COUNT(*) INTO l_cnt FROM ima_file,sfv_file 
    WHERE ima01 = sfv04 
      AND (ima930 = 'N' OR ima930 IS NULL)
      AND sfv01 = p_no
   IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF 
   IF l_cnt > 0 THEN 
      CALL cl_err('','aba-201',1)  #含非條碼料件，請由ERP進行過帳
      RETURN FALSE
   END IF 

   
   #檢查掃描數量是否足量
   LET l_sql = "SELECT sfv03,sfv09 FROM sfv_file", 
               " WHERE sfv01 = '",p_no,"'"
   DECLARE sfv_cs CURSOR FROM l_sql
   
   LET l_sql = "SELECT SUM(tlfb05*tlfb06) FROM tlfb_file ",
               " WHERE tlfb07 = ? AND tlfb08 = ? "
   PREPARE tlfb_prep2 FROM l_sql
    
   LET l_ln = NULL
   LET l_no_qty = 0
   
   FOREACH sfv_cs INTO l_ln,l_no_qty
      IF SQLCA.SQLCODE THEN 
         CALL cl_err('foreach sfv_cs:',SQLCA.SQLCODE,1)
         EXIT FOREACH
      END IF 
   
      IF cl_null(l_no_qty) THEN LET l_no_qty = 0 END IF 
      
      LET l_scan_qty = 0 
      EXECUTE tlfb_prep2 USING p_no,l_ln INTO l_scan_qty
      IF cl_null(l_scan_qty) THEN LET l_scan_qty = 0 END IF 

      IF l_scan_qty <> l_no_qty THEN 
         CALL cl_err('','aba-202',1)  #條碼數量與原單據不符，請由ERP進行過帳
         RETURN FALSE
      END IF 
      
   END FOREACH 

   IF p_post_flag = 'Y' THEN 
      CALL t620sub_s(p_no,'1',FALSE,"stock_post")
      INITIALIZE l_sfu.* TO NULL
      SELECT * INTO l_sfu.* FROM sfu_file WHERE sfu01 = p_no
      IF l_sfu.sfupost = 'Y' THEN 
         CALL cl_err('','wmb-019',1)  #單據過帳成功
         RETURN TRUE
      ELSE 
         CALL cl_err('','wmb-020',1)
         RETURN FALSE
      END IF 
   ELSE
      RETURN TRUE
   END IF
   
   RETURN FALSE
END FUNCTION 

#出通
FUNCTION s_chk_scan_qty_axmt610(p_no,p_post_flag)
DEFINE p_no         LIKE type_file.chr20
DEFINE p_post_flag  LIKE type_file.chr1
DEFINE l_cnt        LIKE type_file.num5
DEFINE l_sql        STRING 
DEFINE l_ln         LIKE type_file.num5
DEFINE l_scan_qty   LIKE tlfb_file.tlfb05   #掃描數量
DEFINE l_no_qty     LIKE ogb_file.ogb12     #單據數量
DEFINE l_oga        RECORD LIKE oga_file.*


   #檢查傳入單據p_no的單身料號是否全數為條碼料號(ima930='Y')，
   #若有單身料號使用條碼否為'N'，
   #則跳窗顯示錯誤訊息「含非條碼料件，請由ERP進行確認」，
   #回傳FALSE。

   LET l_cnt = 0 
   SELECT COUNT(*) INTO l_cnt FROM ima_file,ogb_file 
    WHERE ima01 = ogb04 
      AND (ima930 = 'N' OR ima930 IS NULL)
      AND ogb01 = p_no
   IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF 
   IF l_cnt > 0 THEN 
      CALL cl_err('','aba-183',1)  #含非條碼料件，請由ERP進行確認
      RETURN FALSE
   END IF 

   #檢查掃描數量是否足量
   LET l_sql = "SELECT ogb03,ogb12 ",
               "  FROM ogb_file ",
               " WHERE ogb01 = '",p_no,"'"
   DECLARE ogb_cs CURSOR FROM l_sql
   
   LET l_sql = "SELECT SUM(ibj05) FROM ibj_file ",
               " WHERE ibj01 = '3' ",
               "   AND ibj06 = ? AND ibj07 = ? "
   PREPARE ibj_prep2 FROM l_sql
    
   LET l_ln = NULL
   LET l_no_qty = 0
   
   FOREACH ogb_cs INTO l_ln,l_no_qty
      IF SQLCA.SQLCODE THEN 
         CALL cl_err('foreach ogb_cs:',SQLCA.SQLCODE,1)
         EXIT FOREACH
      END IF 
   
      IF cl_null(l_no_qty) THEN LET l_no_qty = 0 END IF 
      
      LET l_scan_qty = 0 
      EXECUTE ibj_prep2 USING p_no,l_ln INTO l_scan_qty
      IF cl_null(l_scan_qty) THEN LET l_scan_qty = 0 END IF 

      IF l_scan_qty <> l_no_qty THEN 
         CALL cl_err('','aba-202',1)  #條碼數量與原單據不符，請由ERP進行過帳
         RETURN FALSE
      END IF 
      
   END FOREACH 

   IF p_post_flag = 'Y' THEN 
      CALL t600sub_y_chk(p_no,"confirm")
      IF g_success = 'Y' THEN 
         CALL t600sub_y_upd(p_no,"confirm") 
      END IF 
      INITIALIZE l_oga.* TO NULL
      SELECT * INTO l_oga.* FROM oga_file WHERE oga01 = p_no
      IF l_oga.ogaconf = 'Y' THEN 
         CALL cl_err('','wmb-017',1)  #單據確認成功 
         RETURN TRUE
      ELSE 
         CALL cl_err('','wmb-016',1)
         RETURN FALSE
      END IF 
   ELSE
      RETURN TRUE
   END IF
   
   RETURN FALSE
END FUNCTION 

#出貨
FUNCTION s_chk_scan_qty_axmt620(p_no,p_post_flag)
DEFINE p_no         LIKE type_file.chr20
DEFINE p_post_flag  LIKE type_file.chr1
DEFINE l_cnt        LIKE type_file.num5
DEFINE l_sql        STRING 
DEFINE l_ln         LIKE type_file.num5
DEFINE l_scan_qty   LIKE tlfb_file.tlfb05   #掃描數量
DEFINE l_no_qty     LIKE ogb_file.ogb12     #單據數量
DEFINE l_oga        RECORD LIKE oga_file.*

   #檢查傳入單據p_no的單身料號是否全數為條碼料號(ima930='Y')，
   #若有單身料號使用條碼否為'N'，
   #則跳窗顯示錯誤訊息「含非條碼料件，請由ERP進行確認」，
   #回傳FALSE。

   LET l_cnt = 0 
   SELECT COUNT(*) INTO l_cnt FROM ima_file,ogb_file 
    WHERE ima01 = ogb04 
      AND (ima930 = 'N' OR ima930 IS NULL)
      AND ogb01 = p_no
   IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF 
   IF l_cnt > 0 THEN 
      CALL cl_err('','aba-201',1)  #含非條碼料件，請由ERP進行過帳
      RETURN FALSE
   END IF 

   
   #檢查掃描數量是否足量
   LET l_sql = "SELECT ogb03,ogb12 FROM ogb_file", 
               " WHERE ogb01 = '",p_no,"'"
   DECLARE ogb_cs2 CURSOR FROM l_sql
   
   LET l_sql = "SELECT SUM(tlfb05*tlfb06)*(-1) FROM tlfb_file ",
               " WHERE tlfb07 = ? AND tlfb08 = ? "
   PREPARE tlfb_prep3 FROM l_sql
    
   LET l_ln = NULL
   LET l_no_qty = 0
   
   FOREACH ogb_cs2 INTO l_ln,l_no_qty
      IF SQLCA.SQLCODE THEN 
         CALL cl_err('foreach ogb_cs2:',SQLCA.SQLCODE,1)
         EXIT FOREACH
      END IF 
   
      IF cl_null(l_no_qty) THEN LET l_no_qty = 0 END IF 
      
      LET l_scan_qty = 0 
      EXECUTE tlfb_prep3 USING p_no,l_ln INTO l_scan_qty
      IF cl_null(l_scan_qty) THEN LET l_scan_qty = 0 END IF 

      IF l_scan_qty <> l_no_qty THEN 
         CALL cl_err('','aba-202',1)  #條碼數量與原單據不符，請由ERP進行過帳
         RETURN FALSE
      END IF 
      
   END FOREACH 

   IF p_post_flag = 'Y' THEN 
      CALL t600sub_s('2',FALSE,p_no,FALSE)
      INITIALIZE l_oga.* TO NULL
      SELECT * INTO l_oga.* FROM oga_file WHERE oga01 = p_no
      IF l_oga.ogapost = 'Y' THEN 
         CALL cl_err('','wmb-019',1)  #單據過帳成功
         RETURN TRUE
      ELSE 
         CALL cl_err('','wmb-020',1)
         RETURN FALSE
      END IF 
   ELSE
      RETURN TRUE
   END IF
   
   RETURN FALSE
END FUNCTION 


#銷退
FUNCTION s_chk_scan_qty_axmt700(p_no,p_post_flag)
DEFINE p_no         LIKE type_file.chr20
DEFINE p_post_flag  LIKE type_file.chr1
DEFINE l_cnt        LIKE type_file.num5
DEFINE l_sql        STRING 
DEFINE l_ln         LIKE type_file.num5
DEFINE l_scan_qty   LIKE tlfb_file.tlfb05   #掃描數量
DEFINE l_no_qty     LIKE ohb_file.ohb12     #單據數量
DEFINE l_oha        RECORD LIKE oha_file.*

   #檢查傳入單據p_no的單身料號是否全數為條碼料號(ima930='Y')，
   #若有單身料號使用條碼否為'N'，
   #則跳窗顯示錯誤訊息「含非條碼料件，請由ERP進行確認」，
   #回傳FALSE。

   LET l_cnt = 0 
   SELECT COUNT(*) INTO l_cnt FROM ima_file,ohb_file 
    WHERE ima01 = ohb04 
      AND (ima930 = 'N' OR ima930 IS NULL)
      AND ohb01 = p_no
   IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF 
   IF l_cnt > 0 THEN 
      CALL cl_err('','aba-201',1)  #含非條碼料件，請由ERP進行過帳
      RETURN FALSE
   END IF 

   
   #檢查掃描數量是否足量
   LET l_sql = "SELECT ohb03,ohb12 FROM ohb_file", 
               " WHERE ohb01 = '",p_no,"'"
   DECLARE ohb_cs CURSOR FROM l_sql
   
   LET l_sql = "SELECT SUM(tlfb05*tlfb06) FROM tlfb_file ",
               " WHERE tlfb07 = ? AND tlfb08 = ? "
   PREPARE tlfb_prep4 FROM l_sql
    
   LET l_ln = NULL
   LET l_no_qty = 0
   
   FOREACH ohb_cs INTO l_ln,l_no_qty
      IF SQLCA.SQLCODE THEN 
         CALL cl_err('foreach ohb_cs:',SQLCA.SQLCODE,1)
         EXIT FOREACH
      END IF 
   
      IF cl_null(l_no_qty) THEN LET l_no_qty = 0 END IF 
      
      LET l_scan_qty = 0 
      EXECUTE tlfb_prep4 USING p_no,l_ln INTO l_scan_qty
      IF cl_null(l_scan_qty) THEN LET l_scan_qty = 0 END IF 

      IF l_scan_qty <> l_no_qty THEN 
         CALL cl_err('','aba-202',1)  #條碼數量與原單據不符，請由ERP進行過帳
         RETURN FALSE
      END IF 
      
   END FOREACH 

   IF p_post_flag = 'Y' THEN 
      CALL saxmt700sub_s('2','1',p_no,FALSE) 
      INITIALIZE l_oha.* TO NULL
      SELECT * INTO l_oha.* FROM oha_file WHERE oha01 = p_no
      IF l_oha.ohapost = 'Y' THEN 
         CALL cl_err('','wmb-019',1)  #單據過帳成功
         RETURN TRUE
      ELSE 
         CALL cl_err('','wmb-020',1)
         RETURN FALSE
      END IF 
   ELSE
      RETURN TRUE
   END IF
   
   RETURN FALSE
END FUNCTION 


#雜收
FUNCTION s_chk_scan_qty_aimt302(p_no,p_post_flag)
DEFINE p_no         LIKE type_file.chr20
DEFINE p_post_flag  LIKE type_file.chr1
DEFINE l_cnt        LIKE type_file.num5
DEFINE l_sql        STRING 
DEFINE l_ln         LIKE type_file.num5
DEFINE l_scan_qty   LIKE tlfb_file.tlfb05   #掃描數量
DEFINE l_no_qty     LIKE inb_file.inb16     #單據數量
DEFINE l_ina        RECORD LIKE ina_file.*

   #檢查傳入單據p_no的單身料號是否全數為條碼料號(ima930='Y')，
   #若有單身料號使用條碼否為'N'，
   #則跳窗顯示錯誤訊息「含非條碼料件，請由ERP進行確認」，
   #回傳FALSE。

   LET l_cnt = 0 
   SELECT COUNT(*) INTO l_cnt FROM ima_file,inb_file 
    WHERE ima01 = inb04 
      AND (ima930 = 'N' OR ima930 IS NULL)
      AND inb01 = p_no
   IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF 
   IF l_cnt > 0 THEN 
      CALL cl_err('','aba-201',1)  #含非條碼料件，請由ERP進行過帳
      RETURN FALSE
   END IF 

   
   #檢查掃描數量是否足量
   LET l_sql = "SELECT inb03,inb16 FROM inb_file", 
               " WHERE inb01 = '",p_no,"'"
   DECLARE inb_cs CURSOR FROM l_sql
   
   LET l_sql = "SELECT SUM(tlfb05*tlfb06) FROM tlfb_file ",
               " WHERE tlfb07 = ? AND tlfb08 = ? "
   PREPARE tlfb_prep5 FROM l_sql
    
   LET l_ln = NULL
   LET l_no_qty = 0
   
   FOREACH inb_cs INTO l_ln,l_no_qty
      IF SQLCA.SQLCODE THEN 
         CALL cl_err('foreach inb_cs:',SQLCA.SQLCODE,1)
         EXIT FOREACH
      END IF 
   
      IF cl_null(l_no_qty) THEN LET l_no_qty = 0 END IF 
      
      LET l_scan_qty = 0 
      EXECUTE tlfb_prep5 USING p_no,l_ln INTO l_scan_qty
      IF cl_null(l_scan_qty) THEN LET l_scan_qty = 0 END IF 

      IF l_scan_qty <> l_no_qty THEN 
         CALL cl_err('','aba-202',1)  #條碼數量與原單據不符，請由ERP進行過帳
         RETURN FALSE
      END IF 
      
   END FOREACH 

   IF p_post_flag = 'Y' THEN 
      CALL t370sub_s_chk(p_no,'Y',FALSE,g_today) 
      IF g_success = "Y" THEN
         CALL t370sub_s_upd(p_no,'3',FALSE) 
      END IF
      INITIALIZE l_ina.* TO NULL
      SELECT * INTO l_ina.* FROM ina_file WHERE ina01 = p_no
      IF l_ina.inapost = 'Y' THEN 
         CALL cl_err('','wmb-019',1)  #單據過帳成功
         RETURN TRUE
      ELSE 
         CALL cl_err('','wmb-020',1)
         RETURN FALSE
      END IF 
   ELSE
      RETURN TRUE
   END IF
   
   RETURN FALSE
END FUNCTION 


#雜發
FUNCTION s_chk_scan_qty_aimt301(p_no,p_post_flag)
DEFINE p_no         LIKE type_file.chr20
DEFINE p_post_flag  LIKE type_file.chr1
DEFINE l_cnt        LIKE type_file.num5
DEFINE l_sql        STRING 
DEFINE l_ln         LIKE type_file.num5
DEFINE l_scan_qty   LIKE tlfb_file.tlfb05   #掃描數量
DEFINE l_no_qty     LIKE inb_file.inb16     #單據數量
DEFINE l_ina        RECORD LIKE ina_file.*

   #檢查傳入單據p_no的單身料號是否全數為條碼料號(ima930='Y')，
   #若有單身料號使用條碼否為'N'，
   #則跳窗顯示錯誤訊息「含非條碼料件，請由ERP進行確認」，
   #回傳FALSE。

   LET l_cnt = 0 
   SELECT COUNT(*) INTO l_cnt FROM ima_file,inb_file 
    WHERE ima01 = inb04 
      AND (ima930 = 'N' OR ima930 IS NULL)
      AND inb01 = p_no
   IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF 
   IF l_cnt > 0 THEN 
      CALL cl_err('','aba-201',1)  #含非條碼料件，請由ERP進行過帳
      RETURN FALSE
   END IF 

   
   #檢查掃描數量是否足量
   LET l_sql = "SELECT inb03,inb16 FROM inb_file", 
               " WHERE inb01 = '",p_no,"'"
   DECLARE inb_cs2 CURSOR FROM l_sql
   
   LET l_sql = "SELECT SUM(tlfb05*tlfb06)*(-1) FROM tlfb_file ",
               " WHERE tlfb07 = ? AND tlfb08 = ? "
   PREPARE tlfb_prep6 FROM l_sql
    
   LET l_ln = NULL
   LET l_no_qty = 0
   
   FOREACH inb_cs2 INTO l_ln,l_no_qty
      IF SQLCA.SQLCODE THEN 
         CALL cl_err('foreach inb_cs2:',SQLCA.SQLCODE,1)
         EXIT FOREACH
      END IF 
   
      IF cl_null(l_no_qty) THEN LET l_no_qty = 0 END IF 
      
      LET l_scan_qty = 0 
      EXECUTE tlfb_prep6 USING p_no,l_ln INTO l_scan_qty
      IF cl_null(l_scan_qty) THEN LET l_scan_qty = 0 END IF 

      IF l_scan_qty <> l_no_qty THEN 
         CALL cl_err('','aba-202',1)  #條碼數量與原單據不符，請由ERP進行過帳
         RETURN FALSE
      END IF 
      
   END FOREACH 

   IF p_post_flag = 'Y' THEN 
      CALL t370sub_s_chk(p_no,'Y',FALSE,g_today) 
      IF g_success = "Y" THEN
         CALL t370sub_s_upd(p_no,'1',FALSE) 
      END IF
      INITIALIZE l_ina.* TO NULL
      SELECT * INTO l_ina.* FROM ina_file WHERE ina01 = p_no
      IF l_ina.inapost = 'Y' THEN 
         CALL cl_err('','wmb-019',1)  #單據過帳成功
         RETURN TRUE
      ELSE 
         CALL cl_err('','wmb-020',1)
         RETURN FALSE
      END IF 
   ELSE
      RETURN TRUE
   END IF
   
   RETURN FALSE
END FUNCTION 


#直接調撥
FUNCTION s_chk_scan_qty_aimt324(p_no,p_post_flag)
DEFINE p_no         LIKE type_file.chr20
DEFINE p_post_flag  LIKE type_file.chr1
DEFINE l_cnt        LIKE type_file.num5
DEFINE l_sql        STRING 
DEFINE l_ln         LIKE type_file.num5
DEFINE l_scan_qty   LIKE tlfb_file.tlfb05   #掃描數量
DEFINE l_no_qty     LIKE imn_file.imn22     #單據數量
DEFINE l_imm        RECORD LIKE imm_file.*

   #檢查傳入單據p_no的單身料號是否全數為條碼料號(ima930='Y')，
   #若有單身料號使用條碼否為'N'，
   #則跳窗顯示錯誤訊息「含非條碼料件，請由ERP進行確認」，
   #回傳FALSE。

   LET l_cnt = 0 
   SELECT COUNT(*) INTO l_cnt FROM ima_file,imn_file 
    WHERE ima01 = imn03 
      AND (ima930 = 'N' OR ima930 IS NULL)
      AND imn01 = p_no
   IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF 
   IF l_cnt > 0 THEN 
      CALL cl_err('','aba-201',1)  #含非條碼料件，請由ERP進行過帳
      RETURN FALSE
   END IF 

   
   #檢查掃描數量是否足量
   LET l_sql = "SELECT imn02,imn22 FROM imn_file", 
               " WHERE imn01 = '",p_no,"'"
   DECLARE imn_cs CURSOR FROM l_sql
   
   LET l_sql = "SELECT SUM(tlfb05*tlfb06) FROM tlfb_file ",
               " WHERE tlfb07 = ? AND tlfb08 = ? ",
               "   AND tlfb06 = 1 ",
               "   AND tlfb19 = 'Y' "
   PREPARE tlfb_prep7 FROM l_sql
    
   LET l_ln = NULL
   LET l_no_qty = 0
   
   FOREACH imn_cs INTO l_ln,l_no_qty
      IF SQLCA.SQLCODE THEN 
         CALL cl_err('foreach imn_cs:',SQLCA.SQLCODE,1)
         EXIT FOREACH
      END IF 
   
      IF cl_null(l_no_qty) THEN LET l_no_qty = 0 END IF 
      
      LET l_scan_qty = 0 
      EXECUTE tlfb_prep7 USING p_no,l_ln INTO l_scan_qty
      IF cl_null(l_scan_qty) THEN LET l_scan_qty = 0 END IF 

      IF l_scan_qty <> l_no_qty THEN 
         CALL cl_err('','aba-202',1)  #條碼數量與原單據不符，請由ERP進行過帳
         RETURN FALSE
      END IF 
      
   END FOREACH 

   IF p_post_flag = 'Y' THEN 
      CALL t324sub_s(p_no,'','')
      INITIALIZE l_imm.* TO NULL
      SELECT * INTO l_imm.* FROM imm_file WHERE imm01 = p_no
      IF l_imm.imm03 = 'Y' THEN 
         CALL cl_err('','wmb-019',1)  #單據過帳成功
         RETURN TRUE
      ELSE 
         CALL cl_err('','wmb-020',1)
         RETURN FALSE
      END IF 
   ELSE
      RETURN TRUE
   END IF
   
   RETURN FALSE
END FUNCTION 


#間接調撥-撥出
FUNCTION s_chk_scan_qty_aimt325(p_no,p_post_flag)
DEFINE p_no         LIKE type_file.chr20
DEFINE p_post_flag  LIKE type_file.chr1
DEFINE l_cnt        LIKE type_file.num5
DEFINE l_sql        STRING 
DEFINE l_ln         LIKE type_file.num5
DEFINE l_scan_qty   LIKE tlfb_file.tlfb05   #掃描數量
DEFINE l_no_qty     LIKE imn_file.imn10     #單據數量
DEFINE l_imm        RECORD LIKE imm_file.*

   #檢查傳入單據p_no的單身料號是否全數為條碼料號(ima930='Y')，
   #若有單身料號使用條碼否為'N'，
   #則跳窗顯示錯誤訊息「含非條碼料件，請由ERP進行確認」，
   #回傳FALSE。

   LET l_cnt = 0 
   SELECT COUNT(*) INTO l_cnt FROM ima_file,imn_file 
    WHERE ima01 = imn03 
      AND (ima930 = 'N' OR ima930 IS NULL)
      AND imn01 = p_no
   IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF 
   IF l_cnt > 0 THEN 
      CALL cl_err('','aba-183',1)  #含非條碼料件，請由ERP進行確認
      RETURN FALSE
   END IF 

   
   #檢查掃描數量是否足量
   LET l_sql = "SELECT imn02,imn10 FROM imn_file", 
               " WHERE imn01 = '",p_no,"'"
   DECLARE imn_cs2 CURSOR FROM l_sql
   
   LET l_sql = "SELECT SUM(tlfb05*tlfb06)*(-1) FROM tlfb_file ",
               " WHERE tlfb07 = ? AND tlfb08 = ? ",
               "   AND tlfb06 = -1 ",
               "   AND tlfb19 = 'Y' "
   PREPARE tlfb_prep8 FROM l_sql
    
   LET l_ln = NULL
   LET l_no_qty = 0
   
   FOREACH imn_cs2 INTO l_ln,l_no_qty
      IF SQLCA.SQLCODE THEN 
         CALL cl_err('foreach imn_cs2:',SQLCA.SQLCODE,1)
         EXIT FOREACH
      END IF 
   
      IF cl_null(l_no_qty) THEN LET l_no_qty = 0 END IF 
      
      LET l_scan_qty = 0 
      EXECUTE tlfb_prep8 USING p_no,l_ln INTO l_scan_qty
      IF cl_null(l_scan_qty) THEN LET l_scan_qty = 0 END IF 

      IF l_scan_qty <> l_no_qty THEN 
         CALL cl_err('','aba-184',1)  #條碼數量與原單據不符，請由ERP進行確認
         RETURN FALSE
      END IF 
      
   END FOREACH 

   IF p_post_flag = 'Y' THEN 
      CALL t325sub_y(p_no,FALSE,'Y')
      INITIALIZE l_imm.* TO NULL
      SELECT * INTO l_imm.* FROM imm_file WHERE imm01 = p_no
      IF l_imm.imm04 = 'Y' THEN 
         CALL cl_err('','wmb-019',1)  #單據過帳成功
         RETURN TRUE
      ELSE 
         CALL cl_err('','wmb-020',1)
         RETURN FALSE
      END IF 
   ELSE
      RETURN TRUE
   END IF
   
   RETURN FALSE
END FUNCTION 


#間接調撥-撥入
FUNCTION s_chk_scan_qty_aimt326(p_no,p_post_flag)
DEFINE p_no         LIKE type_file.chr20
DEFINE p_post_flag  LIKE type_file.chr1
DEFINE l_cnt        LIKE type_file.num5
DEFINE l_sql        STRING 
DEFINE l_ln         LIKE type_file.num5
DEFINE l_scan_qty   LIKE tlfb_file.tlfb05   #掃描數量
DEFINE l_no_qty     LIKE imn_file.imn22     #單據數量
DEFINE l_imm        RECORD LIKE imm_file.*

   #檢查傳入單據p_no的單身料號是否全數為條碼料號(ima930='Y')，
   #若有單身料號使用條碼否為'N'，
   #則跳窗顯示錯誤訊息「含非條碼料件，請由ERP進行確認」，
   #回傳FALSE。

   LET l_cnt = 0 
   SELECT COUNT(*) INTO l_cnt FROM ima_file,imn_file 
    WHERE ima01 = imn03 
      AND (ima930 = 'N' OR ima930 IS NULL)
      AND imn01 = p_no
   IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF 
   IF l_cnt > 0 THEN 
      CALL cl_err('','aba-183',1)  #含非條碼料件，請由ERP進行確認
      RETURN FALSE
   END IF 

   
   #檢查掃描數量是否足量
   LET l_sql = "SELECT imn02,imn22 FROM imn_file", 
               " WHERE imn01 = '",p_no,"'"
   DECLARE imn_cs3 CURSOR FROM l_sql
   
   LET l_sql = "SELECT SUM(tlfb05*tlfb06) FROM tlfb_file ",
               " WHERE tlfb07 = ? AND tlfb08 = ? ",
               "   AND tlfb06 = 1 ",
               "   AND tlfb19 = 'Y' "
   PREPARE tlfb_prep9 FROM l_sql
    
   LET l_ln = NULL
   LET l_no_qty = 0
   
   FOREACH imn_cs3 INTO l_ln,l_no_qty
      IF SQLCA.SQLCODE THEN 
         CALL cl_err('foreach imn_cs2:',SQLCA.SQLCODE,1)
         EXIT FOREACH
      END IF 
   
      IF cl_null(l_no_qty) THEN LET l_no_qty = 0 END IF 
      
      LET l_scan_qty = 0 
      EXECUTE tlfb_prep9 USING p_no,l_ln INTO l_scan_qty
      IF cl_null(l_scan_qty) THEN LET l_scan_qty = 0 END IF 

      IF l_scan_qty <> l_no_qty THEN 
         CALL cl_err('','aba-184',1)  #條碼數量與原單據不符，請由ERP進行確認
         RETURN FALSE
      END IF 
      
   END FOREACH 

   IF p_post_flag = 'Y' THEN 
      CALL t325sub_s(p_no,FALSE,'Y')
      INITIALIZE l_imm.* TO NULL
      SELECT * INTO l_imm.* FROM imm_file WHERE imm01 = p_no
      IF l_imm.imm03 = 'Y' THEN 
         CALL cl_err('','wmb-019',1)  #單據過帳成功
         RETURN TRUE
      ELSE 
         CALL cl_err('','wmb-020',1)
         RETURN FALSE
      END IF 
   ELSE
      RETURN TRUE
   END IF
   
   RETURN FALSE
END FUNCTION 

#採購入庫
FUNCTION s_chk_scan_qty_apmt720(p_no,p_post_flag)
DEFINE p_no         LIKE type_file.chr20
DEFINE p_post_flag  LIKE type_file.chr1
DEFINE l_cnt        LIKE type_file.num5
DEFINE l_sql        STRING 
DEFINE l_ln         LIKE type_file.num5
DEFINE l_scan_qty   LIKE tlfb_file.tlfb05   #掃描數量
DEFINE l_no_qty     LIKE imn_file.imn22     #單據數量
DEFINE l_rvu        RECORD LIKE rvu_file.*

   #檢查傳入單據p_no的單身料號是否全數為條碼料號(ima930='Y')，
   #若有單身料號使用條碼否為'N'，
   #則跳窗顯示錯誤訊息「含非條碼料件，請由ERP進行確認」，
   #回傳FALSE。

   LET l_cnt = 0 
   SELECT COUNT(*) INTO l_cnt FROM ima_file,rvv_file 
    WHERE ima01 = rvv31 
      AND (ima930 = 'N' OR ima930 IS NULL)
      AND rvv01 = p_no
   IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF 
   IF l_cnt > 0 THEN 
      CALL cl_err('','aba-183',1)  #含非條碼料件，請由ERP進行確認
      RETURN FALSE
   END IF 

   
   #檢查掃描數量是否足量
   LET l_sql = "SELECT rvv02,rvv17 FROM rvv_file", 
               " WHERE rvv01 = '",p_no,"'"
   DECLARE rvv_cs CURSOR FROM l_sql
   
   LET l_sql = "SELECT SUM(tlfb05*tlfb06) FROM tlfb_file ",
               " WHERE tlfb07 = ? AND tlfb08 = ? "
   PREPARE tlfb_prep10 FROM l_sql
    
   LET l_ln = NULL
   LET l_no_qty = 0
   
   FOREACH rvv_cs INTO l_ln,l_no_qty
      IF SQLCA.SQLCODE THEN 
         CALL cl_err('foreach imn_cs2:',SQLCA.SQLCODE,1)
         EXIT FOREACH
      END IF 
   
      IF cl_null(l_no_qty) THEN LET l_no_qty = 0 END IF 
      
      LET l_scan_qty = 0 
      EXECUTE tlfb_prep10 USING p_no,l_ln INTO l_scan_qty
      IF cl_null(l_scan_qty) THEN LET l_scan_qty = 0 END IF 

      IF l_scan_qty <> l_no_qty THEN 
         CALL cl_err('','aba-184',1)  #條碼數量與原單據不符，請由ERP進行確認
         RETURN FALSE
      END IF 
      
   END FOREACH 

   IF p_post_flag = 'Y' THEN 
      CALL t720sub_y_chk(p_no,'1','',' ','7','Y')
      IF g_aza.aza115='Y' THEN
         LET l_cnt = 0
         SELECT COUNT(*) INTO l_cnt FROM rvv_file 
          WHERE rvv26 IS NULL AND rvv01 = p_no
         IF l_cnt > 0 THEN
            CALL cl_err('','aim-888',0)
            LET g_success='N'
         END IF
      END IF
      IF g_success = "Y" THEN
         CALL t720sub_y_upd(p_no,'1','',' ','7',FALSE,'Y','N') 
      END IF
      INITIALIZE l_rvu.* TO NULL
      SELECT * INTO l_rvu.* FROM rvu_file WHERE rvu01 = p_no
      IF l_rvu.rvuconf = 'Y' THEN 
         CALL cl_err('','wmb-019',1)  #單據過帳成功
         RETURN TRUE
      ELSE 
         CALL cl_err('','wmb-020',1)
         RETURN FALSE
      END IF 
   ELSE
      RETURN TRUE
   END IF
   
   RETURN FALSE
END FUNCTION 

#DEV-D30046 --add
