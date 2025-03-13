# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name  : p_unpack2_web_dataupdate.4gl
# Program ver.  : 
# Description   : web區解包時資料處理
# Date & Author : 2012/03/12 By joyce
# Memo          :
# Modify........: No.FUN-C20069 12/03/12 By joyce 新增程式
# Modify........: No.TQC-C90062 12/09/12 By jt_chen web區解包時資料處理,需增加記錄成功筆數
# Modify........: No:FUN-D30029 13/03/13 By joyce 調整wzm_file資料取得key值條件


IMPORT os
DATABASE wds

# No:FUN-C20069
FUNCTION p_unpack2_web_dataupdate(g_tarname)
   DEFINE   l_cmd        STRING
   DEFINE   l_result     SMALLINT
   DEFINE   gc_channel   base.Channel
   DEFINE   g_tarname    STRING
   DEFINE   li_count     SMALLINT
   DEFINE   lr_wzb       RECORD LIKE wzb_file.*
   DEFINE   lr_wzc       RECORD LIKE wzc_file.*
   DEFINE   lr_wzd       RECORD LIKE wzd_file.*
   DEFINE   lr_wzf       RECORD LIKE wzf_file.*
   DEFINE   lr_wzh       RECORD LIKE wzh_file.*
   DEFINE   lr_wzi       RECORD LIKE wzi_file.*
   DEFINE   lr_wzl       RECORD LIKE wzl_file.*
   DEFINE   lr_wzm       RECORD LIKE wzm_file.*
   DEFINE   lr_wzo       RECORD LIKE wzo_file.*
   DEFINE   lr_wzs       RECORD LIKE wzs_file.*
   DEFINE   lr_wzz       RECORD LIKE wzz_file.*
   DEFINE   lr_wya       RECORD LIKE wya_file.*
   DEFINE   lr_wyb       RECORD LIKE wyb_file.*
   DEFINE   lr_wyc       RECORD LIKE wyc_file.*
   DEFINE   l_str        STRING          #TQC-C90062
   DEFINE   gs_channel   base.Channel    #TQC-C90062

   WHENEVER ERROR CONTINUE
