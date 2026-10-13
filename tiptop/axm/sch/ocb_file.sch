/*
================================================================================
檔案代號:ocb_file
檔案名稱:关系人可冲销之厂商编号
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ocb_file
(
ocb01       varchar2(10) NOT NULL,   /*客户编号                               */
                                     /*客戶編號                               */
ocb02       varchar2(10) NOT NULL,   /*营运中心编号                           */
                                     /*Plant No.                              */
ocb03       varchar2(10) NOT NULL,   /*厂商编号                               */
                                     /*廠商編號                               */
ocb04       varchar2(1),             /*No Use                                 */
ocb05       varchar2(1),             /*No Use                                 */
ocbacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
ocbuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
ocbgrup     varchar2(10),            /*资料所有部门                           */
                                     /*資料所有部門                           */
ocbmodu     varchar2(10),            /*资料更改者                             */
                                     /*資料修改者                             */
ocbdate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
ocborig     varchar2(10),            /*资料建立部门                           */
ocboriu     varchar2(10)             /*资料建立者                             */
);

alter table ocb_file add  constraint ocb_pk primary key  (ocb01,ocb02,ocb03) enable validate;
grant select on ocb_file to tiptopgp;
grant update on ocb_file to tiptopgp;
grant delete on ocb_file to tiptopgp;
grant insert on ocb_file to tiptopgp;
grant index on ocb_file to public;
grant select on ocb_file to ods;
