/*
================================================================================
檔案代號:ruu_file
檔案名稱:盘点清单单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table ruu_file
(
ruu01       varchar2(20) DEFAULT ' ' NOT NULL, /*盘点清单号*/
ruu02       varchar2(20),            /*所属盘点计划                           */
ruu03       date,                    /*盘点日期                               */
ruu04       varchar2(10),            /*盘点仓库                               */
ruu05       varchar2(10),            /*盘点人员                               */
ruu06       varchar2(255),           /*備注                                   */
ruu900      varchar2(1),             /*状态码                                 */
                                     /*Status Code                            */
                                     /*0:Open 1:Confirmed 2.create pan        */
ruuacti     varchar2(1),             /*资料有效码                             */
ruucond     date,                    /*审核时间                               */
ruuconf     varchar2(1),             /*审核码                                 */
ruucont     varchar2(8),             /*审核时间                               */
ruuconu     varchar2(10),            /*审核人员                               */
ruucrat     date,                    /*资料创建日                             */
ruudate     date,                    /*最近更改日                             */
ruugrup     varchar2(10),            /*资料所有部门                           */
ruulegal    varchar2(10) NOT NULL,   /*所属法人                               */
ruumodu     varchar2(10),            /*资料更改者                             */
ruuplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
ruuuser     varchar2(10),            /*资料所有者                             */
ruuoriu     varchar2(10),            /*资料建立者                             */
ruuorig     varchar2(10)             /*资料建立部门                           */
);

alter table ruu_file add  constraint ruu_pk primary key  (ruu01) enable validate;
grant select on ruu_file to tiptopgp;
grant update on ruu_file to tiptopgp;
grant delete on ruu_file to tiptopgp;
grant insert on ruu_file to tiptopgp;
grant index on ruu_file to public;
grant select on ruu_file to ods;
