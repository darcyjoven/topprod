/*
================================================================================
檔案代號:gie_file
檔案名稱:设备购置预算档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table gie_file
(
gie01       varchar2(10) NOT NULL,   /*预算编号                               */
                                     /*預算編號                               */
gie02       varchar2(4) NOT NULL,    /*主类型编号                             */
                                     /*主類別編號                             */
gie03       varchar2(10) NOT NULL,   /*部门编号                               */
                                     /*部門編號                               */
gie04       number(5) NOT NULL,      /*年度　　　　                           */
gie05       varchar2(80) NOT NULL,   /*设备名称                               */
                                     /*設備名稱                               */
gie06       number(5) NOT NULL,      /*期别                                   */
                                     /*期別                                   */
gie07       number(20,6),            /*单价                                   */
                                     /*單價                                   */
gie08       varchar2(4),             /*币种                                   */
                                     /*幣別                                   */
gie09       number(15,3),            /*数量                                   */
                                     /*數量                                   */
gie10       number(20,6),            /*金额                                   */
                                     /*金額                                   */
gie11       varchar2(1),             /*No Use                                 */
gieacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
gieuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
giegrup     varchar2(10),            /*资料所有部门                           */
                                     /*資料所有部門                           */
giemodu     varchar2(10),            /*资料更改者                             */
                                     /*資料修改者                             */
giedate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
gieorig     varchar2(10),            /*资料建立部门                           */
gieoriu     varchar2(10)             /*资料建立者                             */
);

alter table gie_file add  constraint gie_pk primary key  (gie01,gie02,gie03,gie04,gie05,gie06) enable validate;
grant select on gie_file to tiptopgp;
grant update on gie_file to tiptopgp;
grant delete on gie_file to tiptopgp;
grant insert on gie_file to tiptopgp;
grant index on gie_file to public;
grant select on gie_file to ods;
