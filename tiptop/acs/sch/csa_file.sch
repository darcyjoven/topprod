/*
================================================================================
檔案代號:csa_file
檔案名稱:料件成本要素模拟资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table csa_file
(
csa01       varchar2(40) NOT NULL,   /*料件编号                               */
csa02       varchar2(1) NOT NULL,    /*模拟编号                               */
csa03       varchar2(1),             /*成本方式                               */
csa0301     number(20,6),            /*本阶材料成本                           */
csa0302     number(20,6),            /*本阶材料制造费用(间接材料)             */
csa0303     number(20,6),            /*本阶人工成本                           */
csa0304     number(20,6),            /*本阶人工制造费用(间接人工)             */
csa0305     number(20,6),            /*本阶固定制造费用成本                   */
csa0306     number(20,6),            /*本阶变动制造费用成本                   */
csa0307     number(20,6),            /*本阶委外加工成本                       */
csa0308     number(20,6),            /*本阶委外加工固定制造费用成             */
csa0309     number(20,6),            /*本阶委外加工变动制造费用成             */
csa0310     number(20,6),            /*本阶机器成本                           */
csa0311     number(20,6),            /*采购成本                               */
csa0312     number(20,6),            /*本阶附加成本                           */
csa0321     number(20,6),            /*下阶材料成本                           */
csa0322     number(20,6),            /*下阶材料制造费用成本                   */
                                     /*下階材料製造費用成本(間接材料)         */
csa0323     number(20,6),            /*下阶人工成本                           */
csa0324     number(20,6),            /*下阶人工制造费用成本                   */
                                     /*下階人工製造費用成本(間接人工)         */
csa0325     number(20,6),            /*下阶固定制造成本                       */
csa0326     number(20,6),            /*下阶变动制造成本                       */
csa0327     number(20,6),            /*下阶委外加工成本                       */
csa0328     number(20,6),            /*下阶委外加工固定制造费用成             */
csa0329     number(20,6),            /*下阶委外加工变动制造费用成             */
csa0330     number(20,6),            /*下阶机器成本                           */
csa0331     number(20,6),            /*下阶附加成本                           */
csaacti     varchar2(1),             /*资料有效码                             */
csauser     varchar2(10),            /*资料所有者                             */
csagrup     varchar2(10),            /*资料所有群                             */
csamodu     varchar2(10),            /*资料更改者                             */
csadate     date,                    /*最近更改日                             */
csaplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
csalegal    varchar2(10) NOT NULL,   /*所属法人                               */
csaorig     varchar2(10),            /*资料建立部门                           */
csaoriu     varchar2(10)             /*资料建立者                             */
);

alter table csa_file add  constraint csa_pk primary key  (csa01,csa02) enable validate;
grant select on csa_file to tiptopgp;
grant update on csa_file to tiptopgp;
grant delete on csa_file to tiptopgp;
grant insert on csa_file to tiptopgp;
grant index on csa_file to public;
grant select on csa_file to ods;
