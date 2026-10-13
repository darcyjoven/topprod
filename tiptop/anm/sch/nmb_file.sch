/*
================================================================================
檔案代號:nmb_file
檔案名稱:银行存款类型档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table nmb_file
(
nmb01       varchar2(4) NOT NULL,    /*银行存款类型                           */
                                     /*銀行存款類別                           */
nmb02       varchar2(80),            /*银行存款类型名称                       */
                                     /*銀行存款類別名稱                       */
nmbacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
                                     /*系統維護                               */
nmbuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
                                     /*系統維護                               */
nmbgrup     varchar2(10),            /*资料所有群                             */
                                     /*資料所有群                             */
                                     /*系統維護                               */
nmbmodu     varchar2(10),            /*资料更改者                             */
                                     /*資料更改者                             */
                                     /*系統維護                               */
nmbdate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
                                     /*系統維護                               */
nmborig     varchar2(10),            /*资料建立部门                           */
nmboriu     varchar2(10)             /*资料建立者                             */
);

alter table nmb_file add  constraint nmb_pk primary key  (nmb01) enable validate;
grant select on nmb_file to tiptopgp;
grant update on nmb_file to tiptopgp;
grant delete on nmb_file to tiptopgp;
grant insert on nmb_file to tiptopgp;
grant index on nmb_file to public;
grant select on nmb_file to ods;
