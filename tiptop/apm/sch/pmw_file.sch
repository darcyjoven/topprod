/*
================================================================================
檔案代號:pmw_file
檔案名稱:采购料件询价单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table pmw_file
(
pmw01       varchar2(20) NOT NULL,   /*询价单号                               */
                                     /*詢價單號                               */
pmw03       varchar2(10),            /*供应厂商编号                           */
                                     /*供應廠商編號                           */
pmw04       varchar2(4),             /*交易币种                               */
                                     /*交易幣別                               */
pmw06       date,                    /*询价日期                               */
                                     /*詢價日期                               */
pmwacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼(Y/N)                        */
pmwuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
pmwgrup     varchar2(10),            /*资料所有部门                           */
                                     /*資料所有部門                           */
pmwmodu     varchar2(10),            /*资料更改者                             */
                                     /*資料修改者                             */
pmwdate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
pmw05       varchar2(4),             /*税种                                   */
pmw051      number(9,4),             /*税率                                   */
pmw07       varchar2(1),             /*价格类型                               */
                                     /*1.P/O  2. Subcontracting               */
pmwplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
pmwlegal    varchar2(10) NOT NULL,   /*所属法人                               */
pmworiu     varchar2(10),            /*资料建立者                             */
pmworig     varchar2(10)             /*资料建立部门                           */
);

alter table pmw_file add  constraint pmw_pk primary key  (pmw01) enable validate;
grant select on pmw_file to tiptopgp;
grant update on pmw_file to tiptopgp;
grant delete on pmw_file to tiptopgp;
grant insert on pmw_file to tiptopgp;
grant index on pmw_file to public;
grant select on pmw_file to ods;
