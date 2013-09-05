# クラス設計

## 侍クラス
物理物体 : B2body -> position, friction
画像 : CCSprite -> position, filename
ヒットポイント
攻撃
ジャンプ

- Samurai.h

## 雑魚クラス
物理物体 : B2body -> position, friction
画像 : CCSprite -> position, filename
飛び道具（何を生成するか）：-(Projectile*)generateProjectile()

- Zako.h
    - 忍者
    - Ninja.h
## ボスクラス
- Boss.h
    - 相撲レスラー
    - Sumou.h

## 飛び道具クラス
- Projectile.h

## ゲームステージクラス
敵の配置を難易度に従って決める
背景
敵を消したり
飛び道具
ボス戦かどうか
ボス戦ならボスの動きを管理

- Stage.h
    - StageNinja.h
    - StageKyoto.h

## ゲーム画面管理
- GameController.h
    - 侍
    - ステージ
    - 当たり判定
    - スコア

## トップ画面

## ハイスコア画面
