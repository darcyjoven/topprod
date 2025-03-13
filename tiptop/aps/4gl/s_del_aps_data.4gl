# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: s_del_aps_data.4gl
# Descriptions...: 刪除APS相關TABLE
# Date & Author..: 2009/11/10 By Mandy #FUN-9B0065
# Usage..........: CALL s_del_aps_data(p_plant,p_vzy01,p_vzy02)
# Input Parameter: p_plant     營運中心
# Input Parameter: p_vzy01     APS版本
# Input Parameter: p_vzy02     APS儲存版本
# Modify ........: NO:FUN-A30100 10/03/26 By Lilan 執行資料庫刪除時,少刪了vau_file、vmu_file  
# Modify.........: No.FUN-B50050 11/05/13 By Mandy---GP5.25 追版:以上為GP5.1 的單號---
# Modify.........: No.FUN-B80053 11/08/04 By fengrui  程式撰寫規範修正
# Modify.........: No.FUN-BC0040 11/12/14 By Mandy 資料庫刪除時,也需一併刪除vlq_file
# Modify.........: No.FUN-C20059 12/11/02 By Nina  執行資料庫刪除時,也需一併刪除voq_file
# MOdify.........: No.FUN-BC0114 12/11/30 By Nina  刪ERP端資料時，將判斷APS端的資料庫刪除OK的條件移除vzv07

DATABASE ds        

GLOBALS "../../config/top.global"   

