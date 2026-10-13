/*
================================================================================
檔案代號:ksf_file
檔案名稱:制造通知单单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table ksf_file
(
ksf01       varchar2(20) NOT NULL,   /*制造通知单                             */
                                     /*製造通知單                             */
ksf02       varchar2(255),           /*说明                                   */
                                     /*說明                                   */
ksf03       varchar2(1),             /*No Use                                 */
ksf04       varchar2(1),             /*No Use                                 */
ksf05       varchar2(20),            /*参考单号                               */
ksf06       varchar2(1),             /*No Use                                 */
ksf07       varchar2(1),             /*No Use                                 */
ksfconf     varchar2(1),             /*确认码                                 */
                                     /*確認碼(Y/N/X)                          */
ksfuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
ksfdate     date,                    /*资料录入日                             */
                                     /*資料輸入日                             */
ksfmodu     varchar2(10) DEFAULT ' ',/*最近更改者                             */
                                     /*最近修改者                             */
ksfmodd     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
ksf08       varchar2(10),            /*部门                                   */
ksfplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
ksflegal    varchar2(10) NOT NULL,   /*所属法人                               */
ksforiu     varchar2(10),            /*资料建立者                             */
ksforig     varchar2(10),            /*资料建立部门                           */
ksf09       varchar2(1) DEFAULT '0' NOT NULL, /*签核状况*/
ksf10       varchar2(10),            /*人员编号                               */
ksfmksg     varchar2(1) DEFAULT 'N' NOT NULL /*是否签核*/
);

alter table ksf_file add  constraint ksf_pk primary key  (ksf01) enable validate;
grant select on ksf_file to tiptopgp;
grant update on ksf_file to tiptopgp;
grant delete on ksf_file to tiptopgp;
grant insert on ksf_file to tiptopgp;
grant index on ksf_file to public;
grant select on ksf_file to ods;