#  WHENEVER ERROR CALL cl_err_msg_log

   LET gc_channel = base.Channel.create()
   LET l_cmd = os.Path.join(os.Path.join(os.Path.join(FGL_GETENV("TOP"),"pack"),g_tarname),"load.log")
   CALL gc_channel.openFile(l_cmd,"a")   # append
   CALL gc_channel.setDelimiter("")
   
   #TQC-C90062 -- add start -- #OPEN channel 紀錄LOAD同步資料成功筆數
   LET gs_channel = base.Channel.create()
   LET l_cmd = os.Path.join(os.Path.join(os.Path.join(FGL_GETENV("TOP"),"pack"),g_tarname),"Success.log")
   CALL gs_channel.openFile(l_cmd,"a")
   CALL gs_channel.setDelimiter("")
   #TQC-C90062 -- add end --

   DISPLAY "開始更新wzb_file資料"
   LET li_count = 0
   DECLARE wzb_o_curs CURSOR FOR
    SELECT * FROM patchtemp.wzb_file
     WHERE wzb01 IN (SELECT tbkey01 FROM patchtemp.psl_file 
                      WHERE tbname='wzb_file')
   FOREACH wzb_o_curs INTO lr_wzb.*
      IF SQLCA.sqlcode THEN
         LET l_cmd = "wzb_file patchtemp FOREACH 資料時產生錯誤，wzb資料無更新"
         CALL gc_channel.write(l_cmd)
         EXIT FOREACH
      END IF

      INSERT INTO wds.wzb_file VALUES(lr_wzb.*)
      IF SQLCA.sqlcode THEN
         UPDATE wds.wzb_file SET wzb_file.* = lr_wzb.*
          WHERE wzb01 = lr_wzb.wzb01 AND wzb11 = lr_wzb.wzb11
         IF SQLCA.sqlcode THEN    
            LET l_cmd = "upload wzb_file data error:",SQLCA.sqlerrd[2]," ",lr_wzb.*
            CALL gc_channel.write(l_cmd)
            LET l_result = FALSE
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      ELSE
         LET li_count = li_count + SQLCA.sqlerrd[3]
      END IF
   END FOREACH
   DISPLAY "wzb_file 更新完畢，共更新 ",li_count,"筆資料"
   LET l_str = "wzb_file 更新完畢，共更新 ",li_count,"筆資料"
   CALL gs_channel.write(l_str)   #TQC-C90062

   DISPLAY "開始更新wzc_file資料"
   LET li_count = 0
   DECLARE wzc_o_curs CURSOR FOR
    SELECT * FROM patchtemp.wzc_file
     WHERE wzc01 IN (SELECT tbkey01 FROM patchtemp.psl_file 
                      WHERE tbname='wzb_file')
   FOREACH wzc_o_curs INTO lr_wzc.*
      IF SQLCA.sqlcode THEN
         LET l_cmd = "wzc_file patchtemp FOREACH 資料時產生錯誤，wzc資料無更新"
         CALL gc_channel.write(l_cmd)
         EXIT FOREACH
      END IF

      INSERT INTO wds.wzc_file VALUES(lr_wzc.*)
      IF SQLCA.sqlcode THEN
         UPDATE wds.wzc_file SET wzc_file.* = lr_wzc.*
          WHERE wzc01 = lr_wzc.wzc01 AND wzc02 = lr_wzc.wzc02
            AND wzc12 = lr_wzc.wzc12
         IF SQLCA.sqlcode THEN    
            LET l_cmd = "upload wzc_file data error:",SQLCA.sqlerrd[2]," ",lr_wzc.*
            CALL gc_channel.write(l_cmd)
            LET l_result = FALSE
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      ELSE
         LET li_count = li_count + SQLCA.sqlerrd[3]
      END IF
   END FOREACH
   DISPLAY "wzc_file 更新完畢，共更新 ",li_count,"筆資料"
   LET l_str = "wzc_file 更新完畢，共更新 ",li_count,"筆資料"
   CALL gs_channel.write(l_str)   #TQC-C90062

   DISPLAY "開始更新wzd_file資料"
   LET li_count = 0
   DECLARE wzd_o_curs CURSOR FOR
   SELECT DISTINCT wzd_file.* FROM patchtemp.wzd_file,patchtemp.psl_file
    WHERE wzd01=tbkey01 AND wzd02=tbkey02 AND tbname='wzd_file'
   FOREACH wzd_o_curs INTO lr_wzd.*
      IF SQLCA.sqlcode THEN
         LET l_cmd = "wzd_file patchtemp FOREACH 資料時產生錯誤，wzd資料無更新"
         CALL gc_channel.write(l_cmd)
         EXIT FOREACH
      END IF

      INSERT INTO wds.wzd_file VALUES(lr_wzd.*)
      IF SQLCA.sqlcode THEN
         UPDATE wds.wzd_file SET wzd_file.* = lr_wzd.*
          WHERE wzd01 = lr_wzd.wzd01 AND wzd02 = lr_wzd.wzd02
         IF SQLCA.sqlcode THEN    
            LET l_cmd = "upload wzd_file data error:",SQLCA.sqlerrd[2]," ",lr_wzd.*
            CALL gc_channel.write(l_cmd)
            LET l_result = FALSE
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      ELSE
         LET li_count = li_count + SQLCA.sqlerrd[3]
      END IF
   END FOREACH
   DISPLAY "wzd_file 更新完畢，共更新 ",li_count,"筆資料"
   LET l_str = "wzd_file 更新完畢，共更新 ",li_count,"筆資料"
   CALL gs_channel.write(l_str)   #TQC-C90062

   DISPLAY "開始更新wzf_file資料"
   LET li_count = 0
   DECLARE wzf_o_curs CURSOR FOR
    SELECT * FROM patchtemp.wzf_file
     WHERE wzf01 IN (SELECT tbkey01 FROM patchtemp.psl_file 
                      WHERE tbname='wzf_file')
   FOREACH wzf_o_curs INTO lr_wzf.*
      IF SQLCA.sqlcode THEN
         LET l_cmd = "wzf_file patchtemp FOREACH 資料時產生錯誤，wzf資料無更新"
         CALL gc_channel.write(l_cmd)
         EXIT FOREACH
      END IF

      INSERT INTO wds.wzf_file VALUES(lr_wzf.*)
      IF SQLCA.sqlcode THEN
         UPDATE wds.wzf_file SET wzf_file.* = lr_wzf.*
          WHERE wzf01 = lr_wzf.wzf01 AND wzf02 = lr_wzf.wzf02
            AND wzf03 = lr_wzf.wzf03 AND wzf05 = lr_wzf.wzf05
         IF SQLCA.sqlcode THEN    
            LET l_cmd = "upload wzf_file data error:",SQLCA.sqlerrd[2]," ",lr_wzf.*
            CALL gc_channel.write(l_cmd)
            LET l_result = FALSE
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      ELSE
         LET li_count = li_count + SQLCA.sqlerrd[3]
      END IF
   END FOREACH
   DISPLAY "wzf_file 更新完畢，共更新 ",li_count,"筆資料"
   LET l_str = "wzf_file 更新完畢，共更新 ",li_count,"筆資料"
   CALL gs_channel.write(l_str)   #TQC-C90062

   DISPLAY "開始更新wzh_file資料"
   LET li_count = 0
   DECLARE wzh_o_curs CURSOR FOR
    SELECT * FROM patchtemp.wzh_file
     WHERE wzh01 IN (SELECT tbkey01 FROM patchtemp.psl_file 
                      WHERE tbname='wzh_file')
   FOREACH wzh_o_curs INTO lr_wzh.*
      IF SQLCA.sqlcode THEN
         LET l_cmd = "wzh_file patchtemp FOREACH 資料時產生錯誤，hzc資料無更新"
         CALL gc_channel.write(l_cmd)
         EXIT FOREACH
      END IF

      INSERT INTO wds.wzh_file VALUES(lr_wzh.*)
      IF SQLCA.sqlcode THEN
         UPDATE wds.wzh_file SET wzh_file.* = lr_wzh.*
          WHERE wzh01 = lr_wzh.wzh01 AND wzh02 = lr_wzh.wzh02
            AND wzh03 = lr_wzh.wzh03
         IF SQLCA.sqlcode THEN    
            LET l_cmd = "upload wzh_file data error:",SQLCA.sqlerrd[2]," ",lr_wzh.*
            CALL gc_channel.write(l_cmd)
            LET l_result = FALSE
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      ELSE
         LET li_count = li_count + SQLCA.sqlerrd[3]
      END IF
   END FOREACH
   DISPLAY "wzh_file 更新完畢，共更新 ",li_count,"筆資料"
   LET l_str = "wzh_file 更新完畢，共更新 ",li_count,"筆資料"
   CALL gs_channel.write(l_str)   #TQC-C90062

   DISPLAY "開始更新wzi_file資料"
   LET li_count = 0
   DECLARE wzi_o_curs CURSOR FOR
    SELECT * FROM patchtemp.wzi_file
     WHERE wzi01 IN (SELECT tbkey01 FROM patchtemp.psl_file 
                      WHERE tbname='wzi_file')
   FOREACH wzi_o_curs INTO lr_wzi.*
      IF SQLCA.sqlcode THEN
         LET l_cmd = "wzi_file patchtemp FOREACH 資料時產生錯誤，wzi資料無更新"
         CALL gc_channel.write(l_cmd)
         EXIT FOREACH
      END IF

      INSERT INTO wds.wzi_file VALUES(lr_wzi.*)
      IF SQLCA.sqlcode THEN
         UPDATE wds.wzi_file SET wzi_file.* = lr_wzi.*
          WHERE wzi01 = lr_wzi.wzi01 AND wzi02 = lr_wzi.wzi02
            AND wzi03 = lr_wzi.wzi03
         IF SQLCA.sqlcode THEN    
            LET l_cmd = "upload wzi_file data error:",SQLCA.sqlerrd[2]," ",lr_wzi.*
            CALL gc_channel.write(l_cmd)
            LET l_result = FALSE
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      ELSE
         LET li_count = li_count + SQLCA.sqlerrd[3]
      END IF
   END FOREACH
   DISPLAY "wzi_file 更新完畢，共更新 ",li_count,"筆資料"
   LET l_str = "wzi_file 更新完畢，共更新 ",li_count,"筆資料"
   CALL gs_channel.write(l_str)   #TQC-C90062

   DISPLAY "開始更新wzl_file資料"
   LET li_count = 0
   DECLARE wzl_o_curs CURSOR FOR
    SELECT * FROM patchtemp.wzl_file
     WHERE wzl01 IN (SELECT tbkey01 FROM patchtemp.psl_file 
                      WHERE tbname='wzl_file')
   FOREACH wzl_o_curs INTO lr_wzl.*
      IF SQLCA.sqlcode THEN
         LET l_cmd = "wzl_file patchtemp FOREACH 資料時產生錯誤，wzl資料無更新"
         CALL gc_channel.write(l_cmd)
         EXIT FOREACH
      END IF

      INSERT INTO wds.wzl_file VALUES(lr_wzl.*)
      IF SQLCA.sqlcode THEN
         UPDATE wds.wzl_file SET wzl_file.* = lr_wzl.*
          WHERE wzl01 = lr_wzl.wzl01 AND wzl02 = lr_wzl.wzl02
            AND wzl03 = lr_wzl.wzl03
         IF SQLCA.sqlcode THEN    
            LET l_cmd = "upload wzl_file data error:",SQLCA.sqlerrd[2]," ",lr_wzl.*
            CALL gc_channel.write(l_cmd)
            LET l_result = FALSE
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      ELSE
         LET li_count = li_count + SQLCA.sqlerrd[3]
      END IF
   END FOREACH
   DISPLAY "wzl_file 更新完畢，共更新 ",li_count,"筆資料"
   LET l_str = "wzl_file 更新完畢，共更新 ",li_count,"筆資料"
   CALL gs_channel.write(l_str)   #TQC-C90062

   DISPLAY "開始更新wzm_file資料"
   LET li_count = 0
   DECLARE wzm_o_curs CURSOR FOR
    SELECT * FROM patchtemp.wzm_file
     WHERE wzm02 IN (SELECT tbkey01 FROM patchtemp.psl_file 
                      WHERE tbname='wzz_file')
        OR wzm02 IN (SELECT tbkey02 FROM patchtemp.psl_file    # No:FUN-D30029
                      WHERE tbname='wzm_file')
   FOREACH wzm_o_curs INTO lr_wzm.*
      IF SQLCA.sqlcode THEN
         LET l_cmd = "wzm_file patchtemp FOREACH 資料時產生錯誤，wzm資料無更新"
         CALL gc_channel.write(l_cmd)
         EXIT FOREACH
      END IF

      INSERT INTO wds.wzm_file VALUES(lr_wzm.*)
      IF SQLCA.sqlcode THEN
         UPDATE wds.wzm_file SET wzm_file.* = lr_wzm.*
          WHERE wzm01 = lr_wzm.wzm01 AND wzm02 = lr_wzm.wzm02
            AND wzm03 = lr_wzm.wzm03 AND wzm04 = lr_wzm.wzm04
            AND wzm05 = lr_wzm.wzm05 AND wzm06 = lr_wzm.wzm06
            AND wzm07 = lr_wzm.wzm07 AND wzm08 = lr_wzm.wzm08
         IF SQLCA.sqlcode THEN    
            LET l_cmd = "upload wzm_file data error:",SQLCA.sqlerrd[2]," ",lr_wzm.*
            CALL gc_channel.write(l_cmd)
            LET l_result = FALSE
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      ELSE
         LET li_count = li_count + SQLCA.sqlerrd[3]
      END IF
   END FOREACH
   DISPLAY "wzm_file 更新完畢，共更新 ",li_count,"筆資料"
   LET l_str = "wzm_file 更新完畢，共更新 ",li_count,"筆資料"
   CALL gs_channel.write(l_str)   #TQC-C90062

   DISPLAY "開始更新wzo_file資料"
   LET li_count = 0
   DECLARE wzo_o_curs CURSOR FOR
    SELECT * FROM patchtemp.wzo_file
     WHERE wzo01 IN (SELECT tbkey01 FROM patchtemp.psl_file 
                      WHERE tbname='wzo_file')
   FOREACH wzo_o_curs INTO lr_wzo.*
      IF SQLCA.sqlcode THEN
         LET l_cmd = "wzo_file patchtemp FOREACH 資料時產生錯誤，wzo資料無更新"
         CALL gc_channel.write(l_cmd)
         EXIT FOREACH
      END IF

      INSERT INTO wds.wzo_file VALUES(lr_wzo.*)
      IF SQLCA.sqlcode THEN
         UPDATE wds.wzo_file SET wzo_file.* = lr_wzo.*
          WHERE wzo01 = lr_wzo.wzo01
         IF SQLCA.sqlcode THEN    
            LET l_cmd = "upload wzo_file data error:",SQLCA.sqlerrd[2]," ",lr_wzo.*
            CALL gc_channel.write(l_cmd)
            LET l_result = FALSE
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      ELSE
         LET li_count = li_count + SQLCA.sqlerrd[3]
      END IF
   END FOREACH
   DISPLAY "wzo_file 更新完畢，共更新 ",li_count,"筆資料"
   LET l_str = "wzo_file 更新完畢，共更新 ",li_count,"筆資料"
   CALL gs_channel.write(l_str)   #TQC-C90062

   DISPLAY "開始更新wzs_file資料"
   LET li_count = 0
   DECLARE wzs_o_curs CURSOR FOR
    SELECT * FROM patchtemp.wzs_file
     WHERE wzs01 IN (SELECT tbkey01 FROM patchtemp.psl_file 
                      WHERE tbname='wzz_file')
   FOREACH wzs_o_curs INTO lr_wzs.*
      IF SQLCA.sqlcode THEN
         LET l_cmd = "wzs_file patchtemp FOREACH 資料時產生錯誤，wzs資料無更新"
         CALL gc_channel.write(l_cmd)
         EXIT FOREACH
      END IF

      INSERT INTO wds.wzs_file VALUES(lr_wzs.*)
      IF SQLCA.sqlcode THEN
         UPDATE wds.wzs_file SET wzs_file.* = lr_wzs.*
          WHERE wzs01 = lr_wzs.wzs01 AND wzs02 = lr_wzs.wzs02
            AND wzs03 = lr_wzs.wzs03
         IF SQLCA.sqlcode THEN    
            LET l_cmd = "upload wzs_file data error:",SQLCA.sqlerrd[2]," ",lr_wzs.*
            CALL gc_channel.write(l_cmd)
            LET l_result = FALSE
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      ELSE
         LET li_count = li_count + SQLCA.sqlerrd[3]
      END IF
   END FOREACH
   DISPLAY "wsc_file 更新完畢，共更新 ",li_count,"筆資料"
   LET l_str = "wsc_file 更新完畢，共更新 ",li_count,"筆資料"
   CALL gs_channel.write(l_str)   #TQC-C90062

   DISPLAY "開始更新wzz_file資料"
   LET li_count = 0
   DECLARE wzz_o_curs CURSOR FOR
    SELECT * FROM patchtemp.wzz_file
     WHERE wzz01 IN (SELECT tbkey01 FROM patchtemp.psl_file 
                      WHERE tbname='wzz_file')
   FOREACH wzz_o_curs INTO lr_wzz.*
      IF SQLCA.sqlcode THEN
         LET l_cmd = "wzz_file patchtemp FOREACH 資料時產生錯誤，wzz資料無更新"
         CALL gc_channel.write(l_cmd)
         EXIT FOREACH
      END IF

      INSERT INTO wds.wzz_file VALUES(lr_wzz.*)
      IF SQLCA.sqlcode THEN
         UPDATE wds.wzz_file SET wzz_file.* = lr_wzz.*
          WHERE wzz01 = lr_wzz.wzz01
         IF SQLCA.sqlcode THEN    
            LET l_cmd = "upload wzz_file data error:",SQLCA.sqlerrd[2]," ",lr_wzz.*
            CALL gc_channel.write(l_cmd)
            LET l_result = FALSE
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      ELSE
         LET li_count = li_count + SQLCA.sqlerrd[3]
      END IF
   END FOREACH
   DISPLAY "wzz_file 更新完畢，共更新 ",li_count,"筆資料"
   LET l_str = "wzz_file 更新完畢，共更新 ",li_count,"筆資料"
   CALL gs_channel.write(l_str)   #TQC-C90062

   DISPLAY "開始更新wya_file資料"
   LET li_count = 0
   DECLARE wya_o_curs CURSOR FOR
    SELECT wya_file.* FROM patchtemp.wya_file,patchtemp.wyb_file
     WHERE wyb01 IN (SELECT tbkey01 FROM patchtemp.psl_file 
                      WHERE tbname='wyb_file')
       AND wya01 = wyb08
   FOREACH wya_o_curs INTO lr_wya.*
      IF SQLCA.sqlcode THEN
         LET l_cmd = "wya_file patchtemp FOREACH 資料時產生錯誤，wya資料無更新"
         CALL gc_channel.write(l_cmd)
         EXIT FOREACH
      END IF

      INSERT INTO wds.wya_file VALUES(lr_wya.*)
      IF SQLCA.sqlcode THEN
         UPDATE wds.wya_file SET wya_file.* = lr_wya.*
          WHERE wya01 = lr_wya.wya01 AND wya02 = lr_wya.wya02
            AND wya03 = lr_wya.wya03
         IF SQLCA.sqlcode THEN    
            LET l_cmd = "upload wya_file data error:",SQLCA.sqlerrd[2]," ",lr_wya.*
            CALL gc_channel.write(l_cmd)
            LET l_result = FALSE
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      ELSE
         LET li_count = li_count + SQLCA.sqlerrd[3]
      END IF
   END FOREACH
   DISPLAY "wya_file 更新完畢，共更新 ",li_count,"筆資料"
   LET l_str = "wya_file 更新完畢，共更新 ",li_count,"筆資料"
   CALL gs_channel.write(l_str)   #TQC-C90062

   DISPLAY "開始更新wyb_file資料"
   LET li_count = 0
   DECLARE wyb_o_curs CURSOR FOR
    SELECT * FROM patchtemp.wyb_file
     WHERE wyb01 IN (SELECT tbkey01 FROM patchtemp.psl_file 
                      WHERE tbname='wyb_file')
   FOREACH wyb_o_curs INTO lr_wyb.*
      IF SQLCA.sqlcode THEN
         LET l_cmd = "wyb_file patchtemp FOREACH 資料時產生錯誤，wyb資料無更新"
         CALL gc_channel.write(l_cmd)
         EXIT FOREACH
      END IF

      INSERT INTO wds.wyb_file VALUES(lr_wyb.*)
      IF SQLCA.sqlcode THEN
         UPDATE wds.wyb_file SET wyb_file.* = lr_wyb.*
          WHERE wyb01 = lr_wyb.wyb01 AND wyb02 = lr_wyb.wyb02
            AND wyb03 = lr_wyb.wyb03 AND wyb04 = lr_wyb.wyb04
            AND wyb05 = lr_wyb.wyb05 AND wyb06 = lr_wyb.wyb06
            AND wyb07 = lr_wyb.wyb07
         IF SQLCA.sqlcode THEN    
            LET l_cmd = "upload wyb_file data error:",SQLCA.sqlerrd[2]," ",lr_wyb.*
            CALL gc_channel.write(l_cmd)
            LET l_result = FALSE
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      ELSE
         LET li_count = li_count + SQLCA.sqlerrd[3]
      END IF
   END FOREACH
   DISPLAY "wyb_file 更新完畢，共更新 ",li_count,"筆資料"
   LET l_str = "wyb_file 更新完畢，共更新 ",li_count,"筆資料"
   CALL gs_channel.write(l_str)   #TQC-C90062

   DISPLAY "開始更新wyc_file資料"
   LET li_count = 0
   DECLARE wyc_o_curs CURSOR FOR
    SELECT * FROM patchtemp.wyc_file
     WHERE wyc01 IN (SELECT tbkey01 FROM patchtemp.psl_file 
                      WHERE tbname='wyc_file')
   FOREACH wyc_o_curs INTO lr_wyc.*
      IF SQLCA.sqlcode THEN
         LET l_cmd = "wyc_file patchtemp FOREACH 資料時產生錯誤，wyc資料無更新"
         CALL gc_channel.write(l_cmd)
         EXIT FOREACH
      END IF

      INSERT INTO wds.wyc_file VALUES(lr_wyc.*)
      IF SQLCA.sqlcode THEN
         UPDATE wds.wyc_file SET wyc_file.* = lr_wyc.*
          WHERE wyc01 = lr_wyc.wyc01
         IF SQLCA.sqlcode THEN    
            LET l_cmd = "upload wyc_file data error:",SQLCA.sqlerrd[2]," ",lr_wyc.*
            CALL gc_channel.write(l_cmd)
            LET l_result = FALSE
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      ELSE
         LET li_count = li_count + SQLCA.sqlerrd[3]
      END IF
   END FOREACH
   DISPLAY "wyc_file 更新完畢，共更新 ",li_count,"筆資料"
   LET l_str = "wyc_file 更新完畢，共更新 ",li_count,"筆資料"
   CALL gs_channel.write(l_str)   #TQC-C90062

   CALL gc_channel.close()
   CALL gs_channel.close()   #TQC-C90062 add

   RETURN l_result
END FUNCTION
