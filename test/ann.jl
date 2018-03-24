@testset "SimpleANN" begin
    @testset "Construction" begin
        let net = SimpleANN(2,1)
            @test net.insize == 2
            @test net.outsize == 1
            @test net.weights == zeros(1,2)
            @test net.thresholds == zeros(1)
        end

        let net = SimpleANN(zeros(3,2), zeros(3))
            @test net.insize == 2
            @test net.outsize == 3
            @test net.weights == zeros(3,2)
            @test net.thresholds == zeros(3)
        end

        @test_throws ArgumentError SimpleANN(0,2)
        @test_throws ArgumentError SimpleANN(2,0)

        @test_throws DimensionMismatch SimpleANN(zeros(3,2), zeros(2))
    end

    @testset "Fire" begin
        let net = SimpleANN([1. -1.], [0.])
            xs = [0,0]
            @test fire(net, xs) == [0]
            @test xs == [0,0]

            xs = [1,0]
            @test fire(net, xs) == [1]
            @test xs == [1,0]

            xs = [0,1]
            @test fire(net, xs) == [0]
            @test xs == [0,1]

            xs = [1,1]
            @test fire(net, xs) == [0]
            @test xs == [1,1]
        end
    end

    @testset "Fire!" begin
        let net = SimpleANN([1. -1.], [0.])
            xs, ys, expect = [0,0], [0], [0]
            @test fire!(net, xs, ys) == expect
            @test ys == expect
            @test xs == [0,0]

            xs, ys, expect = [1,0], [0], [1]
            @test fire!(net, xs, ys) == expect
            @test ys == expect
            @test xs == [1,0]

            xs, ys, expect = [0,1], [0], [0]
            @test fire!(net, xs, ys) == [0]
            @test xs == [0,1]

            xs, ys, expect = [1,1], [0], [0]
            @test fire!(net, xs, ys) == [0]
            @test xs == [1,1]
        end
    end
end
