#import "@preview/numbly:0.1.0": numbly
#import "@preview/timeliney:0.4.0"
#import "@preview/colorful-boxes:1.4.3"
#import "@preview/percencode:0.1.0": percent-decode
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node
#import "@preview/touying:0.6.1": *
#import themes.metropolis: *
// #import "@preview/touying-unistra-pristine:1.4.2": *
#import fletcher.shapes;

#import colorful-boxes: *;

#let formal = false
#let horizontal = true

#if sys.inputs.pairs().len() == 2 {
  formal = if sys.inputs.formal == "true" { true } else { false };
  horizontal = if sys.inputs.horizontal == "true" { true } else { false };
}

#set text(
  lang: "zh",
  region: "tw",
  size: 12pt,
  font: (
    (name: "Manrope", covers: "latin-in-cjk"),
    "Source Han Sans HC",
  ),
) 
#set text(
  font: (
    (name: "Times New Roman", covers: "latin-in-cjk"),
    "TW-MOE-Std-Kai",
  ),
) if formal == true
#set page(
  numbering: numbly("{1}", "第{1}頁/共{2}頁"),
)

#show "贰":"貳"
#show "叁":"參"
#show "陆":"陸"

#show par: set par(first-line-indent: (amount: 2em, all: true))

#show selector(<nonumber>): set heading(
  numbering: none,
)
#show selector(<nooutline>): set heading(
  numbering: none,
  outlined: false,
)

#let noindent(body) = {
  set par(first-line-indent: (amount: 0em))
  body
}


#show outline.entry: it => {
  if it.at("label", default: none) == <processed> {
    return it
  }

  if it.element.at("label", default: none) == <nonumber> {
    return [#text(size: 10pt, fill: luma(100))[#outline.entry(
        it.level * 3 - 4,
        fill: it.fill,
      )[#it.element]  #label("processed")]]
  }

  it
}

#show ref: it => {
  let ele = it.element
  if ele != none and ele.func() == heading {
    let func = ele.numbering
    let depth = counter(heading).at(it.target)
    let out = func(..depth)

    let out = " " + out.trim("、 ")

    [#link(ele.location(), ele.supplement + out) #label("generated-from-ref")]
  } else {
    it
  }
}

#show link: it => {
  if it.at("label", default: none) != <generated-from-ref> {
    return text(blue)[#it]
  }
  it
}

#show bibliography: it => {
  show link: ele => {
    if ele.at("label", default: none) == <processed> {
      return ele
    }

    [#link(ele.dest, percent-decode(ele.body.text)) #label("processed")]
  }
  it
}

#show raw.where(block: false): set text(1em * (5 / 4))

#show raw.where(block: false): it => highlight(
  fill: luma(200),
  extent: 2pt,
)[#it]

#show raw.where(block: true): it => block(
  fill: luma(230),
  inset: 8pt,
  radius: 5pt,
  it,
)



#set heading(
  numbering: numbly(
    "{1:壹}、",
    "{2:一}、 ",
    "{3:（一）}",
  ),
)

#show: metropolis-theme.with(
  aspect-ratio: "4-3",
  footer: self => self.info.title,
  navigation: "none",
  config-info(
    title: [遙控車專題製作中期報告],
    // subtitle: [Subtitle],
    author: [薛詠謙、吳彥廷],
    date: datetime.today(),
    institution: [內壢高中],
  ),
  config-page(
    margin: (x: 4em),
  ),
  config-common(slide-level: 2)
)


#title-slide()

#outline(title: none, indent: 1em, depth: 1)

= 參考圖片
== 參考圖片 <nooutline>
#grid(
  columns: (1fr, 1fr),
  align: horizon + center,
)[
  #figure(
    image("vr1-inspiration.png", height: 12em),
    caption: [深降式吊車]
  )
][
  #figure(
    block(
      inset: (top: -10pt, bottom: -20pt, right: -30pt, left: -40pt),
      clip: true,
      height: 12em,
      image("wheels-powered.png", height: 100%)
    ),
    caption: [齒輪驅動式機械臂]
  ) 
]

= 專案管理
== 甘特圖 <nooutline>
#figure(
  caption: figure.caption(position: top)[
    #highlight(
      fill: luma(200),
    )[Nxx = Nov. xx, Dxx = Dec.xx]],
  kind: table,
)[
  #timeliney.timeline(
    show-grid: true,
    {
      import timeliney: *

      headerline(group(([保麗龍打樣及測試], 4)), group(([木板設計、組裝與除錯], 4)))
      headerline(
        group(..("N14", "N21", "N26", "N28", "D03", "D05", "D12", "D19")),
        // group(range(13,20).map(n => strong("10/" + str(n)))),
      )

      taskgroup(
        title: [*底版設計*],
        style: (stroke: 5pt + black),
        {
          task(
            "打樣的切割與組裝",
            (from: 0, to: 1),
            style: (stroke: 2pt + gray),
          )
          task(
            "無線控制模組",
            (from: 1, to: 2),
            style: (stroke: 2pt + gray),
          )
        },
      )

      taskgroup(
        title: [*機械臂與夾子設計*],
        style: (stroke: 5pt + blue),
        {
          task("線拉式軌道系統", (.5, 1), style: (stroke: 2pt + aqua))
          task("齒輪驅動機械臂", (1, 3), style: (stroke: 2pt + aqua))
          task("線拉式機械臂", (3, 4), style: (stroke: 2pt + aqua))
        },
      )

      taskgroup(
        // title: [*成果展現*],
        style: (stroke: 5pt + red),
        {
          task("rhino 初稿", (4, 5), style: (stroke: 2pt + maroon))
          task("木板及輪胎組裝", (5, 6), style: (stroke: 2pt + maroon))
          task("機械臂組裝", (6, 7), style: (stroke: 2pt + maroon))
        },
      )
    },
  )
]

