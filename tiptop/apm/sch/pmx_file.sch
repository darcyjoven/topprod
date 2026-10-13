/*
================================================================================
檔案代號:pmx_file
檔案名稱:采购料件询价单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table pmx_file
(
pmx01       varchar2(20) NOT NULL,   /*询价单号                               */
                                     /*詢價單號                               */
pmx02       number(5) NOT NULL,      /*序号                                   */
                                     /*序號                                   */
                                     /*詢價單上項次順序                       */
pmx03       number(15,3),            /*下限数量                               */
                                     /*下限數量                               */
pmx04       date,                    /*生效日期                               */
                                     /*記錄該詢價項次有效起始日期             */
pmx05       date,                    /*失效日期                               */
                                     /*記錄該詢價項次有效終止日期             */
pmx06       number(20,6),            /*询价税前单价                           */
                                     /*詢價單價                       (97/07) */
pmx07       number(9,4),             /*折扣比率                               */
                                     /*折扣比率%                              */
pmx08       varchar2(40),            /*料件编号                               */
                                     /*料件編號                               */
pmx081      varchar2(120),           /*品名                                   */
                                     /*品名  00/04/06 add                     */
pmx082      varchar2(120),           /*规格                                   */
pmx09       varchar2(4),             /*询价单位                               */
pmx06t      number(20,6),            /*询价含税单价                           */
pmx10       varchar2(6) NOT NULL,    /*作业编号                               */
pmx11       varchar2(1),             /*价格类型                               */
                                     /*1.P/O  2. Subcontracting               */
pmx12       varchar2(10) NOT NULL,   /*供应厂商编号                           */
pmx13       varchar2(10) NOT NULL,   /*工艺单元编号,为空代表此笔数            */
pmxplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
pmxlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table pmx_file add  constraint pmx_pk primary key  (pmx01,pmx02,pmx10,pmx12,pmx13) enable validate;
grant select on pmx_file to tiptopgp;
grant update on pmx_file to tiptopgp;
grant delete on pmx_file to tiptopgp;
grant insert on pmx_file to tiptopgp;
grant index on pmx_file to public;
grant select on pmx_file to ods;
