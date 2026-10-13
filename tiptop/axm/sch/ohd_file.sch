/*
================================================================================
檔案代號:ohd_file
檔案名稱:客诉单号单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table ohd_file
(
ohd01       varchar2(20) NOT NULL,   /*客诉单号                               */
                                     /*客訴單號                               */
ohd02       number(5) NOT NULL,      /*行序                                   */
ohd03       varchar2(255),           /*客诉内容说明                           */
                                     /*客訴內容說明                           */
ohd04       varchar2(1),             /*No Use                                 */
ohd05       varchar2(1),             /*No Use                                 */
ohdplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
ohdlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table ohd_file add  constraint ohd_pk primary key  (ohd01,ohd02) enable validate;
grant select on ohd_file to tiptopgp;
grant update on ohd_file to tiptopgp;
grant delete on ohd_file to tiptopgp;
grant insert on ohd_file to tiptopgp;
grant index on ohd_file to public;
grant select on ohd_file to ods;