#if horizontal {
  pagebreak()
}


#let ball = "任務五"
#let pyrmaid = "任務一"

= 得分策略
== 策略

#ball (@mission-5) 佔分比重最大。因此我們的策略是以『優先完成任務五』為核心，需確保#highlight(fill: blue.lighten(75%))[機械手臂]具備足夠的*垂直行程*與*穩定性*。次要目標鎖定任務一與二。

 針對平面且無障礙物的地形（@terrain），我們決定不採用四輪驅動（@four-wheels），而是利用兩輪驅動 + 一個萬向輪的三輪車組合，以減少結構複雜性（@three-wheel-blueprint）。

#grid(
  rows: 4,
  columns: 4,
  gutter: 1em,
)[
  #figure(
    image("mission-1.png"),
    caption: [任務一]
  ) #label("mission-1")
][
  #figure(
    image("mission-2.png"),
    caption: [任務二]
  ) #label("mission-2")
][
  #figure(
    image("mission-3.png"),
    caption: [任務三]
  ) #label("mission-3")
][
  #figure(
    image("mission-4.png"),
    caption: [任務四]
  ) #label("mission-4")
][
  #figure(
    image("mission-5.png"),
    caption: [任務五]
  ) #label("mission-5")
][
  #figure(
    image("terrain.png"),
    caption: [地形]
  ) <terrain>
][
  #figure(
    image("four-wheels.png"),
    caption: [四輪車]
  ) <four-wheels>
][
  #figure(
    image("blueprint.png"),
    caption: [三輪車]
  ) <three-wheel-blueprint>
]

= 打樣作品及修改記錄
== 線拉式軌道系統

#grid(
  columns: (1fr, 1fr, 1fr),
  align: horizon + center,
)[
  #figure(
    image("vr1-inspiration.png", height: 8em),
    caption: [深降式吊車]
  ) <inspiration>
][
  #figure(
    block(
      inset: (top: -10pt, bottom: -20pt, right: -30pt, left: -40pt),
      clip: true,
      height: 8em,
      image("linear-trailing-system.png", height: 100%)
    ),
    caption: [機身打樣前視圖]
  ) <linear-trailing-system-base>
][
  #figure(
    block(
      inset: (top: -20pt, bottom: -40pt, right: -67pt, left: -60pt),
      clip: true,
      height: 8em,
      image("linear-trailing-system-claw.png")
    ),
    caption: [夾子打樣式樣]
  ) <linear-trailing-system-claw>
  
]

此設計為最一開始想到的最簡可行產品(MVC)，此設計受 @inspiration 啟發，只花了我們不到一小時就組裝完成並且成功測試（見 @linear-trailing-system-base）。由 @linear-trailing-system-claw 可見，夾子*沒有*馬達驅動，我們設想單純利用*固定式*之夾子設計即可成功拿到球，但遇到以下問題：由於下降時是依靠重力，而非馬達，會受配重及摩擦力影響。

#show table: it => block(stroke: 1pt, radius: 1em, clip: true, it)

#let title(string, body) = {
  box(height: 8em, width: 100%)[
    #grid(
      // stroke: 1pt + red,
      columns: 1fr,
      inset: .8em,
      rows: (1fr, 5fr)
    )[
      #align(center + horizon)[
         === #string <nooutline>
      ]
    ][
      #body
    ]
  ]
}

#let swot(arr, capt) = {
  figure(
    caption: capt + "之 SWOT 分析",
    table(
      rows: 2,
      stroke: 1pt,
      align: left,
      columns: (1fr, 1fr),
      inset: 1em,
      fill: (x, y) => {
        if (x,y) == (0,0) {
          green
        } else if (x,y) == (1,0){
          blue
        } else if (x,y) == (0,1) {
          yellow
        } else if (x,y) == (1,1) {
          orange
        }.lighten(65%)
      }
    )[
      #title("優勢", arr.at(0))
    ][
      #title("劣勢", arr.at(1))
    ][
      #title("機會", arr.at(2))
    ][
      #title("威脅", arr.at(3))
    ]
  )
}

#swot(
  (
    [
      - 運動部件少，只存在拉繩馬達。
      - 較易操作，上下調整精細度高。
    ],
    [
      - 夾子的寬度需要非常剛好才可以夾起球。
      - 下降時穩定性不足，有時會卡住無法移動。
    ],
    [
      - #ball
      - #pyrmaid
      兩者皆為「將物品抬升」的任務，與此設計契合度高。
    ],
    [
      其餘任務利用此系統皆不易達成。
    ]
  ),
  "線拉式軌道系統"
)

此設計本質上就是*簡易*、*不易出錯*，但也#highlight(fill: aqua.lighten(50%))[不易擴充]。我們希望能夠達成更多的任務，因此決定從頭再來，重新設計一個更萬用的機械臂。

=== 齒輪驅動機械臂

=== 線拉式機械臂

= 設計發展 (含水平及垂直發展、精密描寫、三視圖說、色彩計畫等、完整陳述製作內容、方法 、表現形式、材質、數量、規格等，各發表階段之照片及提報文字介紹)
= 作品與功能說明 (作品整體的使用說明/酷卡/說明卡)
= 成品與細節照片
= 資料來源