FUNCTION s_del_aps_data(p_plant,p_vzy01,p_vzy02) #FUN-9B0065
DEFINE p_plant         LIKE vne_file.vne01
DEFINE p_vzy01         LIKE vne_file.vne02
DEFINE p_vzy02         LIKE vne_file.vne03
DEFINE l_vzv01         LIKE vzv_file.vzv01
DEFINE l_vzv02         LIKE vzv_file.vzv02
DEFINE l_i             LIKE type_file.num5   
DEFINE l_ze03          LIKE ze_file.ze03
DEFINE l_sql           STRING    
DEFINE g_show_msg      DYNAMIC ARRAY OF RECORD
       fld01           LIKE  type_file.chr20,
       fld02           LIKE  type_file.chr20,
       fld03           LIKE  type_file.chr20,
       fld04           LIKE  type_file.chr20,
       fld05           LIKE  type_file.chr100
                       END RECORD
  
   LET l_sql = "SELECT vzv01,vzv02 FROM vzv_file  ",
               " WHERE vzv00 = '",p_plant,"'",
               "   AND vzv01 = '",p_vzy01,"'",
               "   AND vzv04 = '90'",
               "   AND vzv06 = 'Y' "#,    #FUN-BC0114 mark
              #"   AND vzv07 = 'Y' "      #FUN-BC0114 mark
   IF p_vzy02 <> '0' THEN
       LET l_sql = l_sql CLIPPED," AND vzv02 = '",p_vzy02,"'"
   END IF
   PREPARE del_aps_data_pr FROM l_sql  
   DECLARE del_aps_data_cs CURSOR WITH HOLD FOR del_aps_data_pr
   IF SQLCA.sqlcode THEN
       CALL cl_err('Declare del_aps_data_cs',SQLCA.sqlcode,1)
       CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80053--add--
       EXIT PROGRAM
   END IF
   CALL cl_getmsg('aps-515',g_lang) RETURNING l_ze03 #ERP資料庫刪除
   LET l_i = 0
   FOREACH del_aps_data_cs INTO l_vzv01,l_vzv02
       IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
       END IF

       INSERT INTO vzv_file(vzv00,vzv01,vzv02,vzv04,
            vzv05,vzv06,vzv07,vzv08,vzvplant,vzvlegal) #FUN-B50050 add vzvplant,vzvlegal
       VALUES(p_plant,l_vzv01,l_vzv02,'95',
            l_ze03,'R','Y',g_user,g_plant,g_legal) #FUN-B50050 add vzvplant,vzvlegal
       IF STATUS THEN
          CALL cl_err3("ins","vzv_file",l_vzv01,'0',STATUS,"","",1)
          RETURN
       END IF

       UPDATE vzy_file
          SET vzy10 = 'I',    #I:TIPTOP刪除中
              vzy12 = sysdate
        WHERE vzy00 = g_plant
          AND vzy01 = l_vzv01
          AND vzy02 = l_vzv02
       IF SQLCA.SQLCODE OR SQLCA.sqlerrd[3] = 0 THEN
           CALL cl_err3('UPDATE','vzy_file','','',SQLCA.sqlcode,'','',1)
       END IF
       
       BEGIN WORK
       LET g_success = 'Y'
       
       
       #vzu_file==>
       LET l_i = l_i + 1 
       LET g_show_msg[l_i].fld01 = 'DELETE'
       LET g_show_msg[l_i].fld03 = 'vzu_file'
       LET g_show_msg[l_i].fld05 = 'APS Version:',l_vzv01 CLIPPED,'    ','Save Version:',l_vzv02 CLIPPED
       DELETE FROM vzu_file
        WHERE vzu00 = p_plant
          AND vzu01 = l_vzv01
          AND vzu02 = l_vzv02
       IF SQLCA.sqlcode THEN
           LET g_show_msg[l_i].fld02 = 'Error'
           LET g_show_msg[l_i].fld04 = SQLCA.sqlcode
           LET g_success = 'N'
       ELSE
           LET g_show_msg[l_i].fld02 = 'Success'
           LET g_show_msg[l_i].fld04 = SQLCA.sqlcode
       END IF
       
       #vzv_file==>
       LET l_i = l_i + 1 
       LET g_show_msg[l_i].fld01 = 'DELETE'
       LET g_show_msg[l_i].fld03 = 'vzv_file'
       LET g_show_msg[l_i].fld05 = 'APS Version:',l_vzv01 CLIPPED,'    ','Save Version:',l_vzv02 CLIPPED
       DELETE FROM vzv_file
        WHERE vzv00 = p_plant
          AND vzv01 = l_vzv01
          AND vzv02 = l_vzv02
       IF SQLCA.sqlcode THEN
           LET g_show_msg[l_i].fld02 = 'Error'
           LET g_show_msg[l_i].fld04 = SQLCA.sqlcode
           LET g_success = 'N'
       ELSE
           LET g_show_msg[l_i].fld02 = 'Success'
           LET g_show_msg[l_i].fld04 = SQLCA.sqlcode
       END IF
       
       #vla_file==>
       IF l_vzv02 = '0' THEN #代表從apss300執行
           LET l_i = l_i + 1 
           LET g_show_msg[l_i].fld01 = 'DELETE'
           LET g_show_msg[l_i].fld03 = 'vla_file'
           LET g_show_msg[l_i].fld05 = 'APS Version:',l_vzv01 CLIPPED,'    ','Save Version:',l_vzv02 CLIPPED
           DELETE FROM vla_file
            WHERE vla01 = l_vzv01
           IF SQLCA.sqlcode THEN
               LET g_show_msg[l_i].fld02 = 'Error'
               LET g_show_msg[l_i].fld04 = SQLCA.sqlcode
               LET g_success = 'N'
           ELSE
               LET g_show_msg[l_i].fld02 = 'Success'
               LET g_show_msg[l_i].fld04 = SQLCA.sqlcode
           END IF
           #FUN-BC0040---add----str---
           LET l_i = l_i + 1 
           LET g_show_msg[l_i].fld01 = 'DELETE'
           LET g_show_msg[l_i].fld03 = 'vlq_file'
           LET g_show_msg[l_i].fld05 = 'APS Version:',l_vzv01 CLIPPED,'    ','Save Version:',l_vzv02 CLIPPED
           DELETE FROM vlq_file
            WHERE vlq01 = l_vzv01
           IF SQLCA.sqlcode THEN
               LET g_show_msg[l_i].fld02 = 'Error'
               LET g_show_msg[l_i].fld04 = SQLCA.sqlcode
               LET g_success = 'N'
           ELSE
               LET g_show_msg[l_i].fld02 = 'Success'
               LET g_show_msg[l_i].fld04 = SQLCA.sqlcode
           END IF
           #FUN-BC0040---add----end---

      #FUN-A30100 add---str---
           DELETE FROM vmu_file WHERE vmu01=l_vzv01
           IF SQLCA.sqlcode THEN
              LET g_show_msg[l_i].fld02 = 'Error'
              LET g_show_msg[l_i].fld04 = SQLCA.sqlcode
              LET g_success = 'N'
           ELSE
              LET g_show_msg[l_i].fld02 = 'Success'
              LET g_show_msg[l_i].fld04 = SQLCA.sqlcode
           END IF

           DELETE FROM vau_file WHERE vau01=l_vzv01
           IF SQLCA.sqlcode THEN
              LET g_show_msg[l_i].fld02 = 'Error'
              LET g_show_msg[l_i].fld04 = SQLCA.sqlcode
              LET g_success = 'N'
           ELSE
              LET g_show_msg[l_i].fld02 = 'Success'
              LET g_show_msg[l_i].fld04 = SQLCA.sqlcode
           END IF
       ELSE
          DELETE FROM vmu_file
           WHERE vmu01=l_vzv01
             AND vmu02=l_vzv02
          IF SQLCA.sqlcode THEN
             LET g_show_msg[l_i].fld02 = 'Error'
             LET g_show_msg[l_i].fld04 = SQLCA.sqlcode
             LET g_success = 'N'
          ELSE
             LET g_show_msg[l_i].fld02 = 'Success'
             LET g_show_msg[l_i].fld04 = SQLCA.sqlcode
          END IF

          DELETE FROM vau_file
           WHERE vau01=l_vzv01
             AND vau02=l_vzv02
          IF SQLCA.sqlcode THEN
             LET g_show_msg[l_i].fld02 = 'Error'
             LET g_show_msg[l_i].fld04 = SQLCA.sqlcode
             LET g_success = 'N'
          ELSE
             LET g_show_msg[l_i].fld02 = 'Success'
             LET g_show_msg[l_i].fld04 = SQLCA.sqlcode
          END IF
      #FUN-A30100 add---end---
       END IF
      
       #FUN-C20059---add----str---
       #voq_file==>
       LET l_i = l_i + 1
       LET g_show_msg[l_i].fld01 = 'DELETE'
       LET g_show_msg[l_i].fld03 = 'voq_file'
       LET g_show_msg[l_i].fld05 = 'APS Version:',l_vzv01 CLIPPED,'    ','Save Version:',l_vzv02 CLIPPED
       DELETE FROM voq_file
        WHERE voq00 = p_plant
          AND voq01 = l_vzv01
          AND voq02 = l_vzv02
       IF SQLCA.sqlcode THEN
           LET g_show_msg[l_i].fld02 = 'Error'
           LET g_show_msg[l_i].fld04 = SQLCA.sqlcode
           LET g_success = 'N'
       ELSE
           LET g_show_msg[l_i].fld02 = 'Success'
           LET g_show_msg[l_i].fld04 = SQLCA.sqlcode
       END IF
       #FUN-C20059---add----end---
 
       #vlb_file==>
       LET l_i = l_i + 1 
       LET g_show_msg[l_i].fld01 = 'DELETE'
       LET g_show_msg[l_i].fld03 = 'vlb_file'
       LET g_show_msg[l_i].fld05 = 'APS Version:',l_vzv01 CLIPPED,'    ','Save Version:',l_vzv02 CLIPPED
       DELETE FROM vlb_file
        WHERE vlb01 = l_vzv01
          AND vlb02 = l_vzv02
       IF SQLCA.sqlcode THEN
           LET g_show_msg[l_i].fld02 = 'Error'
           LET g_show_msg[l_i].fld04 = SQLCA.sqlcode
           LET g_success = 'N'
       ELSE
           LET g_show_msg[l_i].fld02 = 'Success'
           LET g_show_msg[l_i].fld04 = SQLCA.sqlcode
       END IF

       #vlc_file==>
       LET l_i = l_i + 1 
       LET g_show_msg[l_i].fld01 = 'DELETE'
       LET g_show_msg[l_i].fld03 = 'vlc_file'
       LET g_show_msg[l_i].fld05 = 'APS Version:',l_vzv01 CLIPPED,'    ','Save Version:',l_vzv02 CLIPPED
       DELETE FROM vlc_file
        WHERE vlc01 = l_vzv01
          AND vlc02 = l_vzv02
       IF SQLCA.sqlcode THEN
           LET g_show_msg[l_i].fld02 = 'Error'
           LET g_show_msg[l_i].fld04 = SQLCA.sqlcode
           LET g_success = 'N'
       ELSE
           LET g_show_msg[l_i].fld02 = 'Success'
           LET g_show_msg[l_i].fld04 = SQLCA.sqlcode
       END IF
       
       #vld_file==>
       LET l_i = l_i + 1 
       LET g_show_msg[l_i].fld01 = 'DELETE'
       LET g_show_msg[l_i].fld03 = 'vld_file'
       LET g_show_msg[l_i].fld05 = 'APS Version:',l_vzv01 CLIPPED,'    ','Save Version:',l_vzv02 CLIPPED
       DELETE FROM vld_file
        WHERE vld01 = l_vzv01
          AND vld02 = l_vzv02
       IF SQLCA.sqlcode THEN
           LET g_show_msg[l_i].fld02 = 'Error'
           LET g_show_msg[l_i].fld04 = SQLCA.sqlcode
           LET g_success = 'N'
       ELSE
           LET g_show_msg[l_i].fld02 = 'Success'
           LET g_show_msg[l_i].fld04 = SQLCA.sqlcode
       END IF

       #vle_file==>
       LET l_i = l_i + 1 
       LET g_show_msg[l_i].fld01 = 'DELETE'
       LET g_show_msg[l_i].fld03 = 'vle_file'
       LET g_show_msg[l_i].fld05 = 'APS Version:',l_vzv01 CLIPPED,'    ','Save Version:',l_vzv02 CLIPPED
       DELETE FROM vle_file
        WHERE vle01 = l_vzv01
          AND vle02 = l_vzv02
       IF SQLCA.sqlcode THEN
           LET g_show_msg[l_i].fld02 = 'Error'
           LET g_show_msg[l_i].fld04 = SQLCA.sqlcode
           LET g_success = 'N'
       ELSE
           LET g_show_msg[l_i].fld02 = 'Success'
           LET g_show_msg[l_i].fld04 = SQLCA.sqlcode
       END IF

       #vlf_file==>
       LET l_i = l_i + 1 
       LET g_show_msg[l_i].fld01 = 'DELETE'
       LET g_show_msg[l_i].fld03 = 'vlf_file'
       LET g_show_msg[l_i].fld05 = 'APS Version:',l_vzv01 CLIPPED,'    ','Save Version:',l_vzv02 CLIPPED
       DELETE FROM vlf_file
        WHERE vlf01 = l_vzv01
          AND vlf02 = l_vzv02
       IF SQLCA.sqlcode THEN
           LET g_show_msg[l_i].fld02 = 'Error'
           LET g_show_msg[l_i].fld04 = SQLCA.sqlcode
           LET g_success = 'N'
       ELSE
           LET g_show_msg[l_i].fld02 = 'Success'
           LET g_show_msg[l_i].fld04 = SQLCA.sqlcode
       END IF

       #vli_file==>
       LET l_i = l_i + 1 
       LET g_show_msg[l_i].fld01 = 'DELETE'
       LET g_show_msg[l_i].fld03 = 'vli_file'
       LET g_show_msg[l_i].fld05 = 'APS Version:',l_vzv01 CLIPPED,'    ','Save Version:',l_vzv02 CLIPPED
       DELETE FROM vli_file
        WHERE vli01 = l_vzv01
          AND vli02 = l_vzv02
       IF SQLCA.sqlcode THEN
           LET g_show_msg[l_i].fld02 = 'Error'
           LET g_show_msg[l_i].fld04 = SQLCA.sqlcode
           LET g_success = 'N'
       ELSE
           LET g_show_msg[l_i].fld02 = 'Success'
           LET g_show_msg[l_i].fld04 = SQLCA.sqlcode
       END IF

       #vlz_file==>
       LET l_i = l_i + 1 
       LET g_show_msg[l_i].fld01 = 'DELETE'
       LET g_show_msg[l_i].fld03 = 'vlz_file'
       LET g_show_msg[l_i].fld05 = 'APS Version:',l_vzv01 CLIPPED,'    ','Save Version:',l_vzv02 CLIPPED
       DELETE FROM vlz_file
        WHERE vlz01 = l_vzv01
          AND vlz02 = l_vzv02
       IF SQLCA.sqlcode THEN
           LET g_show_msg[l_i].fld02 = 'Error'
           LET g_show_msg[l_i].fld04 = SQLCA.sqlcode
           LET g_success = 'N'
       ELSE
           LET g_show_msg[l_i].fld02 = 'Success'
           LET g_show_msg[l_i].fld04 = SQLCA.sqlcode
       END IF

       #vzz_file==>
       LET l_i = l_i + 1 
       LET g_show_msg[l_i].fld01 = 'DELETE'
       LET g_show_msg[l_i].fld03 = 'vzz_file'
       LET g_show_msg[l_i].fld05 = 'APS Version:',l_vzv01 CLIPPED,'    ','Save Version:',l_vzv02 CLIPPED
       DELETE FROM vzz_file
        WHERE vzz00 = p_plant
          AND vzz01 = l_vzv01
          AND vzz02 = l_vzv02
       IF SQLCA.sqlcode THEN
           LET g_show_msg[l_i].fld02 = 'Error'
           LET g_show_msg[l_i].fld04 = SQLCA.sqlcode
           LET g_success = 'N'
       ELSE
           LET g_show_msg[l_i].fld02 = 'Success'
           LET g_show_msg[l_i].fld04 = SQLCA.sqlcode
       END IF

       #voa_file==>
       LET l_i = l_i + 1 
       LET g_show_msg[l_i].fld01 = 'DELETE'
       LET g_show_msg[l_i].fld03 = 'voa_file'
       LET g_show_msg[l_i].fld05 = 'APS Version:',l_vzv01 CLIPPED,'    ','Save Version:',l_vzv02 CLIPPED
       DELETE FROM voa_file
        WHERE voa00 = p_plant
          AND voa01 = l_vzv01
          AND voa02 = l_vzv02
       IF SQLCA.sqlcode THEN
           LET g_show_msg[l_i].fld02 = 'Error'
           LET g_show_msg[l_i].fld04 = SQLCA.sqlcode
           LET g_success = 'N'
       ELSE
           LET g_show_msg[l_i].fld02 = 'Success'
           LET g_show_msg[l_i].fld04 = SQLCA.sqlcode
       END IF

       #vob_file==>
       LET l_i = l_i + 1 
       LET g_show_msg[l_i].fld01 = 'DELETE'
       LET g_show_msg[l_i].fld03 = 'vob_file'
       LET g_show_msg[l_i].fld05 = 'APS Version:',l_vzv01 CLIPPED,'    ','Save Version:',l_vzv02 CLIPPED
       DELETE FROM vob_file
        WHERE vob00 = p_plant
          AND vob01 = l_vzv01
          AND vob02 = l_vzv02
       IF SQLCA.sqlcode THEN
           LET g_show_msg[l_i].fld02 = 'Error'
           LET g_show_msg[l_i].fld04 = SQLCA.sqlcode
           LET g_success = 'N'
       ELSE
           LET g_show_msg[l_i].fld02 = 'Success'
           LET g_show_msg[l_i].fld04 = SQLCA.sqlcode
       END IF

       #voc_file==>
       LET l_i = l_i + 1 
       LET g_show_msg[l_i].fld01 = 'DELETE'
       LET g_show_msg[l_i].fld03 = 'voc_file'
       LET g_show_msg[l_i].fld05 = 'APS Version:',l_vzv01 CLIPPED,'    ','Save Version:',l_vzv02 CLIPPED
       DELETE FROM voc_file
        WHERE voc00 = p_plant
          AND voc01 = l_vzv01
          AND voc02 = l_vzv02
       IF SQLCA.sqlcode THEN
           LET g_show_msg[l_i].fld02 = 'Error'
           LET g_show_msg[l_i].fld04 = SQLCA.sqlcode
           LET g_success = 'N'
       ELSE
           LET g_show_msg[l_i].fld02 = 'Success'
           LET g_show_msg[l_i].fld04 = SQLCA.sqlcode
       END IF

       #vod_file==>
       LET l_i = l_i + 1 
       LET g_show_msg[l_i].fld01 = 'DELETE'
       LET g_show_msg[l_i].fld03 = 'vod_file'
       LET g_show_msg[l_i].fld05 = 'APS Version:',l_vzv01 CLIPPED,'    ','Save Version:',l_vzv02 CLIPPED
       DELETE FROM vod_file
        WHERE vod00 = p_plant
          AND vod01 = l_vzv01
          AND vod02 = l_vzv02
       IF SQLCA.sqlcode THEN
           LET g_show_msg[l_i].fld02 = 'Error'
           LET g_show_msg[l_i].fld04 = SQLCA.sqlcode
           LET g_success = 'N'
       ELSE
           LET g_show_msg[l_i].fld02 = 'Success'
           LET g_show_msg[l_i].fld04 = SQLCA.sqlcode
       END IF

       #voe_file==>
       LET l_i = l_i + 1 
       LET g_show_msg[l_i].fld01 = 'DELETE'
       LET g_show_msg[l_i].fld03 = 'voe_file'
       LET g_show_msg[l_i].fld05 = 'APS Version:',l_vzv01 CLIPPED,'    ','Save Version:',l_vzv02 CLIPPED
       DELETE FROM voe_file
        WHERE voe00 = p_plant
          AND voe01 = l_vzv01
          AND voe02 = l_vzv02
       IF SQLCA.sqlcode THEN
           LET g_show_msg[l_i].fld02 = 'Error'
           LET g_show_msg[l_i].fld04 = SQLCA.sqlcode
           LET g_success = 'N'
       ELSE
           LET g_show_msg[l_i].fld02 = 'Success'
           LET g_show_msg[l_i].fld04 = SQLCA.sqlcode
       END IF

       #vof_file==>
       LET l_i = l_i + 1 
       LET g_show_msg[l_i].fld01 = 'DELETE'
       LET g_show_msg[l_i].fld03 = 'vof_file'
       LET g_show_msg[l_i].fld05 = 'APS Version:',l_vzv01 CLIPPED,'    ','Save Version:',l_vzv02 CLIPPED
       DELETE FROM vof_file
        WHERE vof00 = p_plant
          AND vof01 = l_vzv01
          AND vof02 = l_vzv02
       IF SQLCA.sqlcode THEN
           LET g_show_msg[l_i].fld02 = 'Error'
           LET g_show_msg[l_i].fld04 = SQLCA.sqlcode
           LET g_success = 'N'
       ELSE
           LET g_show_msg[l_i].fld02 = 'Success'
           LET g_show_msg[l_i].fld04 = SQLCA.sqlcode
       END IF

       #vog_file==>
       LET l_i = l_i + 1 
       LET g_show_msg[l_i].fld01 = 'DELETE'
       LET g_show_msg[l_i].fld03 = 'vog_file'
       LET g_show_msg[l_i].fld05 = 'APS Version:',l_vzv01 CLIPPED,'    ','Save Version:',l_vzv02 CLIPPED
       DELETE FROM vog_file
        WHERE vog00 = p_plant
          AND vog01 = l_vzv01
          AND vog02 = l_vzv02
       IF SQLCA.sqlcode THEN
           LET g_show_msg[l_i].fld02 = 'Error'
           LET g_show_msg[l_i].fld04 = SQLCA.sqlcode
           LET g_success = 'N'
       ELSE
           LET g_show_msg[l_i].fld02 = 'Success'
           LET g_show_msg[l_i].fld04 = SQLCA.sqlcode
       END IF

       #voh_file==>
       LET l_i = l_i + 1 
       LET g_show_msg[l_i].fld01 = 'DELETE'
       LET g_show_msg[l_i].fld03 = 'voh_file'
       LET g_show_msg[l_i].fld05 = 'APS Version:',l_vzv01 CLIPPED,'    ','Save Version:',l_vzv02 CLIPPED
       DELETE FROM voh_file
        WHERE voh00 = p_plant
          AND voh01 = l_vzv01
          AND voh02 = l_vzv02
       IF SQLCA.sqlcode THEN
           LET g_show_msg[l_i].fld02 = 'Error'
           LET g_show_msg[l_i].fld04 = SQLCA.sqlcode
           LET g_success = 'N'
       ELSE
           LET g_show_msg[l_i].fld02 = 'Success'
           LET g_show_msg[l_i].fld04 = SQLCA.sqlcode
       END IF

       #voi_file==>
       LET l_i = l_i + 1 
       LET g_show_msg[l_i].fld01 = 'DELETE'
       LET g_show_msg[l_i].fld03 = 'voi_file'
       LET g_show_msg[l_i].fld05 = 'APS Version:',l_vzv01 CLIPPED,'    ','Save Version:',l_vzv02 CLIPPED
       DELETE FROM voi_file
        WHERE voi00 = p_plant
          AND voi01 = l_vzv01
          AND voi02 = l_vzv02
       IF SQLCA.sqlcode THEN
           LET g_show_msg[l_i].fld02 = 'Error'
           LET g_show_msg[l_i].fld04 = SQLCA.sqlcode
           LET g_success = 'N'
       ELSE
           LET g_show_msg[l_i].fld02 = 'Success'
           LET g_show_msg[l_i].fld04 = SQLCA.sqlcode
       END IF

       #voj_file==>
       LET l_i = l_i + 1 
       LET g_show_msg[l_i].fld01 = 'DELETE'
       LET g_show_msg[l_i].fld03 = 'voj_file'
       LET g_show_msg[l_i].fld05 = 'APS Version:',l_vzv01 CLIPPED,'    ','Save Version:',l_vzv02 CLIPPED
       DELETE FROM voj_file
        WHERE voj00 = p_plant
          AND voj01 = l_vzv01
          AND voj02 = l_vzv02
       IF SQLCA.sqlcode THEN
           LET g_show_msg[l_i].fld02 = 'Error'
           LET g_show_msg[l_i].fld04 = SQLCA.sqlcode
           LET g_success = 'N'
       ELSE
           LET g_show_msg[l_i].fld02 = 'Success'
           LET g_show_msg[l_i].fld04 = SQLCA.sqlcode
       END IF

       #vok_file==>
       LET l_i = l_i + 1 
       LET g_show_msg[l_i].fld01 = 'DELETE'
       LET g_show_msg[l_i].fld03 = 'vok_file'
       LET g_show_msg[l_i].fld05 = 'APS Version:',l_vzv01 CLIPPED,'    ','Save Version:',l_vzv02 CLIPPED
       DELETE FROM vok_file
        WHERE vok00 = p_plant
          AND vok01 = l_vzv01
          AND vok02 = l_vzv02
       IF SQLCA.sqlcode THEN
           LET g_show_msg[l_i].fld02 = 'Error'
           LET g_show_msg[l_i].fld04 = SQLCA.sqlcode
           LET g_success = 'N'
       ELSE
           LET g_show_msg[l_i].fld02 = 'Success'
           LET g_show_msg[l_i].fld04 = SQLCA.sqlcode
       END IF

       #vol_file==>
       LET l_i = l_i + 1 
       LET g_show_msg[l_i].fld01 = 'DELETE'
       LET g_show_msg[l_i].fld03 = 'vol_file'
       LET g_show_msg[l_i].fld05 = 'APS Version:',l_vzv01 CLIPPED,'    ','Save Version:',l_vzv02 CLIPPED
       DELETE FROM vol_file
        WHERE vol00 = p_plant
          AND vol01 = l_vzv01
          AND vol02 = l_vzv02
       IF SQLCA.sqlcode THEN
           LET g_show_msg[l_i].fld02 = 'Error'
           LET g_show_msg[l_i].fld04 = SQLCA.sqlcode
           LET g_success = 'N'
       ELSE
           LET g_show_msg[l_i].fld02 = 'Success'
           LET g_show_msg[l_i].fld04 = SQLCA.sqlcode
       END IF

       #vom_file==>
       LET l_i = l_i + 1 
       LET g_show_msg[l_i].fld01 = 'DELETE'
       LET g_show_msg[l_i].fld03 = 'vom_file'
       LET g_show_msg[l_i].fld05 = 'APS Version:',l_vzv01 CLIPPED,'    ','Save Version:',l_vzv02 CLIPPED
       DELETE FROM vom_file
        WHERE vom00 = p_plant
          AND vom01 = l_vzv01
          AND vom02 = l_vzv02
       IF SQLCA.sqlcode THEN
           LET g_show_msg[l_i].fld02 = 'Error'
           LET g_show_msg[l_i].fld04 = SQLCA.sqlcode
           LET g_success = 'N'
       ELSE
           LET g_show_msg[l_i].fld02 = 'Success'
           LET g_show_msg[l_i].fld04 = SQLCA.sqlcode
       END IF

       #von_file==>
       LET l_i = l_i + 1 
       LET g_show_msg[l_i].fld01 = 'DELETE'
       LET g_show_msg[l_i].fld03 = 'von_file'
       LET g_show_msg[l_i].fld05 = 'APS Version:',l_vzv01 CLIPPED,'    ','Save Version:',l_vzv02 CLIPPED
       DELETE FROM von_file
        WHERE von00 = p_plant
          AND von01 = l_vzv01
          AND von02 = l_vzv02
       IF SQLCA.sqlcode THEN
           LET g_show_msg[l_i].fld02 = 'Error'
           LET g_show_msg[l_i].fld04 = SQLCA.sqlcode
           LET g_success = 'N'
       ELSE
           LET g_show_msg[l_i].fld02 = 'Success'
           LET g_show_msg[l_i].fld04 = SQLCA.sqlcode
       END IF

       #voo_file==>
       LET l_i = l_i + 1 
       LET g_show_msg[l_i].fld01 = 'DELETE'
       LET g_show_msg[l_i].fld03 = 'voo_file'
       LET g_show_msg[l_i].fld05 = 'APS Version:',l_vzv01 CLIPPED,'    ','Save Version:',l_vzv02 CLIPPED
       DELETE FROM voo_file
        WHERE voo00 = p_plant
          AND voo01 = l_vzv01
          AND voo02 = l_vzv02
       IF SQLCA.sqlcode THEN
           LET g_show_msg[l_i].fld02 = 'Error'
           LET g_show_msg[l_i].fld04 = SQLCA.sqlcode
           LET g_success = 'N'
       ELSE
           LET g_show_msg[l_i].fld02 = 'Success'
           LET g_show_msg[l_i].fld04 = SQLCA.sqlcode
       END IF

       #vop_file==>
       LET l_i = l_i + 1 
       LET g_show_msg[l_i].fld01 = 'DELETE'
       LET g_show_msg[l_i].fld03 = 'vop_file'
       LET g_show_msg[l_i].fld05 = 'APS Version:',l_vzv01 CLIPPED,'    ','Save Version:',l_vzv02 CLIPPED
       DELETE FROM vop_file
        WHERE vop00 = p_plant
          AND vop01 = l_vzv01
          AND vop02 = l_vzv02
       IF SQLCA.sqlcode THEN
           LET g_show_msg[l_i].fld02 = 'Error'
           LET g_show_msg[l_i].fld04 = SQLCA.sqlcode
           LET g_success = 'N'
       ELSE
           LET g_show_msg[l_i].fld02 = 'Success'
           LET g_show_msg[l_i].fld04 = SQLCA.sqlcode
       END IF

       IF g_success = 'Y' THEN
           COMMIT WORK
           UPDATE vzy_file
              SET vzy10 = 'J',    #J:TIPTOP刪除完成
                  vzy12 = sysdate
            WHERE vzy00 = g_plant
              AND vzy01 = l_vzv01
              AND vzy02 = l_vzv02
           IF SQLCA.SQLCODE OR SQLCA.sqlerrd[3] = 0 THEN
               CALL cl_err3('UPDATE','vzy_file','','',SQLCA.sqlcode,'','',1)
           END IF
       ELSE
           ROLLBACK WORK
           INSERT INTO vzv_file(vzv00,vzv01,vzv02,vzv04,
                vzv05,vzv06,vzv07,vzv08,vzvplant,vzvlegal) #FUN-B50050 add vzvplant,vzvlegal
           VALUES(p_plant,l_vzv01,l_vzv02,'95',
                l_ze03,'F','N',g_user,g_plant,g_legal) #FUN-B50050 add vzvplant,vzvlegal
           IF STATUS THEN
               CALL cl_err3("ins","vzv_file",l_vzv01,'0',STATUS,"","",1)
           END IF
           UPDATE vzy_file
              SET vzy10 = 'K',    #K:TIPTOP刪除失敗
                  vzy12 = sysdate
            WHERE vzy00 = g_plant
              AND vzy01 = l_vzv01
              AND vzy02 = l_vzv02
           IF SQLCA.SQLCODE OR SQLCA.sqlerrd[3] = 0 THEN
               CALL cl_err3('UPDATE','vzy_file','','',SQLCA.sqlcode,'','',1)
           END IF
       END IF
   END FOREACH
   CALL cl_err('','agl-112',1) #資料處理結束
  #CALL cl_show_array(base.TypeInfo.create(g_show_msg),'','')
END FUNCTION
#FUN-B50050
