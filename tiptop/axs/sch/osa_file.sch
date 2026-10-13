/*
================================================================================
檔案代號:osa_file
檔案名稱:销售目标单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table osa_file
(
osa01       varchar2(20) NOT NULL,   /*目标单号                               */
                                     /*目標單號                               */
osa02       date,                    /*设置日期                               */
                                     /*設定日期                               */
osa03       varchar2(10),            /*帐款客户编号                           */
                                     /*帳款客戶編號                           */
osa04       varchar2(10),            /*送货客户编号                           */
                                     /*送貨客戶編號                           */
osa05       varchar2(1),             /*目标类型                               */
                                     /*目標類別 1.訂單  2.出貨                */
osa06       varchar2(10),            /*帐款客户分类                           */
                                     /*帳款客戶分類                           */
osa14       varchar2(10),            /*业务员编号                             */
                                     /*業務員編號                             */
osa15       varchar2(10),            /*部门编号                               */
                                     /*部門編號                               */
osa23       varchar2(4),             /*币种                                   */
                                     /*幣別                                   */
osa24       number(20,10),           /*汇率                                   */
                                     /*匯率                                   */
osa25       varchar2(10),            /*销售分类一                             */
                                     /*銷售分類一                             */
osa26       varchar2(10),            /*销售分类二                             */
                                     /*銷售分類二                             */
osa90       varchar2(10),            /*产品分类                               */
                                     /*產品分類                               */
osauser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
osagrup     varchar2(10),            /*资料所有部门                           */
                                     /*資料所有部門                           */
osamodu     varchar2(10),            /*资料更改者                             */
                                     /*資料修改者                             */
osadate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
osalegal    varchar2(10) NOT NULL,   /*所属法人                               */
osaplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
osaoriu     varchar2(10),            /*资料建立者                             */
osaorig     varchar2(10)             /*资料建立部门                           */
);

alter table osa_file add  constraint osa_pk primary key  (osa01) enable validate;
grant select on osa_file to tiptopgp;
grant update on osa_file to tiptopgp;
grant delete on osa_file to tiptopgp;
grant insert on osa_file to tiptopgp;
grant index on osa_file to public;
grant select on osa_file to ods;
